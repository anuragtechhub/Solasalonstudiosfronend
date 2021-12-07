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

ActiveRecord::Schema.define(version: 20211114200114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "dblink"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"

  create_table "accounts", force: :cascade do |t|
    t.string   "api_key",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
  end

  add_index "accounts", ["api_key"], name: "index_accounts_on_api_key", using: :btree

# Could not dump table "admins" because of following FrozenError
#   can't modify frozen String: "false"

  create_table "articles", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "url_name",           limit: 255
    t.text     "summary"
    t.text     "body"
    t.text     "article_url"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "legacy_id",          limit: 255
    t.integer  "location_id"
    t.string   "display_setting",    limit: 255, default: "sola_website"
  end

  add_index "articles", ["location_id"], name: "index_articles_on_location_id", using: :btree
  add_index "articles", ["url_name"], name: "index_articles_on_url_name", using: :btree

  create_table "blog_blog_categories", force: :cascade do |t|
    t.integer  "blog_id"
    t.integer  "blog_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_blog_categories", ["blog_category_id"], name: "index_blog_blog_categories_on_blog_category_id", using: :btree
  add_index "blog_blog_categories", ["blog_id"], name: "index_blog_blog_categories_on_blog_id", using: :btree

  create_table "blog_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url_name",   limit: 255
    t.string   "legacy_id",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_categories", ["url_name"], name: "index_blog_categories_on_url_name", using: :btree

  create_table "blog_countries", force: :cascade do |t|
    t.integer  "blog_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_countries", ["blog_id"], name: "index_blog_countries_on_blog_id", using: :btree
  add_index "blog_countries", ["country_id"], name: "index_blog_countries_on_country_id", using: :btree

# Could not dump table "blogs" because of following FrozenError
#   can't modify frozen String: "false"

  create_table "book_now_bookings", force: :cascade do |t|
    t.string   "time_range",         limit: 255
    t.integer  "location_id"
    t.string   "query",              limit: 255
    t.json     "services"
    t.integer  "stylist_id"
    t.string   "booking_user_name",  limit: 255
    t.string   "booking_user_phone", limit: 255
    t.string   "booking_user_email", limit: 255
    t.string   "referring_url",      limit: 255
    t.string   "total",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "book_now_bookings", ["location_id"], name: "index_book_now_bookings_on_location_id", using: :btree
  add_index "book_now_bookings", ["stylist_id"], name: "index_book_now_bookings_on_stylist_id", using: :btree

  create_table "brand_countries", force: :cascade do |t|
    t.integer  "brand_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_countries", ["brand_id"], name: "index_brand_countries_on_brand_id", using: :btree
  add_index "brand_countries", ["country_id"], name: "index_brand_countries_on_country_id", using: :btree

  create_table "brand_links", force: :cascade do |t|
    t.string   "link_text",  limit: 255
    t.string   "link_url",   limit: 255
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "brand_links", ["brand_id"], name: "index_brand_links_on_brand_id", using: :btree

  create_table "brandables", force: :cascade do |t|
    t.integer  "brand_id"
    t.integer  "item_id"
    t.string   "item_type",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "brandables", ["brand_id"], name: "index_brandables_on_brand_id", using: :btree
  add_index "brandables", ["item_type", "item_id"], name: "index_brandables_on_item_type_and_item_id", using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name",                             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",                  limit: 255
    t.string   "image_content_type",               limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "website_url",                      limit: 255
    t.string   "white_image_file_name",            limit: 255
    t.string   "white_image_content_type",         limit: 255
    t.integer  "white_image_file_size"
    t.datetime "white_image_updated_at"
    t.string   "introduction_video_heading_title", limit: 255, default: "Introduction"
    t.string   "events_and_classes_heading_title", limit: 255, default: "Classes"
    t.integer  "views",                                        default: 0,              null: false
  end

  add_index "brands", ["views"], name: "index_brands_on_views", order: {"views"=>:desc}, using: :btree

  create_table "brands_sola_classes", force: :cascade do |t|
    t.integer  "brand_id"
    t.integer  "sola_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brands_sola_classes", ["brand_id"], name: "index_brands_sola_classes_on_brand_id", using: :btree
  add_index "brands_sola_classes", ["sola_class_id"], name: "index_brands_sola_classes_on_sola_class_id", using: :btree

  create_table "categoriables", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "item_id"
    t.string   "item_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categoriables", ["category_id"], name: "index_categoriables_on_category_id", using: :btree
  add_index "categoriables", ["item_id", "item_type"], name: "index_categoriables_on_item_id_and_item_type", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "slug",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
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

  create_table "class_images", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "image_content_type",     limit: 255
    t.string   "image_file_name",        limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_content_type", limit: 255
    t.string   "thumbnail_file_name",    limit: 255
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "code",       limit: 255
    t.string   "domain",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["code"], name: "index_countries_on_code", using: :btree

  create_table "deal_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "deal_category_deals", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "deal_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_category_deals", ["deal_category_id"], name: "index_deal_category_deals_on_deal_category_id", using: :btree
  add_index "deal_category_deals", ["deal_id"], name: "index_deal_category_deals_on_deal_id", using: :btree

  create_table "deal_countries", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_countries", ["country_id"], name: "index_deal_countries_on_country_id", using: :btree
  add_index "deal_countries", ["deal_id"], name: "index_deal_countries_on_deal_id", using: :btree

# Could not dump table "deals" because of following FrozenError
#   can't modify frozen String: "false"

  create_table "devices", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.string   "uuid",                            limit: 255, null: false
    t.string   "token",                           limit: 255, null: false
    t.string   "userable_type",                   limit: 255, null: false
    t.integer  "userable_id",                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform",                        limit: 255, null: false
    t.string   "app_version"
    t.datetime "internal_rating_popup_showed_at"
    t.datetime "native_rating_popup_showed_at"
    t.text     "internal_feedback"
  end

  add_index "devices", ["token"], name: "index_devices_on_token", unique: true, using: :btree
  add_index "devices", ["userable_id"], name: "index_devices_on_userable_id", using: :btree
  add_index "devices", ["userable_type"], name: "index_devices_on_userable_type", using: :btree
  add_index "devices", ["uuid", "userable_type", "userable_id"], name: "index_devices_on_uuid_and_userable_type_and_userable_id", unique: true, using: :btree
  add_index "devices", ["uuid"], name: "index_devices_on_uuid", using: :btree

  create_table "distributors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_hero_image_countries", force: :cascade do |t|
    t.integer  "country_id"
    t.integer  "education_hero_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "education_hero_image_countries", ["country_id"], name: "index_education_hero_image_countries_on_country_id", using: :btree
  add_index "education_hero_image_countries", ["education_hero_image_id"], name: "index_education_hero_image_countries_on_education_hero_image_id", using: :btree

  create_table "education_hero_images", force: :cascade do |t|
    t.string   "action_link",        limit: 255
    t.string   "image_content_type", limit: 255
    t.string   "image_file_name",    limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_events", force: :cascade do |t|
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

  create_table "events", force: :cascade do |t|
    t.string   "category",      limit: 255
    t.string   "action",        limit: 255
    t.string   "source",        limit: 255
    t.integer  "brand_id"
    t.integer  "deal_id"
    t.integer  "tool_id"
    t.integer  "sola_class_id"
    t.integer  "video_id"
    t.string   "value",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform",      limit: 255
    t.integer  "userable_id"
    t.string   "userable_type", limit: 255
  end

  add_index "events", ["brand_id"], name: "index_events_on_brand_id", using: :btree
  add_index "events", ["deal_id"], name: "index_events_on_deal_id", using: :btree
  add_index "events", ["sola_class_id"], name: "index_events_on_sola_class_id", using: :btree
  add_index "events", ["tool_id"], name: "index_events_on_tool_id", using: :btree
  add_index "events", ["userable_id"], name: "index_events_on_userable_id", using: :btree
  add_index "events", ["userable_type"], name: "index_events_on_userable_type", using: :btree
  add_index "events", ["video_id"], name: "index_events_on_video_id", using: :btree

  create_table "franchise_articles", force: :cascade do |t|
    t.string   "slug",                                         null: false
    t.string   "title",                                        null: false
    t.text     "url"
    t.text     "summary"
    t.text     "body"
    t.string   "image_content_type"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "author"
    t.integer  "country"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "kind",                   limit: 2, default: 0, null: false
    t.string   "thumbnail_content_type"
    t.string   "thumbnail_file_name"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
  end

  add_index "franchise_articles", ["country"], name: "index_franchise_articles_on_country", using: :btree
  add_index "franchise_articles", ["slug"], name: "index_franchise_articles_on_slug", unique: true, using: :btree
  add_index "franchise_articles", ["title"], name: "index_franchise_articles_on_title", using: :btree

  create_table "franchising_forms", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "email_address",          limit: 255
    t.string   "phone_number",           limit: 255
    t.boolean  "multi_unit_operator"
    t.string   "liquid_capital",         limit: 255
    t.string   "city",                   limit: 255
    t.string   "state",                  limit: 255
    t.boolean  "agree_to_receive_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "utm_source",             limit: 255
    t.string   "utm_campaign",           limit: 255
    t.string   "utm_medium",             limit: 255
    t.string   "utm_content",            limit: 255
    t.string   "utm_term",               limit: 255
    t.string   "country",                            default: "usa", null: false
  end

  add_index "franchising_forms", ["country"], name: "index_franchising_forms_on_country", using: :btree

  create_table "franchising_requests", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "email",        limit: 255
    t.string   "phone",        limit: 255
    t.string   "market",       limit: 255
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "request_url",  limit: 255
    t.integer  "visit_id"
    t.string   "request_type", limit: 255
  end

  add_index "franchising_requests", ["visit_id"], name: "index_franchising_requests_on_visit_id", using: :btree

  create_table "get_featureds", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "email",          limit: 255
    t.string   "phone_number",   limit: 255
    t.string   "salon_name",     limit: 255
    t.string   "salon_location", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_button_countries", force: :cascade do |t|
    t.integer  "home_button_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "home_button_countries", ["country_id"], name: "index_home_button_countries_on_country_id", using: :btree
  add_index "home_button_countries", ["home_button_id"], name: "index_home_button_countries_on_home_button_id", using: :btree

  create_table "home_buttons", force: :cascade do |t|
    t.integer  "position"
    t.string   "action_link",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "home_hero_image_countries", force: :cascade do |t|
    t.integer  "country_id"
    t.integer  "home_hero_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "home_hero_image_countries", ["country_id"], name: "index_home_hero_image_countries_on_country_id", using: :btree
  add_index "home_hero_image_countries", ["home_hero_image_id"], name: "index_home_hero_image_countries_on_home_hero_image_id", using: :btree

  create_table "home_hero_images", force: :cascade do |t|
    t.integer  "position"
    t.string   "action_link",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "hubspot_events", force: :cascade do |t|
    t.string   "kind"
    t.datetime "fired_at"
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hubspot_logs", force: :cascade do |t|
    t.json     "data"
    t.integer  "status"
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "kind"
    t.string   "action"
  end

  add_index "hubspot_logs", ["location_id"], name: "index_hubspot_logs_on_location_id", using: :btree
  add_index "hubspot_logs", ["object_type", "object_id"], name: "index_hubspot_logs_on_object_type_and_object_id", using: :btree

# Could not dump table "leases" because of following FrozenError
#   can't modify frozen String: "false"

# Could not dump table "locations" because of following FrozenError
#   can't modify frozen String: "false"

  create_table "mozs", force: :cascade do |t|
    t.string   "token",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "msas", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "url_name",      limit: 255
    t.string   "legacy_id",     limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "tracking_code"
  end

  add_index "msas", ["name"], name: "index_msas_on_name", using: :btree
  add_index "msas", ["url_name"], name: "index_msas_on_url_name", using: :btree

# Could not dump table "my_sola_images" because of following FrozenError
#   can't modify frozen String: "false"

  create_table "notification_recipients", force: :cascade do |t|
    t.integer  "notification_id"
    t.integer  "stylist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_recipients", ["notification_id"], name: "index_notification_recipients_on_notification_id", using: :btree
  add_index "notification_recipients", ["stylist_id"], name: "index_notification_recipients_on_stylist_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "brand_id"
    t.integer  "deal_id"
    t.integer  "tool_id"
    t.integer  "sola_class_id"
    t.integer  "video_id"
    t.string   "notification_text",      limit: 235
    t.boolean  "send_push_notification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blog_id"
    t.datetime "date_sent"
    t.string   "title",                  limit: 65
    t.datetime "send_at"
    t.integer  "country_id"
  end

  add_index "notifications", ["blog_id"], name: "index_notifications_on_blog_id", using: :btree
  add_index "notifications", ["brand_id"], name: "index_notifications_on_brand_id", using: :btree
  add_index "notifications", ["country_id"], name: "index_notifications_on_country_id", using: :btree
  add_index "notifications", ["deal_id"], name: "index_notifications_on_deal_id", using: :btree
  add_index "notifications", ["send_at"], name: "index_notifications_on_send_at", using: :btree
  add_index "notifications", ["sola_class_id"], name: "index_notifications_on_sola_class_id", using: :btree
  add_index "notifications", ["tool_id"], name: "index_notifications_on_tool_id", using: :btree
  add_index "notifications", ["video_id"], name: "index_notifications_on_video_id", using: :btree

  create_table "partner_inquiries", force: :cascade do |t|
    t.string   "subject",      limit: 255
    t.string   "name",         limit: 255
    t.string   "company_name", limit: 255
    t.string   "email",        limit: 255
    t.string   "phone",        limit: 255
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "request_url",  limit: 255
    t.integer  "visit_id"
  end

  add_index "partner_inquiries", ["visit_id"], name: "index_partner_inquiries_on_visit_id", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "pg_search_documents", ["content"], name: "index_pg_search_documents_on_content", using: :btree
  add_index "pg_search_documents", ["searchable_id", "searchable_type"], name: "index_pg_search_documents_on_searchable_id_and_searchable_type", using: :btree

  create_table "pro_beauty_industries", force: :cascade do |t|
    t.string   "title",                           limit: 255
    t.text     "short_description"
    t.text     "long_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name",                  limit: 255
    t.string   "file_content_type",               limit: 255
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "video_url",                       limit: 255
    t.string   "thumbnail_image_file_name",       limit: 255
    t.string   "thumbnail_image_content_type",    limit: 255
    t.integer  "thumbnail_image_file_size"
    t.datetime "thumbnail_image_updated_at"
    t.string   "flyer_image_file_name",           limit: 255
    t.string   "flyer_image_content_type",        limit: 255
    t.integer  "flyer_image_file_size"
    t.datetime "flyer_image_updated_at"
    t.integer  "brand_id"
    t.integer  "pro_beauty_industry_category_id"
    t.integer  "category_id"
  end

  add_index "pro_beauty_industries", ["brand_id"], name: "index_pro_beauty_industries_on_brand_id", using: :btree
  add_index "pro_beauty_industries", ["category_id"], name: "index_pro_beauty_industries_on_category_id", using: :btree
  add_index "pro_beauty_industries", ["pro_beauty_industry_category_id"], name: "index_pro_beauty_industries_on_pro_beauty_industry_category_id", using: :btree

  create_table "pro_beauty_industry_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_informations", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "description"
    t.string   "link_url",           limit: 255
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "file_file_name",     limit: 255
    t.string   "file_content_type",  limit: 255
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "product_informations", ["brand_id"], name: "index_product_informations_on_brand_id", using: :btree

  create_table "recurring_charges", force: :cascade do |t|
    t.integer  "amount"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: :cascade do |t|
    t.string   "report_type",   limit: 255
    t.string   "email_address", limit: 255
    t.datetime "processed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parameters",    limit: 255
    t.string   "subject"
  end

# Could not dump table "request_tour_inquiries" because of following FrozenError
#   can't modify frozen String: "true"

  create_table "reset_passwords", force: :cascade do |t|
    t.string   "public_id",     limit: 255
    t.datetime "date_used"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "userable_id"
    t.string   "userable_type", limit: 255
  end

  create_table "saved_items", force: :cascade do |t|
    t.integer  "stylist_id"
    t.integer  "admin_id"
    t.integer  "item_id"
    t.string   "item_type",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "saved_items", ["admin_id"], name: "index_saved_items_on_admin_id", using: :btree
  add_index "saved_items", ["item_type", "item_id"], name: "index_saved_items_on_item_type_and_item_id", using: :btree
  add_index "saved_items", ["stylist_id"], name: "index_saved_items_on_stylist_id", using: :btree

  create_table "saved_searches", force: :cascade do |t|
    t.integer  "stylist_id"
    t.integer  "admin_id"
    t.text     "query",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind",       limit: 255
  end

  add_index "saved_searches", ["admin_id"], name: "index_saved_searches_on_admin_id", using: :btree
  add_index "saved_searches", ["kind"], name: "index_saved_searches_on_kind", using: :btree
  add_index "saved_searches", ["query"], name: "index_saved_searches_on_query", using: :btree
  add_index "saved_searches", ["stylist_id"], name: "index_saved_searches_on_stylist_id", using: :btree

  create_table "seja_solas", force: :cascade do |t|
    t.string   "nome",            limit: 255
    t.string   "email",           limit: 255
    t.string   "telefone",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area_de_atuacao", limit: 255
  end

  create_table "short_links", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.string   "public_id",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count", limit: 8,   default: 0
    t.string   "title",      limit: 255
  end

  create_table "side_menu_item_countries", force: :cascade do |t|
    t.integer  "side_menu_item_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "side_menu_item_countries", ["country_id"], name: "index_side_menu_item_countries_on_country_id", using: :btree
  add_index "side_menu_item_countries", ["side_menu_item_id"], name: "index_side_menu_item_countries_on_side_menu_item_id", using: :btree

  create_table "side_menu_items", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "action_link", limit: 255
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sola10k_images", force: :cascade do |t|
    t.string   "name",                         limit: 255
    t.string   "instagram_handle",             limit: 255
    t.text     "statement"
    t.boolean  "approved"
    t.datetime "approved_at"
    t.string   "public_id",                    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",              limit: 255
    t.string   "image_content_type",           limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "generated_image_file_name",    limit: 255
    t.string   "generated_image_content_type", limit: 255
    t.integer  "generated_image_file_size"
    t.datetime "generated_image_updated_at"
    t.string   "color",                        limit: 255
  end

  create_table "sola_class_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "sola_class_countries", force: :cascade do |t|
    t.integer  "sola_class_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sola_class_countries", ["country_id"], name: "index_sola_class_countries_on_country_id", using: :btree
  add_index "sola_class_countries", ["sola_class_id"], name: "index_sola_class_countries_on_sola_class_id", using: :btree

  create_table "sola_class_region_countries", force: :cascade do |t|
    t.integer  "sola_class_region_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sola_class_region_countries", ["country_id"], name: "index_sola_class_region_countries_on_country_id", using: :btree
  add_index "sola_class_region_countries", ["sola_class_region_id"], name: "index_sola_class_region_countries_on_sola_class_region_id", using: :btree

  create_table "sola_class_region_states", force: :cascade do |t|
    t.integer  "sola_class_region_id"
    t.string   "state",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sola_class_region_states", ["sola_class_region_id"], name: "index_sola_class_region_states_on_sola_class_region_id", using: :btree

  create_table "sola_class_regions", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

# Could not dump table "sola_classes" because of following FrozenError
#   can't modify frozen String: "false"

  create_table "studios", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "rent_manager_id", limit: 255
    t.integer  "stylist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.string   "location_name",   limit: 255
  end

  add_index "studios", ["location_id"], name: "index_studios_on_location_id", using: :btree
  add_index "studios", ["stylist_id"], name: "index_studios_on_stylist_id", using: :btree

  create_table "stylist_messages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.text     "message"
    t.integer  "stylist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visit_id"
  end

  add_index "stylist_messages", ["stylist_id"], name: "index_stylist_messages_on_stylist_id", using: :btree
  add_index "stylist_messages", ["visit_id"], name: "index_stylist_messages_on_visit_id", using: :btree

# Could not dump table "stylists" because of following FrozenError
#   can't modify frozen String: "true"

  create_table "support_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supports", force: :cascade do |t|
    t.string   "title",                        limit: 255
    t.text     "short_description"
    t.text     "long_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_image_file_name",    limit: 255
    t.string   "thumbnail_image_content_type", limit: 255
    t.integer  "thumbnail_image_file_size"
    t.datetime "thumbnail_image_updated_at"
    t.string   "flyer_image_file_name",        limit: 255
    t.string   "flyer_image_content_type",     limit: 255
    t.integer  "flyer_image_file_size"
    t.datetime "flyer_image_updated_at"
    t.string   "file_file_name",               limit: 255
    t.string   "file_content_type",            limit: 255
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "video_url",                    limit: 255
    t.integer  "support_category_id"
    t.integer  "category_id"
  end

  add_index "supports", ["category_id"], name: "index_supports_on_category_id", using: :btree
  add_index "supports", ["support_category_id"], name: "index_supports_on_support_category_id", using: :btree

  create_table "taggables", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "item_id"
    t.string   "item_type",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "taggables", ["item_type", "item_id"], name: "index_taggables_on_item_type_and_item_id", using: :btree
  add_index "taggables", ["tag_id"], name: "index_taggables_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tags_videos", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags_videos", ["tag_id"], name: "index_tags_videos_on_tag_id", using: :btree
  add_index "tags_videos", ["video_id"], name: "index_tags_videos_on_video_id", using: :btree

  create_table "terminated_stylists", force: :cascade do |t|
    t.datetime "stylist_created_at"
    t.string   "name",               limit: 255
    t.string   "email_address",      limit: 255
    t.string   "phone_number",       limit: 255
    t.string   "studio_number",      limit: 255
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "terminated_stylists", ["location_id"], name: "index_terminated_stylists_on_location_id", using: :btree

  create_table "testimonials", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "text",                   null: false
    t.string   "region",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tool_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "tool_category_tools", force: :cascade do |t|
    t.integer  "tool_id"
    t.integer  "tool_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tool_category_tools", ["tool_category_id"], name: "index_tool_category_tools_on_tool_category_id", using: :btree
  add_index "tool_category_tools", ["tool_id"], name: "index_tool_category_tools_on_tool_id", using: :btree

  create_table "tool_countries", force: :cascade do |t|
    t.integer  "tool_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tool_countries", ["country_id"], name: "index_tool_countries_on_country_id", using: :btree
  add_index "tool_countries", ["tool_id"], name: "index_tool_countries_on_tool_id", using: :btree

# Could not dump table "tools" because of following FrozenError
#   can't modify frozen String: "false"

# Could not dump table "update_my_sola_websites" because of following FrozenError
#   can't modify frozen String: "false"

  create_table "user_access_tokens", force: :cascade do |t|
    t.integer  "stylist_id"
    t.string   "key",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "admin_id"
  end

  add_index "user_access_tokens", ["admin_id"], name: "index_user_access_tokens_on_admin_id", using: :btree
  add_index "user_access_tokens", ["key"], name: "index_user_access_tokens_on_key", using: :btree
  add_index "user_access_tokens", ["stylist_id"], name: "index_user_access_tokens_on_stylist_id", using: :btree

  create_table "user_notifications", force: :cascade do |t|
    t.string   "userable_type",   limit: 255
    t.integer  "userable_id"
    t.datetime "dismiss_date"
    t.integer  "notification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_notifications", ["notification_id"], name: "index_user_notifications_on_notification_id", using: :btree
  add_index "user_notifications", ["userable_type", "userable_id"], name: "index_user_notifications_on_userable_type_and_userable_id", using: :btree

  create_table "userable_notifications", force: :cascade do |t|
    t.string   "userable_type",   limit: 255
    t.integer  "userable_id"
    t.integer  "notification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_dismissed"
  end

  add_index "userable_notifications", ["notification_id"], name: "index_userable_notifications_on_notification_id", using: :btree
  add_index "userable_notifications", ["userable_type", "userable_id"], name: "index_userable_notifications_on_userable_type_and_userable_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "public_id",       limit: 255
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 255, null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "video_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "video_category_videos", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "video_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "video_category_videos", ["video_category_id"], name: "index_video_category_videos_on_video_category_id", using: :btree
  add_index "video_category_videos", ["video_id"], name: "index_video_category_videos_on_video_id", using: :btree

  create_table "video_countries", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "video_countries", ["country_id"], name: "index_video_countries_on_country_id", using: :btree
  add_index "video_countries", ["video_id"], name: "index_video_countries_on_video_id", using: :btree

  create_table "video_views", force: :cascade do |t|
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "userable_type", limit: 255
    t.integer  "userable_id"
  end

  add_index "video_views", ["userable_type", "userable_id"], name: "index_video_views_on_userable_type_and_userable_id", using: :btree
  add_index "video_views", ["video_id"], name: "index_video_views_on_video_id", using: :btree

# Could not dump table "videos" because of following FrozenError
#   can't modify frozen String: "false"

  create_table "visits", force: :cascade do |t|
    t.string   "ip_address",        limit: 255
    t.string   "user_agent_string", limit: 255
    t.string   "uuid",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "watch_laters", force: :cascade do |t|
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "userable_type", limit: 255
    t.integer  "userable_id"
  end

  add_index "watch_laters", ["userable_type", "userable_id"], name: "index_watch_laters_on_userable_type_and_userable_id", using: :btree
  add_index "watch_laters", ["video_id"], name: "index_watch_laters_on_video_id", using: :btree

  add_foreign_key "brandables", "brands", name: "brandables_brand_id_fk"
  add_foreign_key "hubspot_logs", "locations"
  add_foreign_key "taggables", "tags", name: "taggables_tag_id_fk"
end
