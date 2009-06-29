class AddFeaturedAtToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :featured_at, :datetime

    say_with_time "Setting featured_at for featured submissions..." do
      Featuring.find(:all).each do |f|
        s = Submission.find_by_id(f.submission_id)
        
        next unless s
        
        s.featured_at = f.created_at
        s.save(false)
      end
    end
  end

  def self.down
    remove_column :submissions, :featured_at
  end
end
