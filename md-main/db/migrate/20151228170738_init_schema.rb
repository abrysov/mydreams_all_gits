class InitSchema < ActiveRecord::Migration
  def up
    
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    
    create_table "active_admin_comments", force: :cascade do |t|
      t.string   "namespace"
      t.text     "body"
      t.string   "resource_id",   null: false
      t.string   "resource_type", null: false
      t.integer  "author_id"
      t.string   "author_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
    
    create_table "activities", force: :cascade do |t|
      t.integer  "trackable_id"
      t.string   "trackable_type"
      t.integer  "owner_id"
      t.string   "owner_type"
      t.string   "key"
      t.integer  "recipient_id"
      t.string   "recipient_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "viewed",         default: false
    end
    
    add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
    
    create_table "admin_users", force: :cascade do |t|
      t.string   "email",                  default: "",    null: false
      t.string   "encrypted_password",     default: "",    null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,     null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.inet     "current_sign_in_ip"
      t.inet     "last_sign_in_ip"
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
      t.boolean  "manager",                default: false
    end
    
    add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
    
    create_table "attachments", force: :cascade do |t|
      t.integer  "attachmentable_id"
      t.string   "attachmentable_type"
      t.text     "file"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "backgrounds", force: :cascade do |t|
      t.text     "file",       null: false
      t.text     "key",        null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "banners", force: :cascade do |t|
      t.string   "title"
      t.text     "file",       null: false
      t.text     "url",        null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "certificate_types", force: :cascade do |t|
      t.string   "name",       null: false
      t.integer  "value",      null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "certificates", force: :cascade do |t|
      t.integer  "certificate_type_id",                 null: false
      t.integer  "certifiable_id",                      null: false
      t.string   "certifiable_type",                    null: false
      t.integer  "gifted_by_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "paid",                default: false
      t.boolean  "accepted",            default: false
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
    end
    
    add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
    add_index "comments", ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
    
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
    
    create_table "dreamer_profiles", force: :cascade do |t|
      t.string   "email"
      t.string   "first_name"
      t.string   "last_name"
      t.boolean  "gender_male",     default: true
      t.string   "dreamer_country"
      t.string   "dreamer_city"
      t.text     "additional"
      t.string   "provider"
      t.string   "uid"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "avatar"
    end
    
    create_table "dreamer_views", force: :cascade do |t|
      t.integer  "viewer_id",  null: false
      t.integer  "viewed_id",  null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "dreamer_views", ["viewer_id", "viewed_id"], name: "index_dreamer_views_on_viewer_id_and_viewed_id", unique: true, using: :btree
    
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
      t.boolean  "hide_dream_comments",     default: false
      t.boolean  "hide_diary_comments",     default: false
      t.boolean  "is_vip",                  default: false
      t.text     "avatar"
      t.integer  "visits_count",            default: 0
      t.integer  "current_status_id"
      t.integer  "dreamer_country_id"
      t.integer  "dreamer_city_id"
      t.datetime "last_reload_at"
      t.string   "provider"
      t.string   "uid"
      t.string   "oauth_token"
      t.datetime "oauth_expires_at"
      t.datetime "deleted_at"
      t.date     "birthday"
      t.string   "middle_name"
      t.string   "background"
      t.string   "authentication_token"
      t.boolean  "project_dreamer",         default: false
      t.boolean  "leader",                  default: false
      t.boolean  "celebrity"
      t.datetime "vip_ends"
      t.text     "page_bg"
      t.text     "dreambook_bg"
      t.datetime "photobar_added_at"
      t.text     "photobar_added_text"
      t.integer  "photobar_added_photo_id"
    end
    
    add_index "dreamers", ["birthday"], name: "index_dreamers_on_birthday", using: :btree
    add_index "dreamers", ["celebrity"], name: "index_dreamers_on_celebrity", using: :btree
    add_index "dreamers", ["created_at"], name: "index_dreamers_on_created_at", order: {"created_at"=>:desc}, using: :btree
    add_index "dreamers", ["deleted_at"], name: "index_dreamers_on_deleted_at", using: :btree
    add_index "dreamers", ["deleted_at"], name: "index_dreamers_on_deleted_at_is_null", where: "(deleted_at IS NULL)", using: :btree
    add_index "dreamers", ["dreamer_city_id"], name: "index_dreamers_on_dreamer_city_id", using: :btree
    add_index "dreamers", ["dreamer_country_id"], name: "index_dreamers_on_dreamer_country_id", using: :btree
    add_index "dreamers", ["email"], name: "index_dreamers_on_email", unique: true, using: :btree
    add_index "dreamers", ["gender_male"], name: "index_dreamers_on_gender_male", using: :btree
    add_index "dreamers", ["is_vip"], name: "index_dreamers_on_is_vip", using: :btree
    add_index "dreamers", ["last_reload_at"], name: "index_dreamers_on_last_reload_at", order: {"last_reload_at"=>:desc}, using: :btree
    add_index "dreamers", ["reset_password_token"], name: "index_dreamers_on_reset_password_token", unique: true, using: :btree
    add_index "dreamers", ["visits_count"], name: "index_dreamers_on_visits_count", order: {"visits_count"=>:desc}, using: :btree
    
    create_table "dreams", force: :cascade do |t|
      t.string   "title",                                       null: false
      t.boolean  "came_true",                   default: false
      t.integer  "dreamer_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "likes_count",                 default: 0
      t.integer  "comments_count",              default: 0
      t.integer  "taken_from_id"
      t.text     "description"
      t.text     "photo"
      t.datetime "deleted_at"
      t.integer  "restriction_level", limit: 2, default: 0
      t.string   "state"
      t.string   "gift_comment"
      t.text     "video"
      t.integer  "position",                    default: 0
      t.string   "type"
      t.integer  "suggested_from_id"
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
    
    create_table "exchange_rates", force: :cascade do |t|
      t.string   "currency1",  null: false
      t.string   "currency2",  null: false
      t.float    "rate",       null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "feedback_requests", force: :cascade do |t|
      t.integer  "dreamer_id"
      t.text     "text"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "friendships", force: :cascade do |t|
      t.integer  "dreamer_id"
      t.integer  "friend_id",                     null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "deleted_at"
      t.datetime "accepted_at"
      t.boolean  "subscribing"
      t.boolean  "processed"
      t.boolean  "friend_viewed", default: false
    end
    
    add_index "friendships", ["accepted_at"], name: "index_friendships_on_accepted_at", order: {"accepted_at"=>:desc}, using: :btree
    add_index "friendships", ["deleted_at"], name: "index_friendships_on_deleted_at", using: :btree
    add_index "friendships", ["deleted_at"], name: "index_friendships_on_deleted_at_is_null", where: "(deleted_at IS NULL)", using: :btree
    add_index "friendships", ["dreamer_id"], name: "index_friendships_on_dreamer_id", using: :btree
    add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
    add_index "friendships", ["processed"], name: "index_friendships_on_processed", using: :btree
    add_index "friendships", ["subscribing"], name: "index_friendships_on_subscribing", using: :btree
    
    create_table "gifts", force: :cascade do |t|
      t.integer  "giver_id",   null: false
      t.integer  "gived_id",   null: false
      t.integer  "dream_id",   null: false
      t.string   "token",      null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "giver_name"
    end
    
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
    
    create_table "messages", force: :cascade do |t|
      t.text     "message"
      t.integer  "sender_id"
      t.integer  "receiver_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "read",        default: false
    end
    
    create_table "pg_search_documents", force: :cascade do |t|
      t.text     "content"
      t.integer  "searchable_id"
      t.string   "searchable_type"
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
    end
    
    add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
    
    create_table "photos", force: :cascade do |t|
      t.text     "file"
      t.string   "caption"
      t.integer  "dreamer_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "likes_count",    default: 0
      t.integer  "comments_count", default: 0
      t.datetime "deleted_at"
    end
    
    add_index "photos", ["created_at"], name: "index_photos_on_created_at", order: {"created_at"=>:desc}, using: :btree
    add_index "photos", ["deleted_at"], name: "index_photos_on_deleted_at", using: :btree
    add_index "photos", ["deleted_at"], name: "index_photos_on_deleted_at_is_null", where: "(deleted_at IS NULL)", using: :btree
    add_index "photos", ["dreamer_id"], name: "index_photos_on_dreamer_id", using: :btree
    
    create_table "posts", force: :cascade do |t|
      t.integer  "dreamer_id",                              null: false
      t.string   "title"
      t.text     "body"
      t.integer  "likes_count",                 default: 0
      t.integer  "comments_count",              default: 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "restriction_level", limit: 2, default: 0
      t.string   "photo"
      t.integer  "suggested_from_id"
    end
    
    add_index "posts", ["comments_count"], name: "index_posts_on_comments_count", order: {"comments_count"=>:desc}, using: :btree
    add_index "posts", ["created_at"], name: "index_posts_on_created_at", order: {"created_at"=>:desc}, using: :btree
    add_index "posts", ["dreamer_id"], name: "index_posts_on_dreamer_id", using: :btree
    add_index "posts", ["likes_count"], name: "index_posts_on_likes_count", order: {"likes_count"=>:desc}, using: :btree
    add_index "posts", ["restriction_level"], name: "index_posts_on_restriction_level", using: :btree
    
    create_table "settings", force: :cascade do |t|
      t.string   "key",                     null: false
      t.string   "value",      default: "", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "static_pages", force: :cascade do |t|
      t.string   "title_ru"
      t.string   "slug",       null: false
      t.text     "body_ru"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "title_en"
      t.text     "body_en"
    end
    
    create_table "statuses", force: :cascade do |t|
      t.integer  "dreamer_id"
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "likes_count",    default: 0
      t.integer  "comments_count", default: 0
      t.datetime "deleted_at"
    end
    
    add_index "statuses", ["deleted_at"], name: "index_statuses_on_deleted_at", using: :btree
    
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
    
    create_table "visits", force: :cascade do |t|
      t.integer  "visitor_id"
      t.integer  "visited_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end

  def down
    raise "Can not revert initial migration"
  end
end
