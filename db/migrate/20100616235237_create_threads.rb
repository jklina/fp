class CreateThreads < ActiveRecord::Migration
  def self.up
    create_table :threads do |t|
      t.string    :title
      t.integer   :last_poster_id
      t.datetime  :last_post_at

      t.timestamps
    end
  end

  def self.down
    drop_table :threads
  end
end
