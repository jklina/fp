# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110624211043) do

  create_table "announcements", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorships", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorships", ["submission_id"], :name => "index_authorships_on_submission_id"
  add_index "authorships", ["user_id"], :name => "index_authorships_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "title"
    t.string   "preview_file_name"
    t.string   "preview_content_type"
    t.integer  "preview_file_size"
    t.datetime "preview_updated_at"
  end

  create_table "featurings", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "feature_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",     :default => 0, :null => false
  end

  create_table "forums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_group_id"
    t.integer  "weight",         :default => 0, :null => false
  end

  create_table "notifications", :force => true do |t|
    t.text     "description"
    t.boolean  "read",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.integer  "initiator_id"
  end

  create_table "posts", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "thread_id"
    t.integer  "forum_id"
    t.integer  "topic_id"
    t.integer  "user_id"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.text     "comment"
    t.boolean  "by_administrator", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "body"
    t.string   "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "user_rating"
    t.float    "user_rating_lower_bound"
    t.float    "user_rating_upper_bound"
    t.float    "admin_rating"
    t.float    "admin_rating_lower_bound"
    t.float    "admin_rating_upper_bound"
    t.boolean  "trashed",                    :default => false
    t.boolean  "moderated",                  :default => false
    t.integer  "views",                      :default => 0
    t.integer  "downloads",                  :default => 0
    t.string   "preview_file_name"
    t.string   "preview_content_type"
    t.integer  "preview_file_size"
    t.datetime "preview_updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "featured_at"
    t.float    "average_rating"
    t.float    "average_rating_upper_bound"
    t.float    "average_rating_lower_bound"
  end

  add_index "submissions", ["trashed", "moderated"], :name => "index_submissions_on_trashed_and_moderated"

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.integer  "last_poster_id"
    t.datetime "last_post_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.integer  "user_id"
    t.text     "content"
    t.integer  "view",           :default => 0, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "last_login_time"
    t.string   "location"
    t.string   "country"
    t.string   "email"
    t.string   "aim"
    t.string   "msn"
    t.string   "icq"
    t.string   "yahoo"
    t.string   "website"
    t.text     "current_projects"
    t.integer  "access_level",               :default => 1
    t.string   "password_salt"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.string   "username"
    t.float    "user_rating"
    t.float    "user_rating_lower_bound"
    t.float    "user_rating_upper_bound"
    t.float    "admin_rating"
    t.float    "admin_rating_lower_bound"
    t.float    "admin_rating_upper_bound"
    t.boolean  "confirmed",                  :default => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "authentication_token"
    t.string   "time_zone"
    t.float    "average_rating"
    t.float    "average_rating_upper_bound"
    t.float    "average_rating_lower_bound"
    t.string   "displayed_email"
  end

  add_index "users", ["username"], :name => "index_users_on_username"

end
