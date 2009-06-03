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

ActiveRecord::Schema.define(:version => 20090531221415) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "submission_id"
    t.text     "comment"
    t.datetime "created_on"
  end

  create_table "featured_associations", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "featured_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featured_images", :force => true do |t|
    t.integer  "featured_id"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featureds", :force => true do |t|
    t.text     "comment"
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "submission_id"
    t.integer  "rating"
    t.boolean  "admin"
    t.integer  "rated_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_files", :force => true do |t|
    t.integer  "submission_id"
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
  end

  create_table "sub_images", :force => true do |t|
    t.integer  "submission_id"
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
  end

  create_table "submission_associations", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "submissions" because of following StandardError
#   Unknown type 'bool' for column 'owner_trash'

  create_table "user_images", :force => true do |t|
    t.integer  "user_id"
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
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
    t.float    "average_rating"
    t.float    "average_rating_lower_bound"
    t.float    "average_rating_upper_bound"
    t.float    "average_admin_rating"
    t.float    "average_admin_rating_lower_bound"
    t.float    "average_admin_rating_upper_bound"
    t.integer  "access_level",                     :default => 1
    t.boolean  "email_confirmation",               :default => false
    t.string   "email_confirmation_salt"
    t.string   "email_confirmation_hash"
    t.string   "password_salt"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
