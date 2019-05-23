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

ActiveRecord::Schema.define(version: 20190523031753) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"

  create_table "accounts", force: true do |t|
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
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
    t.string   "sola_pro_country_admin"
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
    t.integer  "location_id"
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

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "domain"
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
    t.string   "agreement_file_url"
    t.integer  "location_id"
    t.boolean  "hair_styling_permitted",      default: false
    t.boolean  "manicure_pedicure_permitted", default: false
    t.boolean  "waxing_permitted",            default: false
    t.boolean  "massage_permitted",           default: false
    t.boolean  "facial_permitted",            default: false
    t.integer  "recurring_charge_1_id"
    t.integer  "recurring_charge_2_id"
    t.integer  "recurring_charge_3_id"
    t.integer  "recurring_charge_4_id"
    t.boolean  "move_in_bonus",               default: false
    t.boolean  "insurance",                   default: false
    t.integer  "insurance_amount"
    t.string   "insurance_frequency"
    t.integer  "move_in_bonus_amount"
    t.string   "move_in_bonus_payee"
  end

  add_index "leases", ["location_id"], name: "index_leases_on_location_id", using: :btree
  add_index "leases", ["recurring_charge_1_id"], name: "index_leases_on_recurring_charge_1_id", using: :btree
  add_index "leases", ["recurring_charge_2_id"], name: "index_leases_on_recurring_charge_2_id", using: :btree
  add_index "leases", ["recurring_charge_3_id"], name: "index_leases_on_recurring_charge_3_id", using: :btree
  add_index "leases", ["recurring_charge_4_id"], name: "index_leases_on_recurring_charge_4_id", using: :btree
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
    t.string   "country",                     default: "US"
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
    t.boolean  "service_request_enabled",     default: false
    t.boolean  "rent_manager_enabled",        default: false
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

  create_table "recurring_charges", force: true do |t|
    t.integer  "amount"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  add_index "request_tour_inquiries", ["location_id"], name: "index_request_tour_inquiries_on_location_id", using: :btree
  add_index "request_tour_inquiries", ["visit_id"], name: "index_request_tour_inquiries_on_visit_id", using: :btree

  create_table "seja_solas", force: true do |t|
    t.string   "nome"
    t.string   "email"
    t.string   "telefone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area_de_atuacao"
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
    t.integer  "sign_in_count",                  default: 0,     null: false
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
    t.boolean  "force_show_book_now_button",     default: false
    t.string   "sg_booking_url"
    t.boolean  "walkins"
  end

  add_index "stylists", ["location_id"], name: "index_stylists_on_location_id", using: :btree
  add_index "stylists", ["reset_password_token"], name: "index_stylists_on_reset_password_token", unique: true, using: :btree
  add_index "stylists", ["status"], name: "index_stylists_on_status", using: :btree
  add_index "stylists", ["url_name"], name: "index_stylists_on_url_name", using: :btree

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
  end

  add_index "update_my_sola_websites", ["stylist_id"], name: "index_update_my_sola_websites_on_stylist_id", using: :btree

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
