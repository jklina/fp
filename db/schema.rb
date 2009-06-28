# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090628054309) do

  create_table "authorships", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
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

  create_table "reviews", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.text     "comment"
    t.boolean  "by_administrator", :default => false
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
    t.boolean  "trashed",                  :default => false
    t.boolean  "moderated",                :default => false
    t.integer  "views",                    :default => 0
    t.integer  "downloads",                :default => 0
    t.string   "preview_file_name"
    t.string   "preview_content_type"
    t.integer  "preview_file_size"
    t.datetime "preview_updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
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
    t.integer  "access_level",             :default => 1
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
    t.boolean  "confirmed",                :default => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "authentication_token"
  end

end
