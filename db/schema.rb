# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151031211310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "accounts", force: true do |t|
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "franchisee"
    t.string   "legacy_id"
    t.string   "email_address"
    t.string   "forgot_password_key"
    t.string   "mailchimp_api_key"
    t.string   "callfire_app_login"
    t.string   "callfire_app_password"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "articles", force: true do |t|
    t.string   "title"
    t.string   "url_name"
    t.text     "summary"
    t.text     "body"
    t.text     "article_url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "legacy_id"
  end

  create_table "blog_blog_categories", force: true do |t|
    t.integer  "blog_id"
    t.integer  "blog_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_blog_categories", ["blog_category_id"], name: "index_blog_blog_categories_on_blog_category_id", using: :btree
  add_index "blog_blog_categories", ["blog_id"], name: "index_blog_blog_categories_on_blog_id", using: :btree

  create_table "blog_categories", force: true do |t|
    t.string   "name"
    t.string   "url_name"
    t.string   "legacy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", force: true do |t|
    t.string   "title"
    t.string   "url_name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "summary"
    t.text     "body"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "legacy_id"
    t.string   "carousel_image_file_name"
    t.string   "carousel_image_content_type"
    t.integer  "carousel_image_file_size"
    t.datetime "carousel_image_updated_at"
    t.string   "carousel_text"
    t.text     "fb_conversion_pixel"
    t.string   "status",                      default: "published"
    t.datetime "publish_date"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "franchising_requests", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "market"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "request_url"
    t.integer  "visit_id"
  end

  add_index "franchising_requests", ["visit_id"], name: "index_franchising_requests_on_visit_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "url_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "email_address_for_inquiries"
    t.string   "phone_number"
    t.string   "general_contact_name"
    t.text     "description"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "floorplan_image_file_name"
    t.string   "floorplan_image_content_type"
    t.integer  "floorplan_image_file_size"
    t.datetime "floorplan_image_updated_at"
    t.text     "chat_code"
    t.string   "image_1_file_name"
    t.string   "image_1_content_type"
    t.integer  "image_1_file_size"
    t.datetime "image_1_updated_at"
    t.string   "image_2_file_name"
    t.string   "image_2_content_type"
    t.integer  "image_2_file_size"
    t.datetime "image_2_updated_at"
    t.string   "image_3_file_name"
    t.string   "image_3_content_type"
    t.integer  "image_3_file_size"
    t.datetime "image_3_updated_at"
    t.string   "image_4_file_name"
    t.string   "image_4_content_type"
    t.integer  "image_4_file_size"
    t.datetime "image_4_updated_at"
    t.string   "image_5_file_name"
    t.string   "image_5_content_type"
    t.integer  "image_5_file_size"
    t.datetime "image_5_updated_at"
    t.string   "image_6_file_name"
    t.string   "image_6_content_type"
    t.integer  "image_6_file_size"
    t.datetime "image_6_updated_at"
    t.string   "image_7_file_name"
    t.string   "image_7_content_type"
    t.integer  "image_7_file_size"
    t.datetime "image_7_updated_at"
    t.string   "image_8_file_name"
    t.string   "image_8_content_type"
    t.integer  "image_8_file_size"
    t.datetime "image_8_updated_at"
    t.string   "image_9_file_name"
    t.string   "image_9_content_type"
    t.integer  "image_9_file_size"
    t.datetime "image_9_updated_at"
    t.string   "image_10_file_name"
    t.string   "image_10_content_type"
    t.integer  "image_10_file_size"
    t.datetime "image_10_updated_at"
    t.string   "legacy_id"
    t.string   "image_11_file_name"
    t.string   "image_11_content_type"
    t.integer  "image_11_file_size"
    t.datetime "image_11_updated_at"
    t.string   "image_12_file_name"
    t.string   "image_12_content_type"
    t.integer  "image_12_file_size"
    t.datetime "image_12_updated_at"
    t.string   "image_13_file_name"
    t.string   "image_13_content_type"
    t.integer  "image_13_file_size"
    t.datetime "image_13_updated_at"
    t.string   "image_14_file_name"
    t.string   "image_14_content_type"
    t.integer  "image_14_file_size"
    t.datetime "image_14_updated_at"
    t.string   "image_15_file_name"
    t.string   "image_15_content_type"
    t.integer  "image_15_file_size"
    t.datetime "image_15_updated_at"
    t.string   "image_16_file_name"
    t.string   "image_16_content_type"
    t.integer  "image_16_file_size"
    t.datetime "image_16_updated_at"
    t.string   "image_17_file_name"
    t.string   "image_17_content_type"
    t.integer  "image_17_file_size"
    t.datetime "image_17_updated_at"
    t.string   "image_18_file_name"
    t.string   "image_18_content_type"
    t.integer  "image_18_file_size"
    t.datetime "image_18_updated_at"
    t.string   "image_19_file_name"
    t.string   "image_19_content_type"
    t.integer  "image_19_file_size"
    t.datetime "image_19_updated_at"
    t.string   "image_20_file_name"
    t.string   "image_20_content_type"
    t.integer  "image_20_file_size"
    t.datetime "image_20_updated_at"
    t.string   "status"
    t.integer  "admin_id"
    t.integer  "msa_id"
    t.text     "move_in_special"
    t.text     "open_house"
    t.string   "pinterest_url"
    t.string   "instagram_url"
    t.string   "yelp_url"
    t.string   "directory_image_1_file_name"
    t.string   "directory_image_1_content_type"
    t.integer  "directory_image_1_file_size"
    t.datetime "directory_image_1_updated_at"
    t.string   "directory_image_2_file_name"
    t.string   "directory_image_2_content_type"
    t.integer  "directory_image_2_file_size"
    t.datetime "directory_image_2_updated_at"
    t.string   "directory_image_3_file_name"
    t.string   "directory_image_3_content_type"
    t.integer  "directory_image_3_file_size"
    t.datetime "directory_image_3_updated_at"
    t.string   "directory_image_4_file_name"
    t.string   "directory_image_4_content_type"
    t.integer  "directory_image_4_file_size"
    t.datetime "directory_image_4_updated_at"
    t.string   "directory_image_5_file_name"
    t.string   "directory_image_5_content_type"
    t.integer  "directory_image_5_file_size"
    t.datetime "directory_image_5_updated_at"
    t.string   "directory_image_6_file_name"
    t.string   "directory_image_6_content_type"
    t.integer  "directory_image_6_file_size"
    t.datetime "directory_image_6_updated_at"
    t.string   "directory_image_7_file_name"
    t.string   "directory_image_7_content_type"
    t.integer  "directory_image_7_file_size"
    t.datetime "directory_image_7_updated_at"
    t.string   "directory_image_8_file_name"
    t.string   "directory_image_8_content_type"
    t.integer  "directory_image_8_file_size"
    t.datetime "directory_image_8_updated_at"
    t.string   "directory_image_9_file_name"
    t.string   "directory_image_9_content_type"
    t.integer  "directory_image_9_file_size"
    t.datetime "directory_image_9_updated_at"
    t.string   "directory_image_10_file_name"
    t.string   "directory_image_10_content_type"
    t.integer  "directory_image_10_file_size"
    t.datetime "directory_image_10_updated_at"
    t.string   "directory_image_11_file_name"
    t.string   "directory_image_11_content_type"
    t.integer  "directory_image_11_file_size"
    t.datetime "directory_image_11_updated_at"
    t.string   "directory_image_12_file_name"
    t.string   "directory_image_12_content_type"
    t.integer  "directory_image_12_file_size"
    t.datetime "directory_image_12_updated_at"
    t.text     "mailchimp_list_ids"
    t.text     "callfire_list_ids"
    t.text     "custom_maps_url"
    t.text     "tracking_code"
  end

  add_index "locations", ["admin_id"], name: "index_locations_on_admin_id", using: :btree
  add_index "locations", ["msa_id"], name: "index_locations_on_msa_id", using: :btree
  add_index "locations", ["state"], name: "index_locations_on_state", using: :btree
  add_index "locations", ["status"], name: "index_locations_on_status", using: :btree
  add_index "locations", ["url_name"], name: "index_locations_on_url_name", using: :btree

  create_table "msas", force: true do |t|
    t.string   "name"
    t.string   "url_name"
    t.string   "legacy_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "msas", ["name"], name: "index_msas_on_name", using: :btree
  add_index "msas", ["url_name"], name: "index_msas_on_url_name", using: :btree

  create_table "partner_inquiries", force: true do |t|
    t.string   "subject"
    t.string   "name"
    t.string   "company_name"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "request_url"
    t.integer  "visit_id"
  end

  add_index "partner_inquiries", ["visit_id"], name: "index_partner_inquiries_on_visit_id", using: :btree

  create_table "request_tour_inquiries", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.string   "request_url"
    t.integer  "visit_id"
  end

  add_index "request_tour_inquiries", ["location_id"], name: "index_request_tour_inquiries_on_location_id", using: :btree
  add_index "request_tour_inquiries", ["visit_id"], name: "index_request_tour_inquiries_on_visit_id", using: :btree

  create_table "stylist_messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.integer  "stylist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visit_id"
  end

  add_index "stylist_messages", ["stylist_id"], name: "index_stylist_messages_on_stylist_id", using: :btree
  add_index "stylist_messages", ["visit_id"], name: "index_stylist_messages_on_visit_id", using: :btree

  create_table "stylists", force: true do |t|
    t.string   "name"
    t.string   "url_name"
    t.text     "biography"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "studio_number"
    t.text     "work_hours"
    t.string   "website_url"
    t.string   "business_name"
    t.boolean  "hair"
    t.boolean  "skin"
    t.boolean  "nails"
    t.boolean  "massage"
    t.boolean  "teeth_whitening"
    t.boolean  "eyelash_extensions"
    t.boolean  "makeup"
    t.boolean  "tanning"
    t.boolean  "waxing"
    t.boolean  "brows"
    t.boolean  "accepting_new_clients"
    t.string   "booking_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.string   "legacy_id"
    t.string   "status"
    t.string   "image_1_file_name"
    t.string   "image_1_content_type"
    t.integer  "image_1_file_size"
    t.datetime "image_1_updated_at"
    t.string   "image_2_file_name"
    t.string   "image_2_content_type"
    t.integer  "image_2_file_size"
    t.datetime "image_2_updated_at"
    t.string   "image_3_file_name"
    t.string   "image_3_content_type"
    t.integer  "image_3_file_size"
    t.datetime "image_3_updated_at"
    t.string   "image_4_file_name"
    t.string   "image_4_content_type"
    t.integer  "image_4_file_size"
    t.datetime "image_4_updated_at"
    t.string   "image_5_file_name"
    t.string   "image_5_content_type"
    t.integer  "image_5_file_size"
    t.datetime "image_5_updated_at"
    t.string   "image_6_file_name"
    t.string   "image_6_content_type"
    t.integer  "image_6_file_size"
    t.datetime "image_6_updated_at"
    t.string   "image_7_file_name"
    t.string   "image_7_content_type"
    t.integer  "image_7_file_size"
    t.datetime "image_7_updated_at"
    t.string   "image_8_file_name"
    t.string   "image_8_content_type"
    t.integer  "image_8_file_size"
    t.datetime "image_8_updated_at"
    t.string   "image_9_file_name"
    t.string   "image_9_content_type"
    t.integer  "image_9_file_size"
    t.datetime "image_9_updated_at"
    t.string   "image_10_file_name"
    t.string   "image_10_content_type"
    t.integer  "image_10_file_size"
    t.datetime "image_10_updated_at"
    t.integer  "testimonial_id_1"
    t.integer  "testimonial_id_2"
    t.integer  "testimonial_id_3"
    t.integer  "testimonial_id_4"
    t.integer  "testimonial_id_5"
    t.integer  "testimonial_id_6"
    t.integer  "testimonial_id_7"
    t.integer  "testimonial_id_8"
    t.integer  "testimonial_id_9"
    t.integer  "testimonial_id_10"
    t.string   "location_name"
    t.boolean  "hair_extensions"
    t.boolean  "send_a_message_button", default: true
    t.string   "pinterest_url"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "instagram_url"
    t.string   "yelp_url"
    t.boolean  "laser_hair_removal"
    t.boolean  "threading"
    t.boolean  "permanent_makeup"
    t.string   "linkedin_url"
    t.string   "other_service"
    t.string   "google_plus_url"
  end

  add_index "stylists", ["location_id"], name: "index_stylists_on_location_id", using: :btree
  add_index "stylists", ["status"], name: "index_stylists_on_status", using: :btree
  add_index "stylists", ["url_name"], name: "index_stylists_on_url_name", using: :btree

  create_table "testimonials", force: true do |t|
    t.string   "name"
    t.text     "text"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "visits", force: true do |t|
    t.string   "ip_address"
    t.string   "user_agent_string"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
