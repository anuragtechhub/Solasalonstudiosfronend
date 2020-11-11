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

ActiveRecord::Schema.define(version: 20201111231657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "dblink"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"

  create_table "accounts", force: true do |t|
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "accounts", ["api_key"], name: "index_accounts_on_api_key", using: :btree

  create_table "admins", force: true do |t|
    t.text     "email",                                  null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "franchisee"
    t.string   "legacy_id"
    t.text     "email_address",                          null: false
    t.string   "forgot_password_key"
    t.string   "mailchimp_api_key"
    t.string   "callfire_app_login"
    t.string   "callfire_app_password"
    t.string   "sola_pro_country_admin"
    t.boolean  "onboarded",              default: false, null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["email_address"], name: "index_admins_on_email_address", using: :btree
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
    t.integer  "location_id"
    t.string   "display_setting",    default: "sola_website"
  end

  add_index "articles", ["location_id"], name: "index_articles_on_location_id", using: :btree

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

  create_table "blog_countries", force: true do |t|
    t.integer  "blog_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_countries", ["blog_id"], name: "index_blog_countries_on_blog_id", using: :btree
  add_index "blog_countries", ["country_id"], name: "index_blog_countries_on_country_id", using: :btree

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
    t.boolean  "contact_form_visible",        default: false
    t.text     "meta_description"
    t.string   "canonical_url"
  end

  add_index "blogs", ["status"], name: "index_blogs_on_status", using: :btree

  create_table "book_now_bookings", force: true do |t|
    t.string   "time_range"
    t.integer  "location_id"
    t.string   "query"
    t.json     "services"
    t.integer  "stylist_id"
    t.string   "booking_user_name"
    t.string   "booking_user_phone"
    t.string   "booking_user_email"
    t.string   "referring_url"
    t.string   "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "book_now_bookings", ["location_id"], name: "index_book_now_bookings_on_location_id", using: :btree
  add_index "book_now_bookings", ["stylist_id"], name: "index_book_now_bookings_on_stylist_id", using: :btree

  create_table "brand_countries", force: true do |t|
    t.integer  "brand_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_countries", ["brand_id"], name: "index_brand_countries_on_brand_id", using: :btree
  add_index "brand_countries", ["country_id"], name: "index_brand_countries_on_country_id", using: :btree

  create_table "brand_links", force: true do |t|
    t.string   "link_text"
    t.string   "link_url"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "brand_links", ["brand_id"], name: "index_brand_links_on_brand_id", using: :btree

  create_table "brandables", force: true do |t|
    t.integer  "brand_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "brandables", ["brand_id"], name: "index_brandables_on_brand_id", using: :btree
  add_index "brandables", ["item_type", "item_id"], name: "index_brandables_on_item_type_and_item_id", using: :btree

  create_table "brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "website_url"
    t.string   "white_image_file_name"
    t.string   "white_image_content_type"
    t.integer  "white_image_file_size"
    t.datetime "white_image_updated_at"
    t.string   "introduction_video_heading_title", default: "Introduction"
    t.string   "events_and_classes_heading_title", default: "Classes"
    t.integer  "views",                            default: 0,              null: false
  end

  add_index "brands", ["views"], name: "index_brands_on_views", order: {"views"=>:desc}, using: :btree

  create_table "brands_sola_classes", force: true do |t|
    t.integer  "brand_id"
    t.integer  "sola_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brands_sola_classes", ["brand_id"], name: "index_brands_sola_classes_on_brand_id", using: :btree
  add_index "brands_sola_classes", ["sola_class_id"], name: "index_brands_sola_classes_on_sola_class_id", using: :btree

  create_table "categoriables", force: true do |t|
    t.integer  "category_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categoriables", ["category_id"], name: "index_categoriables_on_category_id", using: :btree
  add_index "categoriables", ["item_id", "item_type"], name: "index_categoriables_on_item_id_and_item_type", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

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

  create_table "class_images", force: true do |t|
    t.string   "name"
    t.string   "image_content_type"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_content_type"
    t.string   "thumbnail_file_name"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["code"], name: "index_countries_on_code", using: :btree

  create_table "deal_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "deal_category_deals", force: true do |t|
    t.integer  "deal_id"
    t.integer  "deal_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_category_deals", ["deal_category_id"], name: "index_deal_category_deals_on_deal_category_id", using: :btree
  add_index "deal_category_deals", ["deal_id"], name: "index_deal_category_deals_on_deal_id", using: :btree

  create_table "deal_countries", force: true do |t|
    t.integer  "deal_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_countries", ["country_id"], name: "index_deal_countries_on_country_id", using: :btree
  add_index "deal_countries", ["deal_id"], name: "index_deal_countries_on_deal_id", using: :btree

  create_table "deals", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "brand_id"
    t.text     "description"
    t.boolean  "is_featured",              default: false
    t.string   "hover_image_file_name"
    t.string   "hover_image_content_type"
    t.integer  "hover_image_file_size"
    t.datetime "hover_image_updated_at"
    t.string   "more_info_url"
    t.integer  "views",                    default: 0,     null: false
  end

  add_index "deals", ["brand_id"], name: "index_deals_on_brand_id", using: :btree
  add_index "deals", ["views"], name: "index_deals_on_views", order: {"views"=>:desc}, using: :btree

  create_table "devices", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.string   "token"
    t.string   "userable_type"
    t.integer  "userable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform"
  end

  add_index "devices", ["userable_id"], name: "index_devices_on_userable_id", using: :btree
  add_index "devices", ["userable_type"], name: "index_devices_on_userable_type", using: :btree
  add_index "devices", ["uuid", "userable_type", "userable_id"], name: "index_devices_on_uuid_and_userable_type_and_userable_id", unique: true, using: :btree
  add_index "devices", ["uuid"], name: "index_devices_on_uuid", using: :btree

  create_table "distributors", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_hero_image_countries", force: true do |t|
    t.integer  "country_id"
    t.integer  "education_hero_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "education_hero_image_countries", ["country_id"], name: "index_education_hero_image_countries_on_country_id", using: :btree
  add_index "education_hero_image_countries", ["education_hero_image_id"], name: "index_education_hero_image_countries_on_education_hero_image_id", using: :btree

  create_table "education_hero_images", force: true do |t|
    t.string   "action_link"
    t.string   "image_content_type"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_events", force: true do |t|
    t.text     "category"
    t.text     "email"
    t.text     "event"
    t.text     "ip"
    t.text     "response"
    t.text     "sg_event_id"
    t.text     "sg_message_id"
    t.text     "smtp_id"
    t.text     "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "useragent"
    t.text     "url"
    t.text     "status"
    t.text     "reason"
    t.text     "attempt"
    t.text     "tls"
  end

  create_table "events", force: true do |t|
    t.string   "category"
    t.string   "action"
    t.string   "source"
    t.integer  "brand_id"
    t.integer  "deal_id"
    t.integer  "tool_id"
    t.integer  "sola_class_id"
    t.integer  "video_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform"
    t.integer  "userable_id"
    t.string   "userable_type"
  end

  add_index "events", ["brand_id"], name: "index_events_on_brand_id", using: :btree
  add_index "events", ["deal_id"], name: "index_events_on_deal_id", using: :btree
  add_index "events", ["sola_class_id"], name: "index_events_on_sola_class_id", using: :btree
  add_index "events", ["tool_id"], name: "index_events_on_tool_id", using: :btree
  add_index "events", ["userable_id"], name: "index_events_on_userable_id", using: :btree
  add_index "events", ["userable_type"], name: "index_events_on_userable_type", using: :btree
  add_index "events", ["video_id"], name: "index_events_on_video_id", using: :btree

  create_table "franchising_forms", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "phone_number"
    t.boolean  "multi_unit_operator"
    t.string   "liquid_capital"
    t.string   "city"
    t.string   "state"
    t.boolean  "agree_to_receive_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "utm_source"
    t.string   "utm_campaign"
    t.string   "utm_medium"
    t.string   "utm_content"
    t.string   "utm_term"
  end

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
    t.string   "request_type"
  end

  add_index "franchising_requests", ["visit_id"], name: "index_franchising_requests_on_visit_id", using: :btree

  create_table "get_featureds", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "salon_name"
    t.string   "salon_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_button_countries", force: true do |t|
    t.integer  "home_button_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "home_button_countries", ["country_id"], name: "index_home_button_countries_on_country_id", using: :btree
  add_index "home_button_countries", ["home_button_id"], name: "index_home_button_countries_on_home_button_id", using: :btree

  create_table "home_buttons", force: true do |t|
    t.integer  "position"
    t.string   "action_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "home_hero_image_countries", force: true do |t|
    t.integer  "country_id"
    t.integer  "home_hero_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "home_hero_image_countries", ["country_id"], name: "index_home_hero_image_countries_on_country_id", using: :btree
  add_index "home_hero_image_countries", ["home_hero_image_id"], name: "index_home_hero_image_countries_on_home_hero_image_id", using: :btree

  create_table "home_hero_images", force: true do |t|
    t.integer  "position"
    t.string   "action_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "leases", force: true do |t|
    t.integer  "stylist_id"
    t.integer  "studio_id"
    t.string   "rent_manager_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "move_in_date"
    t.date     "signed_date"
    t.integer  "weekly_fee_year_1"
    t.integer  "weekly_fee_year_2"
    t.date     "fee_start_date"
    t.integer  "damage_deposit_amount"
    t.integer  "product_bonus_amount"
    t.string   "product_bonus_distributor"
    t.text     "special_terms"
    t.boolean  "ach_authorized",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "agreement_file_url"
    t.integer  "location_id"
    t.boolean  "hair_styling_permitted",      default: false
    t.boolean  "manicure_pedicure_permitted", default: false
    t.boolean  "waxing_permitted",            default: false
    t.boolean  "massage_permitted",           default: false
    t.boolean  "facial_permitted",            default: false
    t.boolean  "move_in_bonus",               default: false
    t.boolean  "insurance",                   default: false
    t.integer  "insurance_amount"
    t.string   "insurance_frequency"
    t.integer  "move_in_bonus_amount"
    t.string   "move_in_bonus_payee"
    t.integer  "nsf_fee_amount"
    t.string   "other_service"
    t.boolean  "taxes",                       default: false
    t.boolean  "parking",                     default: false
    t.boolean  "cable",                       default: false
    t.date     "insurance_start_date"
    t.date     "create_date"
    t.date     "move_out_date"
  end

  add_index "leases", ["location_id"], name: "index_leases_on_location_id", using: :btree
  add_index "leases", ["studio_id"], name: "index_leases_on_studio_id", using: :btree
  add_index "leases", ["stylist_id"], name: "index_leases_on_stylist_id", using: :btree

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
    t.text     "mailchimp_list_ids"
    t.text     "callfire_list_ids"
    t.text     "custom_maps_url"
    t.text     "tracking_code"
    t.text     "tour_iframe_1"
    t.text     "tour_iframe_2"
    t.text     "tour_iframe_3"
    t.string   "country",                      default: "US"
    t.text     "image_1_alt_text"
    t.text     "image_2_alt_text"
    t.text     "image_3_alt_text"
    t.text     "image_4_alt_text"
    t.text     "image_5_alt_text"
    t.text     "image_6_alt_text"
    t.text     "image_7_alt_text"
    t.text     "image_8_alt_text"
    t.text     "image_9_alt_text"
    t.text     "image_10_alt_text"
    t.text     "image_11_alt_text"
    t.text     "image_12_alt_text"
    t.text     "image_13_alt_text"
    t.text     "image_14_alt_text"
    t.text     "image_15_alt_text"
    t.text     "image_16_alt_text"
    t.text     "image_17_alt_text"
    t.text     "image_18_alt_text"
    t.text     "image_19_alt_text"
    t.text     "image_20_alt_text"
    t.string   "email_address_for_reports"
    t.string   "rent_manager_property_id"
    t.string   "rent_manager_location_id"
    t.boolean  "service_request_enabled",      default: false
    t.boolean  "rent_manager_enabled",         default: false
    t.integer  "moz_id"
    t.text     "description_short"
    t.text     "description_long"
    t.time     "open_time"
    t.time     "close_time"
    t.boolean  "walkins_enabled",              default: false
    t.integer  "max_walkins_time",             default: 60
    t.time     "walkins_end_of_day"
    t.string   "walkins_timezone"
    t.string   "floorplan_image_file_name"
    t.string   "floorplan_image_content_type"
    t.integer  "floorplan_image_file_size"
    t.datetime "floorplan_image_updated_at"
    t.string   "store_id"
    t.string   "email_address_for_hubspot"
  end

  add_index "locations", ["admin_id"], name: "index_locations_on_admin_id", using: :btree
  add_index "locations", ["country"], name: "index_locations_on_country", using: :btree
  add_index "locations", ["msa_id"], name: "index_locations_on_msa_id", using: :btree
  add_index "locations", ["state"], name: "index_locations_on_state", using: :btree
  add_index "locations", ["status", "country"], name: "index_locations_on_status_and_country", using: :btree
  add_index "locations", ["status"], name: "index_locations_on_status", using: :btree
  add_index "locations", ["url_name"], name: "index_locations_on_url_name", using: :btree

  create_table "mozs", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "msas", force: true do |t|
    t.string   "name"
    t.string   "url_name"
    t.string   "legacy_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "tracking_code"
  end

  add_index "msas", ["name"], name: "index_msas_on_name", using: :btree
  add_index "msas", ["url_name"], name: "index_msas_on_url_name", using: :btree

  create_table "my_sola_images", force: true do |t|
    t.string   "name"
    t.string   "instagram_handle"
    t.text     "statement"
    t.boolean  "approved",                     default: false
    t.datetime "approved_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "statement_variant"
    t.string   "public_id"
    t.string   "generated_image_file_name"
    t.string   "generated_image_content_type"
    t.integer  "generated_image_file_size"
    t.datetime "generated_image_updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "brand_id"
    t.integer  "deal_id"
    t.integer  "tool_id"
    t.integer  "sola_class_id"
    t.integer  "video_id"
    t.text     "notification_text"
    t.boolean  "send_push_notification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blog_id"
    t.datetime "date_sent"
  end

  add_index "notifications", ["blog_id"], name: "index_notifications_on_blog_id", using: :btree
  add_index "notifications", ["brand_id"], name: "index_notifications_on_brand_id", using: :btree
  add_index "notifications", ["deal_id"], name: "index_notifications_on_deal_id", using: :btree
  add_index "notifications", ["sola_class_id"], name: "index_notifications_on_sola_class_id", using: :btree
  add_index "notifications", ["tool_id"], name: "index_notifications_on_tool_id", using: :btree
  add_index "notifications", ["video_id"], name: "index_notifications_on_video_id", using: :btree

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

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["content"], name: "index_pg_search_documents_on_content", using: :btree
  add_index "pg_search_documents", ["searchable_id", "searchable_type"], name: "index_pg_search_documents_on_searchable_id_and_searchable_type", using: :btree

  create_table "pro_beauty_industries", force: true do |t|
    t.string   "title"
    t.text     "short_description"
    t.text     "long_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "video_url"
    t.string   "thumbnail_image_file_name"
    t.string   "thumbnail_image_content_type"
    t.integer  "thumbnail_image_file_size"
    t.datetime "thumbnail_image_updated_at"
    t.string   "flyer_image_file_name"
    t.string   "flyer_image_content_type"
    t.integer  "flyer_image_file_size"
    t.datetime "flyer_image_updated_at"
    t.integer  "brand_id"
    t.integer  "pro_beauty_industry_category_id"
    t.integer  "category_id"
  end

  add_index "pro_beauty_industries", ["brand_id"], name: "index_pro_beauty_industries_on_brand_id", using: :btree
  add_index "pro_beauty_industries", ["category_id"], name: "index_pro_beauty_industries_on_category_id", using: :btree
  add_index "pro_beauty_industries", ["pro_beauty_industry_category_id"], name: "index_pro_beauty_industries_on_pro_beauty_industry_category_id", using: :btree

  create_table "pro_beauty_industry_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_informations", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "link_url"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "product_informations", ["brand_id"], name: "index_product_informations_on_brand_id", using: :btree

  create_table "recurring_charges", force: true do |t|
    t.integer  "amount"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "charge_type"
    t.integer  "lease_id"
    t.integer  "position"
  end

  add_index "recurring_charges", ["lease_id"], name: "index_recurring_charges_on_lease_id", using: :btree

  create_table "reports", force: true do |t|
    t.string   "report_type"
    t.string   "email_address"
    t.datetime "processed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parameters"
  end

  create_table "request_tour_inquiries", force: true do |t|
    t.text     "name"
    t.text     "email"
    t.text     "phone"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.text     "request_url"
    t.integer  "visit_id"
    t.text     "contact_preference"
    t.boolean  "newsletter",                   default: true
    t.text     "how_can_we_help_you"
    t.boolean  "i_would_like_to_be_contacted", default: true
    t.boolean  "dont_see_your_location",       default: false
    t.text     "services"
    t.string   "send_email_to_prospect"
    t.string   "content"
    t.string   "source"
    t.string   "medium"
    t.string   "campaign"
    t.string   "zip_code"
    t.string   "hutk"
    t.string   "state"
    t.boolean  "canada_locations",             default: false
  end

  add_index "request_tour_inquiries", ["location_id"], name: "index_request_tour_inquiries_on_location_id", using: :btree
  add_index "request_tour_inquiries", ["visit_id"], name: "index_request_tour_inquiries_on_visit_id", using: :btree

  create_table "reset_passwords", force: true do |t|
    t.string   "public_id"
    t.datetime "date_used"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "userable_id"
    t.string   "userable_type"
  end

  create_table "saved_items", force: true do |t|
    t.integer  "sola_stylist_id"
    t.integer  "admin_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "saved_items", ["admin_id"], name: "index_saved_items_on_admin_id", using: :btree
  add_index "saved_items", ["item_type", "item_id"], name: "index_saved_items_on_item_type_and_item_id", using: :btree
  add_index "saved_items", ["sola_stylist_id"], name: "index_saved_items_on_sola_stylist_id", using: :btree

  create_table "saved_searches", force: true do |t|
    t.integer  "sola_stylist_id"
    t.integer  "admin_id"
    t.text     "query",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
  end

  add_index "saved_searches", ["admin_id"], name: "index_saved_searches_on_admin_id", using: :btree
  add_index "saved_searches", ["kind"], name: "index_saved_searches_on_kind", using: :btree
  add_index "saved_searches", ["query"], name: "index_saved_searches_on_query", using: :btree
  add_index "saved_searches", ["sola_stylist_id"], name: "index_saved_searches_on_sola_stylist_id", using: :btree

  create_table "seja_solas", force: true do |t|
    t.string   "nome"
    t.string   "email"
    t.string   "telefone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area_de_atuacao"
  end

  create_table "short_links", force: true do |t|
    t.string   "url"
    t.string   "public_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count", limit: 8, default: 0
    t.string   "title"
  end

  create_table "side_menu_item_countries", force: true do |t|
    t.integer  "side_menu_item_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "side_menu_item_countries", ["country_id"], name: "index_side_menu_item_countries_on_country_id", using: :btree
  add_index "side_menu_item_countries", ["side_menu_item_id"], name: "index_side_menu_item_countries_on_side_menu_item_id", using: :btree

  create_table "side_menu_items", force: true do |t|
    t.string   "name"
    t.string   "action_link"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sola10k_images", force: true do |t|
    t.string   "name"
    t.string   "instagram_handle"
    t.text     "statement"
    t.boolean  "approved"
    t.datetime "approved_at"
    t.string   "public_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "generated_image_file_name"
    t.string   "generated_image_content_type"
    t.integer  "generated_image_file_size"
    t.datetime "generated_image_updated_at"
    t.string   "color"
  end

  create_table "sola_class_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "sola_class_countries", force: true do |t|
    t.integer  "sola_class_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sola_class_countries", ["country_id"], name: "index_sola_class_countries_on_country_id", using: :btree
  add_index "sola_class_countries", ["sola_class_id"], name: "index_sola_class_countries_on_sola_class_id", using: :btree

  create_table "sola_class_region_countries", force: true do |t|
    t.integer  "sola_class_region_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sola_class_region_countries", ["country_id"], name: "index_sola_class_region_countries_on_country_id", using: :btree
  add_index "sola_class_region_countries", ["sola_class_region_id"], name: "index_sola_class_region_countries_on_sola_class_region_id", using: :btree

  create_table "sola_class_region_states", force: true do |t|
    t.integer  "sola_class_region_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sola_class_region_states", ["sola_class_region_id"], name: "index_sola_class_region_states_on_sola_class_region_id", using: :btree

  create_table "sola_class_regions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "sola_classes", force: true do |t|
    t.string   "title"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "location"
    t.string   "cost"
    t.date     "start_date"
    t.text     "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "link_text"
    t.string   "link_url"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "sola_class_category_id"
    t.boolean  "is_featured",            default: false
    t.integer  "admin_id"
    t.integer  "sola_class_region_id"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.date     "end_date"
    t.text     "end_time"
    t.string   "rsvp_email_address"
    t.string   "rsvp_phone_number"
    t.string   "address"
    t.integer  "video_id"
    t.string   "file_text"
    t.integer  "category_id"
    t.integer  "views",                  default: 0,     null: false
    t.integer  "class_image_id"
  end

  add_index "sola_classes", ["admin_id"], name: "index_sola_classes_on_admin_id", using: :btree
  add_index "sola_classes", ["category_id"], name: "index_sola_classes_on_category_id", using: :btree
  add_index "sola_classes", ["end_date"], name: "index_sola_classes_on_end_date", using: :btree
  add_index "sola_classes", ["sola_class_category_id"], name: "index_sola_classes_on_sola_class_category_id", using: :btree
  add_index "sola_classes", ["sola_class_region_id"], name: "index_sola_classes_on_sola_class_region_id", using: :btree
  add_index "sola_classes", ["video_id"], name: "index_sola_classes_on_video_id", using: :btree
  add_index "sola_classes", ["views"], name: "index_sola_classes_on_views", order: {"views"=>:desc}, using: :btree

  create_table "studios", force: true do |t|
    t.string   "name"
    t.string   "rent_manager_id"
    t.integer  "stylist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.string   "location_name"
  end

  add_index "studios", ["location_id"], name: "index_studios_on_location_id", using: :btree
  add_index "studios", ["stylist_id"], name: "index_studios_on_stylist_id", using: :btree

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
    t.text     "email_address",                                         null: false
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
    t.boolean  "accepting_new_clients",          default: true
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
    t.boolean  "send_a_message_button",          default: true
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
    t.string   "encrypted_password",             default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                  default: 0,            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "msa_name"
    t.boolean  "phone_number_display",           default: true
    t.boolean  "sola_genius_enabled",            default: true
    t.string   "sola_pro_platform"
    t.string   "sola_pro_version"
    t.text     "image_1_alt_text"
    t.text     "image_2_alt_text"
    t.text     "image_3_alt_text"
    t.text     "image_4_alt_text"
    t.text     "image_5_alt_text"
    t.text     "image_6_alt_text"
    t.text     "image_7_alt_text"
    t.text     "image_8_alt_text"
    t.text     "image_9_alt_text"
    t.text     "image_10_alt_text"
    t.boolean  "microblading"
    t.string   "rent_manager_id"
    t.date     "date_of_birth"
    t.string   "street_address"
    t.string   "city"
    t.string   "state_province"
    t.string   "postal_code"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_relationship"
    t.string   "emergency_contact_phone_number"
    t.string   "cosmetology_license_number"
    t.string   "permitted_use_for_studio"
    t.string   "country"
    t.string   "website_email_address"
    t.string   "website_phone_number"
    t.string   "website_name"
    t.date     "cosmetology_license_date"
    t.boolean  "electronic_license_agreement",   default: false
    t.string   "rent_manager_contact_id"
    t.date     "website_go_live_date",           default: '2004-01-01'
    t.string   "sg_booking_url"
    t.boolean  "force_show_book_now_button",     default: false
    t.boolean  "walkins"
    t.boolean  "reserved",                       default: false
    t.datetime "solagenius_account_created_at"
    t.integer  "total_booknow_bookings"
    t.string   "total_booknow_revenue"
    t.datetime "walkins_expiry"
    t.boolean  "botox"
    t.boolean  "onboarded",                      default: false,        null: false
  end

  add_index "stylists", ["email_address"], name: "index_stylists_on_email_address", using: :btree
  add_index "stylists", ["location_id", "status"], name: "index_stylists_on_location_id_and_status", using: :btree
  add_index "stylists", ["location_id"], name: "index_stylists_on_location_id", using: :btree
  add_index "stylists", ["reset_password_token"], name: "index_stylists_on_reset_password_token", unique: true, using: :btree
  add_index "stylists", ["status"], name: "index_stylists_on_status", using: :btree
  add_index "stylists", ["url_name"], name: "index_stylists_on_url_name", using: :btree

  create_table "support_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supports", force: true do |t|
    t.string   "title"
    t.text     "short_description"
    t.text     "long_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_image_file_name"
    t.string   "thumbnail_image_content_type"
    t.integer  "thumbnail_image_file_size"
    t.datetime "thumbnail_image_updated_at"
    t.string   "flyer_image_file_name"
    t.string   "flyer_image_content_type"
    t.integer  "flyer_image_file_size"
    t.datetime "flyer_image_updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "video_url"
    t.integer  "support_category_id"
    t.integer  "category_id"
  end

  add_index "supports", ["category_id"], name: "index_supports_on_category_id", using: :btree
  add_index "supports", ["support_category_id"], name: "index_supports_on_support_category_id", using: :btree

  create_table "taggables", force: true do |t|
    t.integer  "tag_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "taggables", ["item_type", "item_id"], name: "index_taggables_on_item_type_and_item_id", using: :btree
  add_index "taggables", ["tag_id"], name: "index_taggables_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tags_videos", force: true do |t|
    t.integer  "tag_id"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags_videos", ["tag_id"], name: "index_tags_videos_on_tag_id", using: :btree
  add_index "tags_videos", ["video_id"], name: "index_tags_videos_on_video_id", using: :btree

  create_table "terminated_stylists", force: true do |t|
    t.datetime "stylist_created_at"
    t.string   "name"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "studio_number"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "terminated_stylists", ["location_id"], name: "index_terminated_stylists_on_location_id", using: :btree

  create_table "testimonials", force: true do |t|
    t.string   "name"
    t.text     "text"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tool_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "tool_category_tools", force: true do |t|
    t.integer  "tool_id"
    t.integer  "tool_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tool_category_tools", ["tool_category_id"], name: "index_tool_category_tools_on_tool_category_id", using: :btree
  add_index "tool_category_tools", ["tool_id"], name: "index_tool_category_tools_on_tool_id", using: :btree

  create_table "tool_countries", force: true do |t|
    t.integer  "tool_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tool_countries", ["country_id"], name: "index_tool_countries_on_country_id", using: :btree
  add_index "tool_countries", ["tool_id"], name: "index_tool_countries_on_tool_id", using: :btree

  create_table "tools", force: true do |t|
    t.integer  "brand_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "is_featured",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "link_url"
    t.string   "youtube_url"
    t.integer  "views",              default: 0,     null: false
  end

  add_index "tools", ["brand_id"], name: "index_tools_on_brand_id", using: :btree
  add_index "tools", ["views"], name: "index_tools_on_views", order: {"views"=>:desc}, using: :btree

  create_table "update_my_sola_websites", force: true do |t|
    t.string   "name"
    t.text     "biography"
    t.string   "phone_number"
    t.string   "business_name"
    t.text     "work_hours"
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
    t.string   "website_url"
    t.string   "booking_url"
    t.string   "pinterest_url"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "instagram_url"
    t.string   "yelp_url"
    t.boolean  "laser_hair_removal"
    t.boolean  "threading"
    t.boolean  "permanent_makeup"
    t.string   "other_service"
    t.string   "google_plus_url"
    t.string   "linkedin_url"
    t.boolean  "hair_extensions"
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
    t.string   "image_1_url"
    t.string   "image_2_url"
    t.string   "image_3_url"
    t.string   "image_4_url"
    t.string   "image_5_url"
    t.string   "image_6_url"
    t.string   "image_7_url"
    t.string   "image_8_url"
    t.string   "image_9_url"
    t.string   "image_10_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_address"
    t.integer  "stylist_id"
    t.boolean  "approved",              default: false
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
    t.boolean  "microblading"
    t.boolean  "reserved",              default: false
    t.boolean  "botox"
  end

  add_index "update_my_sola_websites", ["stylist_id"], name: "index_update_my_sola_websites_on_stylist_id", using: :btree

  create_table "user_access_tokens", force: true do |t|
    t.integer  "sola_stylist_id"
    t.string   "key"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "admin_id"
  end

  add_index "user_access_tokens", ["admin_id"], name: "index_user_access_tokens_on_admin_id", using: :btree
  add_index "user_access_tokens", ["key"], name: "index_user_access_tokens_on_key", using: :btree
  add_index "user_access_tokens", ["sola_stylist_id"], name: "index_user_access_tokens_on_sola_stylist_id", using: :btree

  create_table "user_notifications", force: true do |t|
    t.string   "userable_type"
    t.integer  "userable_id"
    t.datetime "dismiss_date"
    t.integer  "notification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_notifications", ["notification_id"], name: "index_user_notifications_on_notification_id", using: :btree
  add_index "user_notifications", ["userable_type", "userable_id"], name: "index_user_notifications_on_userable_type_and_userable_id", using: :btree

  create_table "userable_notifications", force: true do |t|
    t.string   "userable_type"
    t.integer  "userable_id"
    t.integer  "notification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_dismissed"
  end

  add_index "userable_notifications", ["notification_id"], name: "index_userable_notifications_on_notification_id", using: :btree
  add_index "userable_notifications", ["userable_type", "userable_id"], name: "index_userable_notifications_on_userable_type_and_userable_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "public_id"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "video_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "video_category_videos", force: true do |t|
    t.integer  "video_id"
    t.integer  "video_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "video_category_videos", ["video_category_id"], name: "index_video_category_videos_on_video_category_id", using: :btree
  add_index "video_category_videos", ["video_id"], name: "index_video_category_videos_on_video_id", using: :btree

  create_table "video_countries", force: true do |t|
    t.integer  "video_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "video_countries", ["country_id"], name: "index_video_countries_on_country_id", using: :btree
  add_index "video_countries", ["video_id"], name: "index_video_countries_on_video_id", using: :btree

  create_table "video_views", force: true do |t|
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "userable_type"
    t.integer  "userable_id"
  end

  add_index "video_views", ["userable_type", "userable_id"], name: "index_video_views_on_userable_type_and_userable_id", using: :btree
  add_index "video_views", ["video_id"], name: "index_video_views_on_video_id", using: :btree

  create_table "videos", force: true do |t|
    t.integer  "brand_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "is_featured",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "youtube_url"
    t.integer  "tool_id"
    t.string   "duration"
    t.boolean  "is_introduction", default: false
    t.string   "link_url"
    t.string   "link_text"
    t.integer  "views",           default: 0,     null: false
    t.boolean  "webinar",         default: false
  end

  add_index "videos", ["brand_id"], name: "index_videos_on_brand_id", using: :btree
  add_index "videos", ["tool_id"], name: "index_videos_on_tool_id", using: :btree
  add_index "videos", ["views"], name: "index_videos_on_views", order: {"views"=>:desc}, using: :btree

  create_table "visits", force: true do |t|
    t.string   "ip_address"
    t.string   "user_agent_string"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watch_laters", force: true do |t|
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "userable_type"
    t.integer  "userable_id"
  end

  add_index "watch_laters", ["userable_type", "userable_id"], name: "index_watch_laters_on_userable_type_and_userable_id", using: :btree
  add_index "watch_laters", ["video_id"], name: "index_watch_laters_on_video_id", using: :btree

  Foreigner.load
  add_foreign_key "brandables", "brands", name: "brandables_brand_id_fk"

  add_foreign_key "taggables", "tags", name: "taggables_tag_id_fk"

end
