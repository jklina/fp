class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :submission_id
      t.integer :user_id
      t.integer :rating
      t.text    :comment
      t.boolean :by_administrator, :default => false
      t.timestamps
    end

    say_with_time "Merging ratings and comments..." do
      Submission.find(:all).each do |s|
        reviews = {}

        s.ratings.each do |r|
          id = r.user_id

          reviews[id] = Review.new(:rating => r.rating)
          reviews[id].submission_id = r.submission_id
          reviews[id].user_id = id
          reviews[id].by_administrator = r.admin > 0
          reviews[id].created_at = r.created_at
          reviews[id].updated_at = r.updated_at
        end

        s.comments.each do |c|
          id = c.user_id

          if !reviews[id].nil?
            reviews[id].comment = c.comment
            reviews[id].created_at = c.created_at if reviews[id].created_at > c.created_at
            reviews[id].updated_at = c.created_at if reviews[id].updated_at > c.created_at
          else
            reviews[id] = Review.new(:comment => c.comment)
            reviews[id].submission_id = c.submission_id
            reviews[id].user_id = id
            reviews[id].created_at = c.created_at
            reviews[id].updated_at = c.created_at

            u = User.find(id)
            reviews[id].by_administrator = u.access_level > User::Role::REGULAR
          end
        end

        reviews.each_value do |r|
          r.save!
        end
      end
    end

    drop_table :ratings
    drop_table :comments
  end

  def self.down
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :submission_id
      t.integer :admin
      t.integer :rating
      t.timestamps
    end

    create_table :comments do |t|
      t.integer  :user_id
      t.integer  :submission_id
      t.text     :comment
      t.datetime :created_at
    end

    say_with_time "Splitting reviews and comments..." do
      Submission.find(:all).each do |s|
        s.reviews.each do |r|
          uid = r.user_id
          sid = r.submission_id

          if r.rating?
            rating = Rating.new(:rating => r.rating)
            rating.user_id = uid
            rating.submission_id = sid
            rating.admin = (r.by_administrator ? 1 : 0)
            rating.created_at = r.created_at
            rating.updated_at = r.udpated_at
            rating.save!
          end

          if r.comment?
            comment = Comment.new(:comment => r.comment)
            comment.user_id = uid
            comment.submission_id = sid
            comment.created_at = r.created_at
            comment.save!
          end
        end
      end
    end

    drop_table :reviews
  end
end
