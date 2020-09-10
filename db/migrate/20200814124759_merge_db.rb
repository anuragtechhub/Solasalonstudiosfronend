class MergeDb < ActiveRecord::Migration
  def change
    enable_extension 'dblink'

    # run before
    # Country.create_with(name: 'Brazil', code: 'BR', domain: 'solasalonstudios.com.br').find_or_create_by(name: 'Brazil')

    # ADD API Tables
    #
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
      t.string   "item_type"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
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
    end

    create_table "brands_sola_classes", force: :cascade do |t|
      t.integer  "brand_id"
      t.integer  "sola_class_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "brands_sola_classes", ["brand_id"], name: "index_brands_sola_classes_on_brand_id", using: :btree
    add_index "brands_sola_classes", ["sola_class_id"], name: "index_brands_sola_classes_on_sola_class_id", using: :btree

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

    create_table "deals", force: :cascade do |t|
      t.string   "title",                    limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "file_file_name",           limit: 255
      t.string   "file_content_type",        limit: 255
      t.integer  "file_file_size"
      t.datetime "file_updated_at"
      t.string   "image_file_name",          limit: 255
      t.string   "image_content_type",       limit: 255
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.integer  "brand_id"
      t.text     "description"
      t.boolean  "is_featured",                          default: false
      t.string   "hover_image_file_name",    limit: 255
      t.string   "hover_image_content_type", limit: 255
      t.integer  "hover_image_file_size"
      t.datetime "hover_image_updated_at"
      t.string   "more_info_url",            limit: 255
    end

    add_index "deals", ["brand_id"], name: "index_deals_on_brand_id", using: :btree

    create_table "devices", force: :cascade do |t|
      t.string   "name",          limit: 255
      t.string   "uuid",          limit: 255
      t.string   "token",         limit: 255
      t.string   "userable_type", limit: 255
      t.integer  "userable_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "platform",      limit: 255
    end

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

    create_table "events", force: :cascade do |t|
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

    create_table "notifications", force: :cascade do |t|
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
    end

    add_index "pro_beauty_industries", ["brand_id"], name: "index_pro_beauty_industries_on_brand_id", using: :btree
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

    create_table "reset_passwords", force: :cascade do |t|
      t.string   "public_id",     limit: 255
      t.datetime "date_used"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "userable_id"
      t.string   "userable_type", limit: 255
    end

    create_table "saved_items", force: :cascade do |t|
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

    create_table "sola_classes", force: :cascade do |t|
      t.string   "title",                  limit: 255
      t.string   "city",                   limit: 255
      t.string   "state",                  limit: 255
      t.string   "postal_code",            limit: 255
      t.string   "location",               limit: 255
      t.string   "cost",                   limit: 255
      t.date     "start_date"
      t.text     "start_time"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "file_file_name",         limit: 255
      t.string   "file_content_type",      limit: 255
      t.integer  "file_file_size"
      t.datetime "file_updated_at"
      t.string   "link_text",              limit: 255
      t.string   "link_url",               limit: 255
      t.float    "latitude"
      t.float    "longitude"
      t.integer  "sola_class_category_id"
      t.boolean  "is_featured",                        default: false
      t.integer  "admin_id"
      t.integer  "sola_class_region_id"
      t.text     "description"
      t.string   "image_file_name",        limit: 255
      t.string   "image_content_type",     limit: 255
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.date     "end_date"
      t.text     "end_time"
      t.string   "rsvp_email_address",     limit: 255
      t.string   "rsvp_phone_number",      limit: 255
      t.string   "address",                limit: 255
      t.integer  "video_id"
      t.string   "file_text",              limit: 255
    end

    add_index "sola_classes", ["admin_id"], name: "index_sola_classes_on_admin_id", using: :btree
    add_index "sola_classes", ["sola_class_category_id"], name: "index_sola_classes_on_sola_class_category_id", using: :btree
    add_index "sola_classes", ["sola_class_region_id"], name: "index_sola_classes_on_sola_class_region_id", using: :btree
    add_index "sola_classes", ["video_id"], name: "index_sola_classes_on_video_id", using: :btree

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
    end

    add_index "supports", ["support_category_id"], name: "index_supports_on_support_category_id", using: :btree

    create_table "taggables", force: :cascade do |t|
      t.integer  "tag_id"
      t.integer  "item_id"
      t.string   "item_type"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "taggables", ["item_type", "item_id"], name: "index_taggables_on_item_type_and_item_id", using: :btree
    add_index "taggables", ["tag_id"], name: "index_taggables_on_tag_id", using: :btree

    create_table "tags", force: :cascade do |t|
      t.string   "name",       limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "tags_videos", force: :cascade do |t|
      t.integer  "tag_id"
      t.integer  "video_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "tags_videos", ["tag_id"], name: "index_tags_videos_on_tag_id", using: :btree
    add_index "tags_videos", ["video_id"], name: "index_tags_videos_on_video_id", using: :btree

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

    create_table "tools", force: :cascade do |t|
      t.integer  "brand_id"
      t.string   "title",              limit: 255
      t.text     "description"
      t.boolean  "is_featured",                    default: false
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
      t.string   "link_url",           limit: 255
      t.string   "youtube_url",        limit: 255
    end

    add_index "tools", ["brand_id"], name: "index_tools_on_brand_id", using: :btree

    create_table "user_access_tokens", force: :cascade do |t|
      t.integer  "sola_stylist_id"
      t.string   "key"
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
    end

    add_index "user_access_tokens", ["key"], name: "index_user_access_tokens_on_key", using: :btree
    add_index "user_access_tokens", ["sola_stylist_id"], name: "index_user_access_tokens_on_sola_stylist_id", using: :btree

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

    create_table "videos", force: :cascade do |t|
      t.integer  "brand_id"
      t.string   "title",           limit: 255
      t.text     "description"
      t.boolean  "is_featured",                 default: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "youtube_url",     limit: 255
      t.integer  "tool_id"
      t.string   "duration",        limit: 255
      t.boolean  "is_introduction",             default: false
      t.string   "link_url",        limit: 255
      t.string   "link_text",       limit: 255
    end

    add_index "videos", ["brand_id"], name: "index_videos_on_brand_id", using: :btree
    add_index "videos", ["tool_id"], name: "index_videos_on_tool_id", using: :btree

    create_table "watch_laters", force: :cascade do |t|
      t.integer  "video_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "userable_type", limit: 255
      t.integer  "userable_id"
    end

    add_index "watch_laters", ["userable_type", "userable_id"], name: "index_watch_laters_on_userable_type_and_userable_id", using: :btree
    add_index "watch_laters", ["video_id"], name: "index_watch_laters_on_video_id", using: :btree

    add_foreign_key "brandables", "brands"
    add_foreign_key "taggables", "tags"

    add_column :versions, :object_changes, :text unless column_exists?(:versions, :object_changes)

    # Copy data
    ActiveRecord::Base.connection.execute("
      SELECT dblink_connect('host=#{ENV['API_DB_HOST']}
                             user=#{ENV['API_DB_USER']}
                             password=#{ENV['API_DB_PASS']}
                             dbname=#{ENV['API_DB_NAME']}');


      INSERT INTO accounts(name, api_key, created_at, updated_at)
        SELECT * FROM dblink('SELECT name, api_key, created_at, updated_at FROM accounts') AS b(
          name character varying(255),
          api_key character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE accounts;

      INSERT INTO brand_countries(brand_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT brand_id, country_id, created_at, updated_at FROM brand_countries') AS b(
          brand_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE brand_countries;

      INSERT INTO brand_links(link_text, link_url, brand_id, position, created_at, updated_at)
        SELECT * FROM dblink('SELECT link_text, link_url, brand_id, position, created_at, updated_at FROM brand_links') AS b(
          link_text character varying(255),
          link_url character varying(255),
          brand_id integer,
          position integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE brand_links;

      INSERT INTO brands(id, name, created_at, updated_at, image_file_name, image_content_type,
        image_file_size, image_updated_at, website_url, white_image_file_name, white_image_content_type,
        white_image_file_size, white_image_updated_at, introduction_video_heading_title, events_and_classes_heading_title)
        SELECT * FROM dblink('SELECT id, name, created_at, updated_at, image_file_name, image_content_type,
        image_file_size, image_updated_at, website_url, white_image_file_name, white_image_content_type,
        white_image_file_size, white_image_updated_at, introduction_video_heading_title, events_and_classes_heading_title FROM brands') AS b(
          id integer,
          name character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          image_file_name character varying(255),
          image_content_type character varying(255),
          image_file_size integer,
          image_updated_at timestamp without time zone,
          website_url character varying(255),
          white_image_file_name character varying(255),
          white_image_content_type character varying(255),
          white_image_file_size integer,
          white_image_updated_at timestamp without time zone,
          introduction_video_heading_title character varying(255),
          events_and_classes_heading_title character varying(255));

      ANALYZE brands;

      INSERT INTO brandables(id, brand_id, item_id, item_type, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, brand_id, item_id, item_type, created_at, updated_at FROM brandables') AS b(
          id integer,
          brand_id integer,
          item_id integer,
          item_type character varying,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE brandables;

      INSERT INTO brands_sola_classes(id, brand_id, sola_class_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, brand_id, sola_class_id, created_at, updated_at FROM brands_sola_classes') AS b(
          id integer,
          brand_id integer,
          sola_class_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE brands_sola_classes;

      INSERT INTO deal_categories(id, name, position, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, position, created_at, updated_at FROM deal_categories') AS b(
          id integer,
          name character varying(255),
          position integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE deal_categories;

      INSERT INTO deal_category_deals(id, deal_id, deal_category_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, deal_id, deal_category_id, created_at, updated_at FROM deal_category_deals') AS b(
          id integer,
          deal_id integer,
          deal_category_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE deal_category_deals;

      INSERT INTO deal_countries(id, deal_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, deal_id, country_id, created_at, updated_at FROM deal_countries') AS b(
          id integer,
          deal_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE deal_countries;

      INSERT INTO deals(id, title, file_file_name, file_content_type, file_file_size, file_updated_at, image_file_name, image_content_type, image_file_size, image_updated_at, brand_id, description, is_featured, hover_image_file_name, hover_image_content_type, hover_image_file_size, hover_image_updated_at, more_info_url, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, title, file_file_name, file_content_type, file_file_size, file_updated_at, image_file_name, image_content_type, image_file_size, image_updated_at, brand_id, description, is_featured, hover_image_file_name, hover_image_content_type, hover_image_file_size, hover_image_updated_at, more_info_url, created_at, updated_at FROM deals') AS b(
          id integer,
          title character varying(255),
          file_file_name character varying(255),
          file_content_type character varying(255),
          file_file_size integer,
          file_updated_at timestamp without time zone,
          image_file_name character varying(255),
          image_content_type character varying(255),
          image_file_size integer,
          image_updated_at timestamp without time zone,
          brand_id integer,
          description text,
          is_featured boolean,
          hover_image_file_name character varying(255),
          hover_image_content_type character varying(255),
          hover_image_file_size integer,
          hover_image_updated_at timestamp without time zone,
          more_info_url character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE deals;

      INSERT INTO devices(id, name, uuid, token, userable_type, userable_id, platform, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, uuid, token, userable_type, userable_id, platform, created_at, updated_at FROM devices') AS b(
          id integer,
          name character varying(255),
          uuid character varying(255),
          token character varying(255),
          userable_type character varying(255),
          userable_id integer,
          platform character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE devices;

      INSERT INTO distributors(id, name, url, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, url, created_at, updated_at FROM distributors') AS b(
          id integer,
          name character varying(255),
          url character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE distributors;

      INSERT INTO events(id, category, action, source, brand_id, deal_id, tool_id, sola_class_id, video_id, value, platform, userable_id, userable_type, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, category, action, source, brand_id, deal_id, tool_id, sola_class_id, video_id, value, platform, userable_id, userable_type, created_at, updated_at FROM events') AS b(
          id integer,
          category character varying,
          action character varying,
          source character varying,
          brand_id integer,
          deal_id integer,
          tool_id integer,
          sola_class_id integer,
          video_id integer,
          value character varying,
          platform character varying,
          userable_id integer,
          userable_type character varying,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE events;

      INSERT INTO get_featureds(id, name, email, phone_number, salon_name, salon_location, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, email, phone_number, salon_name, salon_location, created_at, updated_at FROM get_featureds') AS b(
          id integer,
          name character varying(255),
          email character varying(255),
          phone_number character varying(255),
          salon_name character varying(255),
          salon_location character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE get_featureds;

      INSERT INTO home_button_countries(id, home_button_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, home_button_id, country_id, created_at, updated_at FROM home_button_countries') AS b(
          id integer,
          home_button_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE home_button_countries;


      INSERT INTO home_buttons(id, position, action_link, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, position, action_link, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at FROM home_buttons') AS b(
          id integer,
          position integer,
          action_link character varying(255),
          image_file_name character varying(255),
          image_content_type character varying(255),
          image_file_size integer,
          image_updated_at timestamp without time zone,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE home_buttons;


      INSERT INTO home_hero_image_countries(id, home_hero_image_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, home_hero_image_id, country_id, created_at, updated_at FROM home_hero_image_countries') AS b(
          id integer,
          home_hero_image_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE home_hero_image_countries;


      INSERT INTO home_hero_images(id, position, action_link, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, position, action_link, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at FROM home_hero_images') AS b(
          id integer,
          position integer,
          action_link character varying(255),
          image_file_name character varying(255),
          image_content_type character varying(255),
          image_file_size integer,
          image_updated_at timestamp without time zone,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE home_hero_images;

      INSERT INTO notifications(id, brand_id, deal_id, tool_id, sola_class_id, video_id, notification_text, send_push_notification, blog_id, date_sent, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, brand_id, deal_id, tool_id, sola_class_id, video_id, notification_text, send_push_notification, blog_id, date_sent, created_at, updated_at FROM notifications') AS b(
          id integer,
          brand_id integer,
          deal_id integer,
          tool_id integer,
          sola_class_id integer,
          video_id integer,
          notification_text text,
          send_push_notification boolean,
          blog_id integer,
          date_sent timestamp without time zone,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE notifications;


      INSERT INTO pro_beauty_industries(id, title, short_description, long_description, file_file_name, file_content_type, file_file_size, file_updated_at, video_url, thumbnail_image_file_name, thumbnail_image_content_type, thumbnail_image_file_size, thumbnail_image_updated_at, flyer_image_file_name, flyer_image_content_type, flyer_image_file_size, flyer_image_updated_at, brand_id, pro_beauty_industry_category_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, title, short_description, long_description, file_file_name, file_content_type, file_file_size, file_updated_at, video_url, thumbnail_image_file_name, thumbnail_image_content_type, thumbnail_image_file_size, thumbnail_image_updated_at, flyer_image_file_name, flyer_image_content_type, flyer_image_file_size, flyer_image_updated_at, brand_id, pro_beauty_industry_category_id, created_at, updated_at FROM pro_beauty_industries') AS b(
          id integer,
          title character varying(255),
          short_description text,
          long_description text,
          file_file_name character varying(255),
          file_content_type character varying(255),
          file_file_size integer,
          file_updated_at timestamp without time zone,
          video_url character varying(255),
          thumbnail_image_file_name character varying(255),
          thumbnail_image_content_type character varying(255),
          thumbnail_image_file_size integer,
          thumbnail_image_updated_at timestamp without time zone,
          flyer_image_file_name character varying(255),
          flyer_image_content_type character varying(255),
          flyer_image_file_size integer,
          flyer_image_updated_at timestamp without time zone,
          brand_id integer,
          pro_beauty_industry_category_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE pro_beauty_industries;

      INSERT INTO pro_beauty_industry_categories(id, name, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, created_at, updated_at FROM pro_beauty_industry_categories') AS b(
          id integer,
          name character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE pro_beauty_industry_categories;


      INSERT INTO product_informations(id, title, description, link_url, brand_id, image_file_name, image_content_type, image_file_size, image_updated_at, file_file_name, file_content_type, file_file_size, file_updated_at, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, title, description, link_url, brand_id, image_file_name, image_content_type, image_file_size, image_updated_at, file_file_name, file_content_type, file_file_size, file_updated_at, created_at, updated_at FROM product_informations') AS b(
          id integer,
          title character varying(255),
          description text,
          link_url character varying(255),
          brand_id integer,
          image_file_name character varying(255),
          image_content_type character varying(255),
          image_file_size integer,
          image_updated_at timestamp without time zone,
          file_file_name character varying(255),
          file_content_type character varying(255),
          file_file_size integer,
          file_updated_at timestamp without time zone,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE product_informations;

      INSERT INTO reset_passwords(id, public_id, date_used, userable_id, userable_type, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, public_id, date_used, userable_id, userable_type, created_at, updated_at FROM reset_passwords') AS b(
          id integer,
          public_id character varying(255),
          date_used timestamp without time zone,
          userable_id integer,
          userable_type character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE reset_passwords;


      INSERT INTO saved_items(id, sola_stylist_id, admin_id, item_id, item_type, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, sola_stylist_id, admin_id, item_id, item_type, created_at, updated_at FROM saved_items') AS b(
          id integer,
          sola_stylist_id integer,
          admin_id integer,
          item_id integer,
          item_type character varying,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE saved_items;


      INSERT INTO short_links(id, url, public_id, view_count, title, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, url, public_id, view_count, title, created_at, updated_at FROM short_links') AS b(
          id integer,
          url character varying(255),
          public_id character varying(255),
          view_count bigint,
          title character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE short_links;


      INSERT INTO side_menu_item_countries(id, side_menu_item_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, side_menu_item_id, country_id, created_at, updated_at FROM side_menu_item_countries') AS b(
          id integer,
          side_menu_item_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE side_menu_item_countries;


      INSERT INTO side_menu_items(id, name, action_link, position, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, action_link, position, created_at, updated_at FROM side_menu_items') AS b(
          id integer,
          name character varying(255),
          action_link character varying(255),
          position integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE side_menu_items;


      INSERT INTO sola_class_categories(id, name, position, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, position, created_at, updated_at FROM sola_class_categories') AS b(
          id integer,
          name character varying(255),
          position integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE sola_class_categories;

      INSERT INTO sola_class_countries(id, sola_class_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, sola_class_id, country_id, created_at, updated_at FROM sola_class_countries') AS b(
          id integer,
          sola_class_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE sola_class_countries;


      INSERT INTO sola_class_region_countries(id, sola_class_region_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, sola_class_region_id, country_id, created_at, updated_at FROM sola_class_region_countries') AS b(
          id integer,
          sola_class_region_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE sola_class_region_countries;


      INSERT INTO sola_class_region_states(id, sola_class_region_id, state, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, sola_class_region_id, state, created_at, updated_at FROM sola_class_region_states') AS b(
          id integer,
          sola_class_region_id integer,
          state character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE sola_class_region_states;


      INSERT INTO sola_class_regions(id, name, position, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, position, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at FROM sola_class_regions') AS b(
          id integer,
          name character varying(255),
          position integer,
          image_file_name character varying(255),
          image_content_type character varying(255),
          image_file_size integer,
          image_updated_at timestamp without time zone,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE sola_class_regions;

      INSERT INTO sola_classes(id, title,
          city, state, postal_code, location, cost,
          start_date, start_time, created_at, updated_at, file_file_name, file_content_type, file_file_size, file_updated_at, link_text, link_url,
          latitude, longitude, sola_class_category_id, is_featured, admin_id, sola_class_region_id, description,
          image_file_name, image_content_type, image_file_size, image_updated_at, end_date, end_time, rsvp_email_address,
          rsvp_phone_number, address, video_id, file_text)
        SELECT * FROM dblink('SELECT * FROM sola_classes') AS b(
          id integer,
          title character varying(255),
          city character varying(255),
          state character varying(255),
          postal_code character varying(255),
          location character varying(255),
          cost character varying(255),
          start_date date,
          start_time text,
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          file_file_name character varying(255),
          file_content_type character varying(255),
          file_file_size integer,
          file_updated_at timestamp without time zone,
          link_text character varying(255),
          link_url character varying(255),
          latitude double precision,
          longitude double precision,
          sola_class_category_id integer,
          is_featured boolean,
          admin_id integer,
          sola_class_region_id integer,
          description text,
          image_file_name character varying(255),
          image_content_type character varying(255),
          image_file_size integer,
          image_updated_at timestamp without time zone,
          end_date date,
          end_time text,
          rsvp_email_address character varying(255),
          rsvp_phone_number character varying(255),
          address character varying(255),
          video_id integer,
          file_text character varying(255));

      ANALYZE sola_classes;

      INSERT INTO support_categories(id, name, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, created_at, updated_at FROM support_categories') AS b(
          id integer,
          name character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE support_categories;

      INSERT INTO supports(id, title, short_description, long_description, created_at, updated_at,
        thumbnail_image_file_name, thumbnail_image_content_type, thumbnail_image_file_size,
        thumbnail_image_updated_at, flyer_image_file_name, flyer_image_content_type, flyer_image_file_size,
        flyer_image_updated_at, file_file_name, file_content_type, file_file_size, file_updated_at, video_url, support_category_id)
        SELECT * FROM dblink('SELECT * FROM supports') AS b(
          id integer,
          title character varying(255),
          short_description text,
          long_description text,
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          thumbnail_image_file_name character varying(255),
          thumbnail_image_content_type character varying(255),
          thumbnail_image_file_size integer,
          thumbnail_image_updated_at timestamp without time zone,
          flyer_image_file_name character varying(255),
          flyer_image_content_type character varying(255),
          flyer_image_file_size integer,
          flyer_image_updated_at timestamp without time zone,
          file_file_name character varying(255),
          file_content_type character varying(255),
          file_file_size integer,
          file_updated_at timestamp without time zone,
          video_url character varying(255),
          support_category_id integer);

      ANALYZE supports;

      INSERT INTO tags(id, name, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, created_at, updated_at FROM tags') AS b(
          id integer,
          name character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE tags;

      INSERT INTO taggables(id, tag_id, item_id, item_type, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, tag_id, item_id, item_type, created_at, updated_at FROM taggables') AS b(
          id integer,
          tag_id integer,
          item_id integer,
          item_type character varying,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE taggables;

      INSERT INTO tags_videos(id, tag_id, video_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, tag_id, video_id, created_at, updated_at FROM tags_videos') AS b(
          id integer,
          tag_id integer,
          video_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE tags_videos;

      INSERT INTO tool_categories(id, name, position, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, name, position, created_at, updated_at FROM tool_categories') AS b(
          id integer,
          name character varying(255),
          position integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE tool_categories;

      INSERT INTO tool_category_tools(id, tool_id, tool_category_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, tool_id, tool_category_id, created_at, updated_at FROM tool_category_tools') AS b(
          id integer,
          tool_id integer,
          tool_category_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE tool_category_tools;


      INSERT INTO tool_countries(id, tool_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, tool_id, country_id, created_at, updated_at FROM tool_countries') AS b(
          id integer,
          tool_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE tool_countries;


      INSERT INTO tools(id, brand_id, title, description, is_featured, created_at, updated_at, image_file_name,
        image_content_type, image_file_size, image_updated_at, file_file_name, file_content_type, file_file_size, file_updated_at, link_url, youtube_url)
        SELECT * FROM dblink('SELECT id, brand_id, title, description, is_featured, created_at, updated_at, image_file_name,
        image_content_type, image_file_size, image_updated_at, file_file_name, file_content_type, file_file_size, file_updated_at, link_url, youtube_url FROM tools') AS b(
          id integer,
          brand_id integer,
          title character varying(255),
          description text,
          is_featured boolean,
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          image_file_name character varying(255),
          image_content_type character varying(255),
          image_file_size integer,
          image_updated_at timestamp without time zone,
          file_file_name character varying(255),
          file_content_type character varying(255),
          file_file_size integer,
          file_updated_at timestamp without time zone,
          link_url character varying(255),
          youtube_url character varying(255));

      ANALYZE tools;


      INSERT INTO user_access_tokens(id, sola_stylist_id, key, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, sola_stylist_id, key, created_at, updated_at FROM user_access_tokens') AS b(
          id integer,
          sola_stylist_id integer,
          key character varying,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE user_access_tokens;

      INSERT INTO user_notifications(id, userable_type, userable_id, dismiss_date, notification_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, userable_type, userable_id, dismiss_date, notification_id, created_at, updated_at FROM user_notifications') AS b(
          id integer,
          userable_type character varying(255),
          userable_id integer,
          dismiss_date timestamp without time zone,
          notification_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE user_notifications;


      INSERT INTO userable_notifications(id, userable_type, userable_id, notification_id, created_at, updated_at, is_dismissed)
        SELECT * FROM dblink('SELECT id, userable_type, userable_id, notification_id, created_at, updated_at, is_dismissed FROM userable_notifications') AS b(
          id integer,
          userable_type character varying(255),
          userable_id integer,
          notification_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          is_dismissed boolean);

      ANALYZE userable_notifications;


      INSERT INTO users(id, email, password_digest, created_at, updated_at, public_id)
        SELECT * FROM dblink('SELECT id, email, password_digest, created_at, updated_at, public_id FROM users') AS b(
          id integer,
          email character varying(255),
          password_digest character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          public_id character varying(255));

      ANALYZE users;


      INSERT INTO versions(item_type, item_id, event, whodunnit, object, created_at, object_changes)
        SELECT * FROM dblink('SELECT item_type, item_id, event, whodunnit, object, created_at, object_changes FROM versions') AS b(
          item_type character varying(255),
          item_id integer,
          event character varying(255),
          whodunnit character varying(255),
          object text,
          created_at timestamp without time zone,
          object_changes text);

      ANALYZE versions;


      INSERT INTO video_categories(id, name, created_at, updated_at, position)
        SELECT * FROM dblink('SELECT id, name, created_at, updated_at, position FROM video_categories') AS b(
          id integer,
          name character varying(255),
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          position integer);

      ANALYZE video_categories;


      INSERT INTO video_category_videos(id, video_id, video_category_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, video_id, video_category_id, created_at, updated_at FROM video_category_videos') AS b(
          id integer,
          video_id integer,
          video_category_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE video_category_videos;


      INSERT INTO video_countries(id, video_id, country_id, created_at, updated_at)
        SELECT * FROM dblink('SELECT id, video_id, country_id, created_at, updated_at FROM video_countries') AS b(
          id integer,
          video_id integer,
          country_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone);

      ANALYZE video_countries;

      INSERT INTO video_views(id, video_id, created_at, updated_at, userable_type, userable_id)
        SELECT * FROM dblink('SELECT id, video_id, created_at, updated_at, userable_type, userable_id FROM video_views') AS b(
          id integer,
          video_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          userable_type character varying(255),
          userable_id integer);

      ANALYZE video_views;

      INSERT INTO videos(id, brand_id, title, description, is_featured, created_at, updated_at,
          youtube_url, tool_id, duration, is_introduction, link_url, link_text)
        SELECT * FROM dblink('SELECT id, brand_id, title, description, is_featured, created_at, updated_at,
          youtube_url, tool_id, duration, is_introduction, link_url, link_text FROM videos') AS b(
          id integer,
          brand_id integer,
          title character varying(255),
          description text,
          is_featured boolean,
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          youtube_url character varying(255),
          tool_id integer,
          duration character varying(255),
          is_introduction boolean,
          link_url character varying(255),
          link_text character varying(255));

      ANALYZE videos;

      INSERT INTO watch_laters(id, video_id, created_at, updated_at, userable_type, userable_id)
        SELECT * FROM dblink('SELECT id, video_id, created_at, updated_at, userable_type, userable_id FROM watch_laters') AS b(
          id integer,
          video_id integer,
          created_at timestamp without time zone,
          updated_at timestamp without time zone,
          userable_type character varying(255),
          userable_id integer);

      ANALYZE watch_laters;

      SELECT dblink_disconnect();

      SELECT setval('accounts_id_seq', max(id)) FROM accounts;
      SELECT setval('brand_countries_id_seq', max(id)) FROM brand_countries;
      SELECT setval('brand_links_id_seq', max(id)) FROM brand_links;
      SELECT setval('brands_id_seq', max(id)) FROM brands;
      SELECT setval('brandables_id_seq', max(id)) FROM brandables;
      SELECT setval('brands_sola_classes_id_seq', max(id)) FROM brands_sola_classes;
      SELECT setval('deal_categories_id_seq', max(id)) FROM deal_categories;
      SELECT setval('deal_category_deals_id_seq', max(id)) FROM deal_category_deals;
      SELECT setval('deal_countries_id_seq', max(id)) FROM deal_countries;
      SELECT setval('deals_id_seq', max(id)) FROM deals;
      SELECT setval('devices_id_seq', max(id)) FROM devices;
      SELECT setval('distributors_id_seq', max(id)) FROM distributors;
      SELECT setval('events_id_seq', max(id)) FROM events;
      SELECT setval('get_featureds_id_seq', max(id)) FROM get_featureds;
      SELECT setval('home_button_countries_id_seq', max(id)) FROM home_button_countries;
      SELECT setval('home_buttons_id_seq', max(id)) FROM home_buttons;
      SELECT setval('home_hero_image_countries_id_seq', max(id)) FROM home_hero_image_countries;
      SELECT setval('home_hero_images_id_seq', max(id)) FROM home_hero_images;
      SELECT setval('notifications_id_seq', max(id)) FROM notifications;
      SELECT setval('pro_beauty_industries_id_seq', max(id)) FROM pro_beauty_industries;
      SELECT setval('pro_beauty_industry_categories_id_seq', max(id)) FROM pro_beauty_industry_categories;
      SELECT setval('product_informations_id_seq', max(id)) FROM product_informations;
      SELECT setval('saved_items_id_seq', max(id)) FROM saved_items;
      SELECT setval('short_links_id_seq', max(id)) FROM short_links;
      SELECT setval('side_menu_item_countries_id_seq', max(id)) FROM side_menu_item_countries;
      SELECT setval('side_menu_items_id_seq', max(id)) FROM side_menu_items;
      SELECT setval('sola_class_categories_id_seq', max(id)) FROM sola_class_categories;
      SELECT setval('sola_class_countries_id_seq', max(id)) FROM sola_class_countries;
      SELECT setval('sola_class_region_countries_id_seq', max(id)) FROM sola_class_region_countries;
      SELECT setval('sola_class_region_states_id_seq', max(id)) FROM sola_class_region_states;
      SELECT setval('sola_class_regions_id_seq', max(id)) FROM sola_class_regions;
      SELECT setval('sola_classes_id_seq', max(id)) FROM sola_classes;
      SELECT setval('support_categories_id_seq', max(id)) FROM support_categories;
      SELECT setval('supports_id_seq', max(id)) FROM supports;
      SELECT setval('tags_id_seq', max(id)) FROM tags;
      SELECT setval('taggables_id_seq', max(id)) FROM taggables;
      SELECT setval('tags_videos_id_seq', max(id)) FROM tags_videos;
      SELECT setval('tool_categories_id_seq', max(id)) FROM tool_categories;
      SELECT setval('tool_category_tools_id_seq', max(id)) FROM tool_category_tools;
      SELECT setval('tool_countries_id_seq', max(id)) FROM tool_countries;
      SELECT setval('tools_id_seq', max(id)) FROM tools;
      SELECT setval('user_access_tokens_id_seq', max(id)) FROM user_access_tokens;
      SELECT setval('user_notifications_id_seq', max(id)) FROM user_notifications;
      SELECT setval('userable_notifications_id_seq', max(id)) FROM userable_notifications;
      SELECT setval('users_id_seq', max(id)) FROM users;
      SELECT setval('versions_id_seq', max(id)) FROM versions;
      SELECT setval('video_categories_id_seq', max(id)) FROM video_categories;
      SELECT setval('video_category_videos_id_seq', max(id)) FROM video_category_videos;
      SELECT setval('video_countries_id_seq', max(id)) FROM video_countries;
      SELECT setval('video_views_id_seq', max(id)) FROM video_views;
      SELECT setval('videos_id_seq', max(id)) FROM videos;
      SELECT setval('watch_laters_id_seq', max(id)) FROM watch_laters;
")


    ActiveRecord::Base.connection.execute("
      INSERT INTO schema_migrations (version) VALUES ('20141029230220');
      INSERT INTO schema_migrations (version) VALUES ('20141029230302');
      INSERT INTO schema_migrations (version) VALUES ('20141029230633');
      INSERT INTO schema_migrations (version) VALUES ('20141029230650');
      INSERT INTO schema_migrations (version) VALUES ('20141029230702');
      INSERT INTO schema_migrations (version) VALUES ('20141029230811');
      INSERT INTO schema_migrations (version) VALUES ('20141029230939');
      INSERT INTO schema_migrations (version) VALUES ('20141107152858');
      INSERT INTO schema_migrations (version) VALUES ('20141107183943');
      INSERT INTO schema_migrations (version) VALUES ('20141107183944');
      INSERT INTO schema_migrations (version) VALUES ('20141107184314');
      INSERT INTO schema_migrations (version) VALUES ('20141107184528');
      INSERT INTO schema_migrations (version) VALUES ('20141108050009');
      INSERT INTO schema_migrations (version) VALUES ('20141108050548');
      INSERT INTO schema_migrations (version) VALUES ('20141108204750');
      INSERT INTO schema_migrations (version) VALUES ('20141108204925');
      INSERT INTO schema_migrations (version) VALUES ('20141108210247');
      INSERT INTO schema_migrations (version) VALUES ('20141108211020');
      INSERT INTO schema_migrations (version) VALUES ('20141108211117');
      INSERT INTO schema_migrations (version) VALUES ('20141108211144');
      INSERT INTO schema_migrations (version) VALUES ('20141108211225');
      INSERT INTO schema_migrations (version) VALUES ('20141108211824');
      INSERT INTO schema_migrations (version) VALUES ('20141108211906');
      INSERT INTO schema_migrations (version) VALUES ('20141108212147');
      INSERT INTO schema_migrations (version) VALUES ('20141108212236');
      INSERT INTO schema_migrations (version) VALUES ('20141108212459');
      INSERT INTO schema_migrations (version) VALUES ('20141113203502');
      INSERT INTO schema_migrations (version) VALUES ('20141115130929');
      INSERT INTO schema_migrations (version) VALUES ('20141116151339');
      INSERT INTO schema_migrations (version) VALUES ('20141116205617');
      INSERT INTO schema_migrations (version) VALUES ('20141116210200');
      INSERT INTO schema_migrations (version) VALUES ('20141116211428');
      INSERT INTO schema_migrations (version) VALUES ('20141116211441');
      INSERT INTO schema_migrations (version) VALUES ('20141116211636');
      INSERT INTO schema_migrations (version) VALUES ('20141116211711');
      INSERT INTO schema_migrations (version) VALUES ('20141116211757');
      INSERT INTO schema_migrations (version) VALUES ('20141116211820');
      INSERT INTO schema_migrations (version) VALUES ('20141116212857');
      INSERT INTO schema_migrations (version) VALUES ('20141116212910');
      INSERT INTO schema_migrations (version) VALUES ('20141116212922');
      INSERT INTO schema_migrations (version) VALUES ('20141116213925');
      INSERT INTO schema_migrations (version) VALUES ('20141116213939');
      INSERT INTO schema_migrations (version) VALUES ('20141117164137');
      INSERT INTO schema_migrations (version) VALUES ('20141118211401');
      INSERT INTO schema_migrations (version) VALUES ('20150724213427');
      INSERT INTO schema_migrations (version) VALUES ('20150730155514');
      INSERT INTO schema_migrations (version) VALUES ('20150730155922');
      INSERT INTO schema_migrations (version) VALUES ('20150730202258');
      INSERT INTO schema_migrations (version) VALUES ('20150730202741');
      INSERT INTO schema_migrations (version) VALUES ('20150730223630');
      INSERT INTO schema_migrations (version) VALUES ('20150730223711');
      INSERT INTO schema_migrations (version) VALUES ('20150730223825');
      INSERT INTO schema_migrations (version) VALUES ('20150730223926');
      INSERT INTO schema_migrations (version) VALUES ('20150730224031');
      INSERT INTO schema_migrations (version) VALUES ('20150730224107');
      INSERT INTO schema_migrations (version) VALUES ('20150730224158');
      INSERT INTO schema_migrations (version) VALUES ('20150730225311');
      INSERT INTO schema_migrations (version) VALUES ('20150730225327');
      INSERT INTO schema_migrations (version) VALUES ('20150731143722');
      INSERT INTO schema_migrations (version) VALUES ('20150731150837');
      INSERT INTO schema_migrations (version) VALUES ('20150731181858');
      INSERT INTO schema_migrations (version) VALUES ('20150731182049');
      INSERT INTO schema_migrations (version) VALUES ('20150731201430');
      INSERT INTO schema_migrations (version) VALUES ('20150812180459');
      INSERT INTO schema_migrations (version) VALUES ('20150812180534');
      INSERT INTO schema_migrations (version) VALUES ('20150812181013');
      INSERT INTO schema_migrations (version) VALUES ('20150818211628');
      INSERT INTO schema_migrations (version) VALUES ('20150818213234');
      INSERT INTO schema_migrations (version) VALUES ('20150818215100');
      INSERT INTO schema_migrations (version) VALUES ('20150819160911');
      INSERT INTO schema_migrations (version) VALUES ('20150819161312');
      INSERT INTO schema_migrations (version) VALUES ('20150821170225');
      INSERT INTO schema_migrations (version) VALUES ('20150825151715');
      INSERT INTO schema_migrations (version) VALUES ('20150825152329');
      INSERT INTO schema_migrations (version) VALUES ('20150825152404');
      INSERT INTO schema_migrations (version) VALUES ('20150828180515');
      INSERT INTO schema_migrations (version) VALUES ('20150828180704');
      INSERT INTO schema_migrations (version) VALUES ('20150902225440');
      INSERT INTO schema_migrations (version) VALUES ('20150904213722');
      INSERT INTO schema_migrations (version) VALUES ('20150910201506');
      INSERT INTO schema_migrations (version) VALUES ('20150910201523');
      INSERT INTO schema_migrations (version) VALUES ('20150910204018');
      INSERT INTO schema_migrations (version) VALUES ('20150910213821');
      INSERT INTO schema_migrations (version) VALUES ('20150923214743');
      INSERT INTO schema_migrations (version) VALUES ('20150925164550');
      INSERT INTO schema_migrations (version) VALUES ('20150925165125');
      INSERT INTO schema_migrations (version) VALUES ('20151008164826');
      INSERT INTO schema_migrations (version) VALUES ('20151009154110');
      INSERT INTO schema_migrations (version) VALUES ('20151028161709');
      INSERT INTO schema_migrations (version) VALUES ('20151106221331');
      INSERT INTO schema_migrations (version) VALUES ('20151117222106');
      INSERT INTO schema_migrations (version) VALUES ('20151120230650');
      INSERT INTO schema_migrations (version) VALUES ('20151201212142');
      INSERT INTO schema_migrations (version) VALUES ('20151208145835');
      INSERT INTO schema_migrations (version) VALUES ('20151208150630');
      INSERT INTO schema_migrations (version) VALUES ('20151208181744');
      INSERT INTO schema_migrations (version) VALUES ('20151208182837');
      INSERT INTO schema_migrations (version) VALUES ('20151208183408');
      INSERT INTO schema_migrations (version) VALUES ('20151208210603');
      INSERT INTO schema_migrations (version) VALUES ('20151208210855');
      INSERT INTO schema_migrations (version) VALUES ('20151209154841');
      INSERT INTO schema_migrations (version) VALUES ('20151209162108');
      INSERT INTO schema_migrations (version) VALUES ('20151217180849');
      INSERT INTO schema_migrations (version) VALUES ('20151217190537');
      INSERT INTO schema_migrations (version) VALUES ('20151217190801');
      INSERT INTO schema_migrations (version) VALUES ('20151217192531');
      INSERT INTO schema_migrations (version) VALUES ('20151217192556');
      INSERT INTO schema_migrations (version) VALUES ('20151217192624');
      INSERT INTO schema_migrations (version) VALUES ('20160328224819');
      INSERT INTO schema_migrations (version) VALUES ('20160328225632');
      INSERT INTO schema_migrations (version) VALUES ('20160527181234');
      INSERT INTO schema_migrations (version) VALUES ('20160901140038');
      INSERT INTO schema_migrations (version) VALUES ('20160901140141');
      INSERT INTO schema_migrations (version) VALUES ('20160901140210');
      INSERT INTO schema_migrations (version) VALUES ('20160901153804');
      INSERT INTO schema_migrations (version) VALUES ('20160907165557');
      INSERT INTO schema_migrations (version) VALUES ('20160921134743');
      INSERT INTO schema_migrations (version) VALUES ('20160921135431');
      INSERT INTO schema_migrations (version) VALUES ('20161215221023');
      INSERT INTO schema_migrations (version) VALUES ('20170224165741');
      INSERT INTO schema_migrations (version) VALUES ('20170317181128');
      INSERT INTO schema_migrations (version) VALUES ('20170502212406');
      INSERT INTO schema_migrations (version) VALUES ('20170616194953');
      INSERT INTO schema_migrations (version) VALUES ('20170813212552');
      INSERT INTO schema_migrations (version) VALUES ('20170813214457');
      INSERT INTO schema_migrations (version) VALUES ('20170813215945');
      INSERT INTO schema_migrations (version) VALUES ('20170813220555');
      INSERT INTO schema_migrations (version) VALUES ('20170813220929');
      INSERT INTO schema_migrations (version) VALUES ('20170813221229');
      INSERT INTO schema_migrations (version) VALUES ('20170911155741');
      INSERT INTO schema_migrations (version) VALUES ('20170911155801');
      INSERT INTO schema_migrations (version) VALUES ('20170911160429');
      INSERT INTO schema_migrations (version) VALUES ('20170911160550');
      INSERT INTO schema_migrations (version) VALUES ('20170911163518');
      INSERT INTO schema_migrations (version) VALUES ('20170911163531');
      INSERT INTO schema_migrations (version) VALUES ('20170911163623');
      INSERT INTO schema_migrations (version) VALUES ('20170912225139');
      INSERT INTO schema_migrations (version) VALUES ('20170912225203');
      INSERT INTO schema_migrations (version) VALUES ('20170913224315');
      INSERT INTO schema_migrations (version) VALUES ('20170913225711');
      INSERT INTO schema_migrations (version) VALUES ('20170913225819');
      INSERT INTO schema_migrations (version) VALUES ('20180328223523');
      INSERT INTO schema_migrations (version) VALUES ('20191227212010');
      INSERT INTO schema_migrations (version) VALUES ('20191227231325');
      INSERT INTO schema_migrations (version) VALUES ('20191227231503');
      INSERT INTO schema_migrations (version) VALUES ('20200713123457');
      INSERT INTO schema_migrations (version) VALUES ('20200721113835');
      INSERT INTO schema_migrations (version) VALUES ('20200721120311');
      INSERT INTO schema_migrations (version) VALUES ('20200811095747');
    ")
  end
end
