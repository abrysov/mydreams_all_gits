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

ActiveRecord::Schema.define(version: 20160701115801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abuses", force: :cascade do |t|
    t.integer  "abusable_id"
    t.string   "abusable_type"
    t.integer  "moderator_id"
    t.integer  "notify_id"
    t.text     "text"
    t.string   "state"
    t.integer  "complain_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "abuses", ["abusable_type", "abusable_id"], name: "index_abuses_on_abusable_type_and_abusable_id", using: :btree
  add_index "abuses", ["complain_id"], name: "index_abuses_on_complain_id", using: :btree
  add_index "abuses", ["moderator_id"], name: "index_abuses_on_moderator_id", using: :btree
  add_index "abuses", ["notify_id"], name: "index_abuses_on_notify_id", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.integer  "amount",     default: 0, null: false
    t.integer  "dreamer_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "accounts", ["dreamer_id"], name: "index_accounts_on_dreamer_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "viewed",         default: false
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "ad_banner_tags", force: :cascade do |t|
    t.integer  "ad_banner_id"
    t.integer  "tag_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "ad_banner_tags", ["ad_banner_id"], name: "index_ad_banner_tags_on_ad_banner_id", using: :btree
  add_index "ad_banner_tags", ["tag_id"], name: "index_ad_banner_tags_on_tag_id", using: :btree

  create_table "ad_banners", force: :cascade do |t|
    t.string   "image"
    t.string   "url"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ad_link_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "ad_link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ad_link_tags", ["ad_link_id"], name: "index_ad_link_tags_on_ad_link_id", using: :btree
  add_index "ad_link_tags", ["tag_id"], name: "index_ad_link_tags_on_tag_id", using: :btree

  create_table "ad_links", force: :cascade do |t|
    t.string   "url"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ad_page_banners", force: :cascade do |t|
    t.integer  "ad_page_id"
    t.integer  "banner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ad_page_banners", ["ad_page_id"], name: "index_ad_page_banners_on_ad_page_id", using: :btree
  add_index "ad_page_banners", ["banner_id"], name: "index_ad_page_banners_on_banner_id", using: :btree

  create_table "ad_pages", force: :cascade do |t|
    t.string   "route"
    t.integer  "banner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ad_pages", ["banner_id"], name: "index_ad_pages_on_banner_id", using: :btree

  create_table "advertisers", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "attachmentable_id"
    t.string   "attachmentable_type"
    t.text     "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_new"
  end

  create_table "avatars", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.text     "photo"
    t.text     "crop_meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "avatars", ["dreamer_id"], name: "index_avatars_on_dreamer_id", using: :btree

  create_table "banners", force: :cascade do |t|
    t.string   "image"
    t.string   "link"
    t.string   "name"
    t.integer  "advertiser_id"
    t.datetime "date_start"
    t.datetime "date_end"
    t.integer  "show_count",    default: 0
    t.integer  "cross_count",   default: 0
    t.string   "link_hash"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "blocked_users", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.integer  "moderator_id"
    t.integer  "abuse_id"
    t.text     "text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "blocked_users", ["abuse_id"], name: "index_blocked_users_on_abuse_id", using: :btree
  add_index "blocked_users", ["dreamer_id"], name: "index_blocked_users_on_dreamer_id", using: :btree
  add_index "blocked_users", ["moderator_id"], name: "index_blocked_users_on_moderator_id", using: :btree

  create_table "certificate_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "value",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificates", force: :cascade do |t|
    t.integer  "certificate_type_id"
    t.integer  "certifiable_id",                      null: false
    t.string   "certifiable_type",                    null: false
    t.integer  "gifted_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",                default: false
    t.boolean  "accepted",            default: false
    t.text     "wish"
    t.string   "certificate_name"
    t.integer  "launches",            default: 0,     null: false
  end

  add_index "certificates", ["certifiable_id", "certifiable_type"], name: "index_certificates_on_certifiable_id_and_certifiable_type", using: :btree
  add_index "certificates", ["certificate_type_id"], name: "index_certificates_on_certificate_type_id", using: :btree
  add_index "certificates", ["gifted_by_id"], name: "index_certificates_on_gifted_by_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
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

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "dreamer_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "likes_count",      default: 0
    t.integer  "comments_count",   default: 0
    t.datetime "deleted_at"
    t.boolean  "host_viewed",      default: false
    t.datetime "review_date"
    t.boolean  "ios_safe"
    t.boolean  "nsfw"
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree

  create_table "complains", force: :cascade do |t|
    t.integer  "complainer_id"
    t.integer  "suspected_id"
    t.integer  "complainable_id"
    t.string   "complainable_type"
    t.string   "state"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "complains", ["complainable_type", "complainable_id"], name: "index_complains_on_complainable_type_and_complainable_id", using: :btree
  add_index "complains", ["complainer_id"], name: "index_complains_on_complainer_id", using: :btree
  add_index "complains", ["suspected_id"], name: "index_complains_on_suspected_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "member_ids", default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "conversations", ["member_ids"], name: "index_conversations_on_member_ids", using: :btree

  create_table "dream_cities", force: :cascade do |t|
    t.string   "name"
    t.string   "meta"
    t.string   "code"
    t.string   "prefix"
    t.string   "important"
    t.integer  "osm_id",            limit: 8
    t.integer  "dream_country_id"
    t.integer  "dream_region_id"
    t.integer  "dream_district_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "postcode"
  end

  add_index "dream_cities", ["dream_country_id"], name: "index_dream_cities_on_dream_country_id", using: :btree
  add_index "dream_cities", ["dream_district_id"], name: "index_dream_cities_on_dream_district_id", using: :btree
  add_index "dream_cities", ["dream_region_id"], name: "index_dream_cities_on_dream_region_id", using: :btree
  add_index "dream_cities", ["osm_id"], name: "index_dream_cities_on_osm_id", using: :btree

  create_table "dream_city_translations", force: :cascade do |t|
    t.integer  "dream_city_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
    t.string   "meta"
    t.string   "prefix"
  end

  add_index "dream_city_translations", ["dream_city_id"], name: "index_dream_city_translations_on_dream_city_id", using: :btree
  add_index "dream_city_translations", ["locale"], name: "index_dream_city_translations_on_locale", using: :btree
  add_index "dream_city_translations", ["name"], name: "index_dream_city_translations_on_name", using: :btree

  create_table "dream_come_true_emails", force: :cascade do |t|
    t.integer  "dream_id"
    t.string   "additional_text"
    t.string   "snapshot"
    t.integer  "sender_id"
    t.string   "state"
    t.datetime "sended_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "dream_come_true_emails", ["dream_id"], name: "index_dream_come_true_emails_on_dream_id", using: :btree
  add_index "dream_come_true_emails", ["sender_id"], name: "index_dream_come_true_emails_on_sender_id", using: :btree

  create_table "dream_countries", force: :cascade do |t|
    t.string   "name"
    t.string   "alt_name"
    t.string   "meta"
    t.string   "code"
    t.integer  "number"
    t.integer  "osm_id",     limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "dream_countries", ["number"], name: "index_dream_countries_on_number", using: :btree
  add_index "dream_countries", ["osm_id"], name: "index_dream_countries_on_osm_id", using: :btree

  create_table "dream_country_translations", force: :cascade do |t|
    t.integer  "dream_country_id", null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "name"
    t.string   "meta"
    t.string   "alt_name"
  end

  add_index "dream_country_translations", ["dream_country_id"], name: "index_dream_country_translations_on_dream_country_id", using: :btree
  add_index "dream_country_translations", ["locale"], name: "index_dream_country_translations_on_locale", using: :btree

  create_table "dream_district_translations", force: :cascade do |t|
    t.integer  "dream_district_id", null: false
    t.string   "locale",            null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.string   "meta"
  end

  add_index "dream_district_translations", ["dream_district_id"], name: "index_dream_district_translations_on_dream_district_id", using: :btree
  add_index "dream_district_translations", ["locale"], name: "index_dream_district_translations_on_locale", using: :btree

  create_table "dream_districts", force: :cascade do |t|
    t.string   "name"
    t.string   "meta"
    t.string   "code"
    t.integer  "osm_id",           limit: 8
    t.integer  "dream_country_id"
    t.integer  "dream_region_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "dream_districts", ["dream_country_id"], name: "index_dream_districts_on_dream_country_id", using: :btree
  add_index "dream_districts", ["dream_region_id"], name: "index_dream_districts_on_dream_region_id", using: :btree
  add_index "dream_districts", ["osm_id"], name: "index_dream_districts_on_osm_id", using: :btree

  create_table "dream_hidden_tags", force: :cascade do |t|
    t.integer  "dream_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "dream_hidden_tags", ["dream_id"], name: "index_dream_hidden_tags_on_dream_id", using: :btree
  add_index "dream_hidden_tags", ["tag_id"], name: "index_dream_hidden_tags_on_tag_id", using: :btree

  create_table "dream_region_translations", force: :cascade do |t|
    t.integer  "dream_region_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.string   "meta"
    t.string   "official_name"
  end

  add_index "dream_region_translations", ["dream_region_id"], name: "index_dream_region_translations_on_dream_region_id", using: :btree
  add_index "dream_region_translations", ["locale"], name: "index_dream_region_translations_on_locale", using: :btree

  create_table "dream_regions", force: :cascade do |t|
    t.string   "name"
    t.string   "meta"
    t.string   "code"
    t.integer  "osm_id",           limit: 8
    t.integer  "dream_country_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "official_name"
  end

  add_index "dream_regions", ["dream_country_id"], name: "index_dream_regions_on_dream_country_id", using: :btree
  add_index "dream_regions", ["osm_id"], name: "index_dream_regions_on_osm_id", using: :btree

  create_table "dreamer_cities", force: :cascade do |t|
    t.string   "name_ru"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name_en"
    t.string   "code"
  end

  add_index "dreamer_cities", ["country_id"], name: "index_dreamer_cities_on_country_id", using: :btree

  create_table "dreamer_countries", force: :cascade do |t|
    t.string   "name_ru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name_en"
    t.string   "flag"
    t.string   "code"
  end

  create_table "dreamers", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password",      default: "",    null: false
    t.string   "first_name",                              null: false
    t.string   "last_name"
    t.boolean  "gender_male",             default: false, null: false
    t.string   "phone"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "is_vip",                  default: false
    t.integer  "visits_count",            default: 0
    t.integer  "dreamer_country_id"
    t.integer  "dreamer_city_id"
    t.datetime "last_reload_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "deleted_at"
    t.date     "birthday"
    t.string   "background"
    t.string   "authentication_token"
    t.boolean  "project_dreamer",         default: false
    t.boolean  "celebrity"
    t.datetime "photobar_added_at"
    t.text     "photobar_added_text"
    t.integer  "photobar_added_photo_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",         default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "invitation_token"
    t.integer  "followers_count",         default: 0
    t.integer  "followees_count",         default: 0
    t.string   "status"
    t.string   "avatar"
    t.string   "page_bg"
    t.string   "dreambook_bg"
    t.string   "role"
    t.datetime "blocked_at"
    t.integer  "current_avatar_id",       default: 0,     null: false
    t.text     "crop_meta"
    t.integer  "dream_country_id"
    t.integer  "dream_city_id"
    t.string   "gender"
    t.datetime "review_date"
    t.boolean  "ios_safe"
    t.boolean  "nsfw"
    t.datetime "last_news_viewed_at"
    t.boolean  "online"
  end

  add_index "dreamers", ["birthday"], name: "index_dreamers_on_birthday", using: :btree
  add_index "dreamers", ["celebrity"], name: "index_dreamers_on_celebrity", using: :btree
  add_index "dreamers", ["created_at"], name: "index_dreamers_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "dreamers", ["deleted_at"], name: "index_dreamers_on_deleted_at", using: :btree
  add_index "dreamers", ["deleted_at"], name: "index_dreamers_on_deleted_at_is_null", where: "(deleted_at IS NULL)", using: :btree
  add_index "dreamers", ["dream_city_id"], name: "index_dreamers_on_dream_city_id", using: :btree
  add_index "dreamers", ["dream_country_id"], name: "index_dreamers_on_dream_country_id", using: :btree
  add_index "dreamers", ["dreamer_city_id"], name: "index_dreamers_on_dreamer_city_id", using: :btree
  add_index "dreamers", ["dreamer_country_id"], name: "index_dreamers_on_dreamer_country_id", using: :btree
  add_index "dreamers", ["email"], name: "index_dreamers_on_email", unique: true, using: :btree
  add_index "dreamers", ["gender_male"], name: "index_dreamers_on_gender_male", using: :btree
  add_index "dreamers", ["is_vip"], name: "index_dreamers_on_is_vip", using: :btree
  add_index "dreamers", ["last_reload_at"], name: "index_dreamers_on_last_reload_at", order: {"last_reload_at"=>:desc}, using: :btree
  add_index "dreamers", ["reset_password_token"], name: "index_dreamers_on_reset_password_token", unique: true, using: :btree
  add_index "dreamers", ["visits_count"], name: "index_dreamers_on_visits_count", order: {"visits_count"=>:desc}, using: :btree

  create_table "dreams", force: :cascade do |t|
    t.string   "title",                                                 null: false
    t.boolean  "came_true",                             default: false
    t.integer  "dreamer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",                           default: 0
    t.integer  "comments_count",                        default: 0
    t.integer  "taken_from_id"
    t.text     "description"
    t.datetime "deleted_at"
    t.integer  "restriction_level",           limit: 2, default: 0
    t.string   "state"
    t.string   "gift_comment"
    t.text     "video"
    t.integer  "position",                              default: 0
    t.string   "type"
    t.integer  "suggested_from_id"
    t.datetime "last_paid_at"
    t.string   "photo"
    t.integer  "launches_count",                        default: 0
    t.integer  "summary_certificate_type_id"
    t.datetime "review_date"
    t.boolean  "ios_safe"
    t.boolean  "nsfw"
    t.datetime "fulfilled_at"
    t.text     "photo_crop"
  end

  add_index "dreams", ["came_true"], name: "index_dreams_on_came_true", using: :btree
  add_index "dreams", ["comments_count"], name: "index_dreams_on_comments_count", order: {"comments_count"=>:desc}, using: :btree
  add_index "dreams", ["created_at"], name: "index_dreams_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "dreams", ["deleted_at"], name: "index_dreams_on_deleted_at", using: :btree
  add_index "dreams", ["deleted_at"], name: "index_dreams_on_deleted_at_is_null", where: "(deleted_at IS NULL)", using: :btree
  add_index "dreams", ["dreamer_id"], name: "index_dreams_on_dreamer_id", using: :btree
  add_index "dreams", ["likes_count"], name: "index_dreams_on_likes_count", order: {"likes_count"=>:desc}, using: :btree
  add_index "dreams", ["position"], name: "index_dreams_on_position", using: :btree
  add_index "dreams", ["restriction_level"], name: "index_dreams_on_restriction_level", using: :btree
  add_index "dreams", ["state"], name: "index_dreams_on_state", using: :btree
  add_index "dreams", ["type"], name: "index_dreams_on_type", using: :btree

  create_table "emails", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.string   "email"
    t.boolean  "confirmed",   default: false
    t.boolean  "sent",        default: false
    t.boolean  "deferral",    default: false
    t.boolean  "hard_bounce", default: false
    t.boolean  "soft_bounce", default: false
    t.boolean  "open",        default: false
    t.boolean  "click",       default: false
    t.boolean  "spam",        default: false
    t.boolean  "unsub",       default: false
    t.boolean  "reject",      default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "emails", ["email"], name: "index_emails_on_email", unique: true, using: :btree

  create_table "exchange_rates", force: :cascade do |t|
    t.string   "currency1",  null: false
    t.string   "currency2",  null: false
    t.float    "rate",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_transactions", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "amount"
    t.string   "operation"
    t.string   "state"
    t.string   "gateway_id"
    t.string   "external_transaction_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.json     "response"
    t.decimal  "inc_money"
    t.string   "inc_currency"
    t.decimal  "out_money"
    t.string   "out_currency"
    t.integer  "invoice_id"
  end

  add_index "external_transactions", ["account_id"], name: "index_external_transactions_on_account_id", using: :btree
  add_index "external_transactions", ["invoice_id"], name: "index_external_transactions_on_invoice_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.integer  "initiator_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["dreamer_id"], name: "index_feedbacks_on_dreamer_id", using: :btree
  add_index "feedbacks", ["initiator_id"], name: "index_feedbacks_on_initiator_id", using: :btree

  create_table "followings", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.datetime "viewed_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "view_state"
  end

  add_index "followings", ["followee_id"], name: "index_followings_on_followee_id", using: :btree
  add_index "followings", ["follower_id"], name: "index_followings_on_follower_id", using: :btree

  create_table "friend_requests", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "friend_requests", ["receiver_id", "sender_id"], name: "index_friend_requests_on_receiver_id_and_sender_id", using: :btree
  add_index "friend_requests", ["receiver_id"], name: "index_friend_requests_on_receiver_id", using: :btree
  add_index "friend_requests", ["sender_id", "receiver_id"], name: "index_friend_requests_on_sender_id_and_receiver_id", using: :btree
  add_index "friend_requests", ["sender_id"], name: "index_friend_requests_on_sender_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.datetime "accepted_at"
    t.boolean  "subscribing"
    t.boolean  "processed"
    t.boolean  "friend_viewed", default: false
    t.integer  "member_ids",                    array: true
  end

  add_index "friendships", ["accepted_at"], name: "index_friendships_on_accepted_at", order: {"accepted_at"=>:desc}, using: :btree
  add_index "friendships", ["deleted_at"], name: "index_friendships_on_deleted_at", using: :btree
  add_index "friendships", ["deleted_at"], name: "index_friendships_on_deleted_at_is_null", where: "(deleted_at IS NULL)", using: :btree
  add_index "friendships", ["dreamer_id"], name: "index_friendships_on_dreamer_id", using: :btree
  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["processed"], name: "index_friendships_on_processed", using: :btree
  add_index "friendships", ["subscribing"], name: "index_friendships_on_subscribing", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "dreamer_id",                                                null: false
    t.integer  "payable_id"
    t.string   "description"
    t.string   "state",                                 default: "pending", null: false
    t.decimal  "amount",        precision: 8, scale: 2,                     null: false
    t.string   "currency",                              default: "RUB"
    t.string   "comment"
    t.integer  "payment_type",                          default: 0,         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "redirect_path"
    t.string   "payable_type"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.integer  "dreamer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "index_likes_on_likeable_id_and_likeable_type", using: :btree

  create_table "management_logs", force: :cascade do |t|
    t.integer  "logable_id"
    t.string   "logable_type"
    t.integer  "dreamer_id"
    t.string   "action"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "management_logs", ["dreamer_id"], name: "index_management_logs_on_dreamer_id", using: :btree
  add_index "management_logs", ["logable_type", "logable_id"], name: "index_management_logs_on_logable_type_and_logable_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "message"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",            default: false
    t.integer  "conversation_id"
    t.integer  "viewed_ids",                      array: true
  end

  create_table "moderator_logs", force: :cascade do |t|
    t.integer  "logable_id"
    t.string   "logable_type"
    t.integer  "dreamer_id"
    t.string   "action"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "moderator_logs", ["dreamer_id"], name: "index_moderator_logs_on_dreamer_id", using: :btree
  add_index "moderator_logs", ["logable_type", "logable_id"], name: "index_moderator_logs_on_logable_type_and_logable_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "dreamer_id",    null: false
    t.integer  "initiator_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "action"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "notifications", ["dreamer_id"], name: "index_notifications_on_dreamer_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "dreamer_id",     null: false
    t.integer  "application_id", null: false
    t.string   "token",          null: false
    t.integer  "expires_in",     null: false
    t.text     "redirect_uri",   null: false
    t.datetime "created_at",     null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "caption"
    t.integer  "dreamer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",    default: 0
    t.integer  "comments_count", default: 0
    t.datetime "deleted_at"
    t.string   "file"
    t.datetime "review_date"
    t.boolean  "ios_safe"
    t.boolean  "nsfw"
  end

  add_index "photos", ["created_at"], name: "index_photos_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "photos", ["deleted_at"], name: "index_photos_on_deleted_at", using: :btree
  add_index "photos", ["deleted_at"], name: "index_photos_on_deleted_at_is_null", where: "(deleted_at IS NULL)", using: :btree
  add_index "photos", ["dreamer_id"], name: "index_photos_on_dreamer_id", using: :btree

  create_table "post_photos", force: :cascade do |t|
    t.string   "photo"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "dreamer_id"
  end

  add_index "post_photos", ["dreamer_id"], name: "index_post_photos_on_dreamer_id", using: :btree
  add_index "post_photos", ["post_id"], name: "index_post_photos_on_post_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "dreamer_id",                              null: false
    t.string   "title"
    t.text     "body"
    t.integer  "likes_count",                 default: 0
    t.integer  "comments_count",              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restriction_level", limit: 2, default: 0
    t.integer  "suggested_from_id"
    t.string   "photo"
    t.datetime "review_date"
    t.boolean  "ios_safe"
    t.boolean  "nsfw"
    t.datetime "deleted_at"
    t.text     "content"
    t.integer  "parent_id"
  end

  add_index "posts", ["comments_count"], name: "index_posts_on_comments_count", order: {"comments_count"=>:desc}, using: :btree
  add_index "posts", ["created_at"], name: "index_posts_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "posts", ["dreamer_id"], name: "index_posts_on_dreamer_id", using: :btree
  add_index "posts", ["likes_count"], name: "index_posts_on_likes_count", order: {"likes_count"=>:desc}, using: :btree
  add_index "posts", ["parent_id"], name: "index_posts_on_parent_id", using: :btree
  add_index "posts", ["restriction_level"], name: "index_posts_on_restriction_level", using: :btree

  create_table "product_properties", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "product_properties", ["product_id"], name: "index_product_properties_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "cost"
    t.string   "product_type"
    t.string   "state"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "providers", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.string   "key"
    t.string   "uid"
    t.text     "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "providers", ["dreamer_id"], name: "index_providers_on_dreamer_id", using: :btree

  create_table "purchase_transactions", force: :cascade do |t|
    t.integer  "purchase_id"
    t.integer  "account_id"
    t.integer  "amount"
    t.string   "operation"
    t.string   "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "purchase_transactions", ["account_id"], name: "index_purchase_transactions_on_account_id", using: :btree
  add_index "purchase_transactions", ["purchase_id"], name: "index_purchase_transactions_on_purchase_id", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.integer  "destination_dreamer_id"
    t.integer  "destination_id"
    t.string   "destination_type"
    t.integer  "amount"
    t.string   "state"
    t.string   "comment"
    t.integer  "product_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "purchases", ["dreamer_id"], name: "index_purchases_on_dreamer_id", using: :btree
  add_index "purchases", ["product_id"], name: "index_purchases_on_product_id", using: :btree

  create_table "reactions", force: :cascade do |t|
    t.integer  "reactable_id",   null: false
    t.string   "reactable_type", null: false
    t.integer  "dreamer_id",     null: false
    t.string   "reaction",       null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "reactions", ["reactable_id", "reactable_type", "dreamer_id", "reaction"], name: "index_reactions_on_reactable_and_dreamer_and_reaction", unique: true, using: :btree
  add_index "reactions", ["reactable_type", "reactable_id"], name: "index_reactions_on_reactable_type_and_reactable_id", using: :btree

  create_table "sended_mails", force: :cascade do |t|
    t.integer  "email_id"
    t.integer  "dreamer_id"
    t.string   "external_id"
    t.string   "subject"
    t.text     "body"
    t.string   "format"
    t.string   "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "key",                     null: false
    t.string   "value",      default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.integer  "subscriber_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "subscriptions", ["dreamer_id", "subscriber_id"], name: "index_subscriptions_on_dreamer_id_and_subscriber_id", unique: true, using: :btree

  create_table "suggested_dreams", force: :cascade do |t|
    t.integer  "dream_id"
    t.integer  "receiver_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted",    default: false
    t.integer  "sender_id"
  end

  add_index "suggested_dreams", ["accepted"], name: "index_suggested_dreams_on_accepted", using: :btree
  add_index "suggested_dreams", ["created_at"], name: "index_suggested_dreams_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "suggested_dreams", ["dream_id"], name: "index_suggested_dreams_on_dream_id", using: :btree
  add_index "suggested_dreams", ["receiver_id"], name: "index_suggested_dreams_on_receiver_id", using: :btree

  create_table "suggested_posts", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "receiver_id",                 null: false
    t.boolean  "accepted",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_id"
  end

  create_table "tag_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "tag_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "tag_anc_desc_idx", unique: true, using: :btree
  add_index "tag_hierarchies", ["descendant_id"], name: "tag_desc_idx", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "tags", ["parent_id"], name: "index_tags_on_parent_id", using: :btree

  create_table "top_dreams", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "photo"
    t.string   "locale"
    t.integer  "likes_count",    default: 0
    t.integer  "comments_count", default: 0
    t.integer  "position",       default: 0
    t.datetime "review_date"
    t.boolean  "ios_safe"
    t.boolean  "nsfw"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "amount"
    t.string   "operation"
    t.string   "state"
    t.integer  "account_id"
    t.integer  "before"
    t.integer  "after"
    t.integer  "reason_id"
    t.string   "reason_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "transactions", ["account_id"], name: "index_transactions_on_account_id", using: :btree

  create_table "vip_statuses", force: :cascade do |t|
    t.integer  "dreamer_id"
    t.integer  "from_dreamer_id"
    t.datetime "paid_at"
    t.datetime "completed_at"
    t.integer  "duration"
    t.string   "comment"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "vip_statuses", ["dreamer_id"], name: "index_vip_statuses_on_dreamer_id", using: :btree
  add_index "vip_statuses", ["from_dreamer_id"], name: "index_vip_statuses_on_from_dreamer_id", using: :btree

  create_table "visits", force: :cascade do |t|
    t.integer  "visitor_id"
    t.integer  "visited_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "abuses", "complains"
  add_foreign_key "accounts", "dreamers"
  add_foreign_key "ad_banner_tags", "ad_banners"
  add_foreign_key "ad_banner_tags", "tags"
  add_foreign_key "ad_link_tags", "ad_links"
  add_foreign_key "ad_link_tags", "tags"
  add_foreign_key "ad_page_banners", "ad_pages"
  add_foreign_key "ad_page_banners", "banners"
  add_foreign_key "ad_pages", "banners"
  add_foreign_key "avatars", "dreamers"
  add_foreign_key "blocked_users", "dreamers"
  add_foreign_key "dream_cities", "dream_countries"
  add_foreign_key "dream_cities", "dream_districts"
  add_foreign_key "dream_cities", "dream_regions"
  add_foreign_key "dream_come_true_emails", "dreams"
  add_foreign_key "dream_districts", "dream_countries"
  add_foreign_key "dream_districts", "dream_regions"
  add_foreign_key "dream_hidden_tags", "dreams"
  add_foreign_key "dream_hidden_tags", "tags"
  add_foreign_key "dream_regions", "dream_countries"
  add_foreign_key "external_transactions", "accounts"
  add_foreign_key "notifications", "dreamers"
  add_foreign_key "oauth_access_grants", "dreamers"
  add_foreign_key "post_photos", "dreamers"
  add_foreign_key "post_photos", "posts"
  add_foreign_key "product_properties", "products"
  add_foreign_key "providers", "dreamers"
  add_foreign_key "purchase_transactions", "accounts"
  add_foreign_key "purchase_transactions", "purchases"
  add_foreign_key "reactions", "dreamers"
  add_foreign_key "transactions", "accounts"
end
