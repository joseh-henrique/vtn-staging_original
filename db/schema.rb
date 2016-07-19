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

ActiveRecord::Schema.define(version: 20160706181151) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.text     "body"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "namespace",     limit: 255
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "address",    limit: 255
    t.string   "address2",   limit: 255
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.string   "country",    limit: 255
    t.string   "zip",        limit: 255
    t.string   "phone1",     limit: 255
    t.string   "phone2",     limit: 255
    t.string   "phone3",     limit: 255
    t.string   "fax",        limit: 255
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "appraisal_activities", force: :cascade do |t|
    t.integer  "appraisal_id"
    t.integer  "user_id"
    t.integer  "activity_type"
    t.integer  "activity_value"
    t.datetime "activity_datetime"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "appraisal_activities", ["user_id"], name: "index_appraisal_activities_on_user_id", using: :btree

  create_table "appraisal_data", force: :cascade do |t|
    t.integer  "appraisal_id"
    t.integer  "datatype"
    t.string   "value",        limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "appraisal_data", ["appraisal_id"], name: "index_appraisal_data_on_appraisal_id", using: :btree

  create_table "appraisals", force: :cascade do |t|
    t.text     "name"
    t.string   "dimensions",                limit: 255
    t.string   "materials",                 limit: 255
    t.string   "country_of_origin",         limit: 255
    t.string   "makers_marks",              limit: 255
    t.string   "damage",                    limit: 255
    t.string   "year_of_manufacture",       limit: 255
    t.string   "where_was_it_obtained",     limit: 255
    t.string   "how_was_it_obtained",       limit: 255
    t.string   "appraiser_number",          limit: 255
    t.string   "value_of_item",             limit: 255
    t.string   "historical_significance",   limit: 255
    t.string   "number_of_pieces_created",  limit: 255
    t.string   "where_it_was_manufactured", limit: 255
    t.string   "when_it_was_used",          limit: 255
    t.string   "how_it_was_used",           limit: 255
    t.integer  "selected_plan"
    t.integer  "status"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "created_by"
    t.integer  "assigned_to"
    t.integer  "assigned_on"
    t.text     "inscriptions"
    t.text     "item_history"
    t.text     "appraisal_info"
    t.integer  "appraisal_type"
    t.boolean  "shared",                                default: false
    t.string   "title",                     limit: 255
    t.boolean  "allow_share",                           default: true
    t.string   "step",                      limit: 255
    t.string   "appraiser_referral",        limit: 255
    t.text     "rejection_reason"
    t.boolean  "insurance_claim",                       default: false
    t.boolean  "insurance_prior",                       default: false
    t.text     "insurance_location"
    t.integer  "invoice_id"
    t.boolean  "is_downloaded",                         default: false
    t.boolean  "is_paid_by_partner",                    default: false
    t.boolean  "sent_24h",                              default: false
    t.boolean  "sent_48h",                              default: false
    t.boolean  "sent_72h",                              default: false
    t.boolean  "sent_1w",                               default: false
    t.boolean  "sent_2w",                               default: false
    t.boolean  "sent_30d",                              default: false
  end

  add_index "appraisals", ["assigned_to"], name: "index_appraisals_on_assigned_to", using: :btree
  add_index "appraisals", ["created_by"], name: "index_appraisals_on_created_by", using: :btree

  create_table "appraiser_access_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",      limit: 255
    t.string   "email",      limit: 255
    t.string   "name",       limit: 255
    t.datetime "used_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "appraiser_access_tokens", ["user_id"], name: "index_appraiser_access_tokens_on_user_id", using: :btree

  create_table "appraiser_extras", force: :cascade do |t|
    t.text     "years_appraising"
    t.text     "affiliated_with"
    t.text     "certifications"
    t.text     "description"
    t.string   "bank_name",           limit: 255
    t.string   "bank_routing_number", limit: 255
    t.integer  "uspap"
    t.text     "signature_json"
    t.integer  "appraiser_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "tax_name",            limit: 255
    t.string   "tax_address",         limit: 255
    t.string   "tax_id",              limit: 255
    t.string   "tax_ein",             limit: 255
    t.float    "tax_wages"
    t.string   "tax_address_2",       limit: 255
  end

  add_index "appraiser_extras", ["appraiser_id"], name: "index_appraiser_extras_on_appraiser_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "ancestry",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

  create_table "classifications", force: :cascade do |t|
    t.integer  "appraisal_id"
    t.integer  "category_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "classifications", ["appraisal_id"], name: "index_classifications_on_appraisal_id", using: :btree
  add_index "classifications", ["category_id"], name: "index_classifications_on_category_id", using: :btree

  create_table "comfy_cms_blocks", force: :cascade do |t|
    t.integer  "blockable_id",               null: false
    t.string   "identifier",     limit: 255, null: false
    t.text     "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "blockable_type", limit: 255
  end

  add_index "comfy_cms_blocks", ["blockable_id", "identifier"], name: "index_comfy_cms_blocks_on_blockable_id_and_identifier", using: :btree
  add_index "comfy_cms_blocks", ["blockable_type"], name: "index_comfy_cms_blocks_on_blockable_type", using: :btree

  create_table "comfy_cms_categories", force: :cascade do |t|
    t.integer "site_id",                      null: false
    t.string  "label",            limit: 255, null: false
    t.string  "categorized_type", limit: 255, null: false
  end

  add_index "comfy_cms_categories", ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true, using: :btree

  create_table "comfy_cms_categorizations", force: :cascade do |t|
    t.integer "category_id",                  null: false
    t.string  "categorized_type", limit: 255, null: false
    t.integer "categorized_id",               null: false
  end

  add_index "comfy_cms_categorizations", ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true, using: :btree

  create_table "comfy_cms_files", force: :cascade do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "block_id"
    t.string   "label",             limit: 255,              null: false
    t.string   "file_file_name",    limit: 255,              null: false
    t.string   "file_content_type", limit: 255,              null: false
    t.integer  "file_file_size",                             null: false
    t.string   "description",       limit: 2048
    t.integer  "position",                       default: 0, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "comfy_cms_files", ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id", using: :btree
  add_index "comfy_cms_files", ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name", using: :btree
  add_index "comfy_cms_files", ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label", using: :btree
  add_index "comfy_cms_files", ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position", using: :btree

  create_table "comfy_cms_layouts", force: :cascade do |t|
    t.integer  "site_id",                                null: false
    t.integer  "parent_id"
    t.string   "app_layout", limit: 255
    t.string   "label",      limit: 255,                 null: false
    t.string   "identifier", limit: 255,                 null: false
    t.text     "content"
    t.text     "css"
    t.text     "js"
    t.integer  "position",               default: 0,     null: false
    t.boolean  "is_shared",              default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "comfy_cms_layouts", ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_layouts", ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true, using: :btree

  create_table "comfy_cms_pages", force: :cascade do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label",          limit: 255,                 null: false
    t.string   "slug",           limit: 255
    t.string   "full_path",      limit: 255,                 null: false
    t.text     "content_cache"
    t.integer  "position",                   default: 0,     null: false
    t.integer  "children_count",             default: 0,     null: false
    t.boolean  "is_published",               default: true,  null: false
    t.boolean  "is_shared",                  default: false, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "comfy_cms_pages", ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_pages", ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path", using: :btree

  create_table "comfy_cms_revisions", force: :cascade do |t|
    t.string   "record_type", limit: 255, null: false
    t.integer  "record_id",               null: false
    t.text     "data"
    t.datetime "created_at"
  end

  add_index "comfy_cms_revisions", ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_record_type_id_and_created", using: :btree

  create_table "comfy_cms_sites", force: :cascade do |t|
    t.string  "label",       limit: 255,                 null: false
    t.string  "identifier",  limit: 255,                 null: false
    t.string  "hostname",    limit: 255,                 null: false
    t.string  "path",        limit: 255
    t.string  "locale",      limit: 255, default: "en",  null: false
    t.boolean "is_mirrored",             default: false, null: false
  end

  add_index "comfy_cms_sites", ["hostname"], name: "index_comfy_cms_sites_on_hostname", using: :btree
  add_index "comfy_cms_sites", ["is_mirrored"], name: "index_comfy_cms_sites_on_is_mirrored", using: :btree

  create_table "comfy_cms_snippets", force: :cascade do |t|
    t.integer  "site_id",                                null: false
    t.string   "label",      limit: 255,                 null: false
    t.string   "identifier", limit: 255,                 null: false
    t.text     "content"
    t.integer  "position",               default: 0,     null: false
    t.boolean  "is_shared",              default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "comfy_cms_snippets", ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true, using: :btree
  add_index "comfy_cms_snippets", ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",               default: 0
    t.string   "commentable_type", limit: 255, default: ""
    t.string   "title",            limit: 255, default: ""
    t.text     "body",                         default: ""
    t.string   "subject",          limit: 255, default: ""
    t.integer  "user_id",                      default: 0,  null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "compensations", force: :cascade do |t|
    t.float    "amount"
    t.integer  "appraisal_plan"
    t.integer  "min_range"
    t.integer  "max_range"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "is_over",        default: false
  end

  create_table "coupon_usages", force: :cascade do |t|
    t.integer  "coupon_id"
    t.integer  "appraisal_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "coupon_usages", ["appraisal_id"], name: "index_coupon_usages_on_appraisal_id", using: :btree
  add_index "coupon_usages", ["coupon_id"], name: "index_coupon_usages_on_coupon_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "code",             limit: 255
    t.float    "discount"
    t.string   "discount_type",    limit: 255
    t.boolean  "active",                       default: true
    t.datetime "expiration_date"
    t.datetime "used_on"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.integer  "promotion_id"
    t.boolean  "featured",                     default: false
    t.integer  "max_usage",                    default: 1
    t.integer  "usage_count",                  default: 0
    t.datetime "start_date",                   default: '2013-05-22 15:29:06'
    t.string   "description",      limit: 255
    t.float    "max_discount"
    t.text     "allowed_products"
    t.string   "pap_id",           limit: 255
  end

  create_table "customer_extras", force: :cascade do |t|
    t.string   "placeholder", limit: 255
    t.integer  "customer_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "customer_extras", ["customer_id"], name: "index_customer_extras_on_customer_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "partner_informations", force: :cascade do |t|
    t.string   "company_name",     limit: 255
    t.string   "client_name",      limit: 255
    t.string   "address",          limit: 255
    t.string   "city_state_potal", limit: 255
    t.string   "claim_number",     limit: 255
    t.string   "token",            limit: 255
    t.integer  "appraisal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partner_informations", ["appraisal_id"], name: "index_partner_informations_on_appraisal_id", using: :btree

  create_table "partner_pricings", force: :cascade do |t|
    t.boolean  "xw_flag"
    t.decimal  "short_restricted",    precision: 10, scale: 2, default: 0.0
    t.decimal  "full_restricted",     precision: 10, scale: 2, default: 0.0
    t.decimal  "full_use",            precision: 10, scale: 2, default: 0.0
    t.decimal  "short_restricted_xw", precision: 10, scale: 2, default: 0.0
    t.decimal  "full_restricted_xw",  precision: 10, scale: 2, default: 0.0
    t.decimal  "full_use_xw",         precision: 10, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "partner_pricings", ["user_id"], name: "index_partner_pricings_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "appraisal_id"
    t.boolean  "is_charged"
    t.string   "auth_code",    limit: 255
    t.string   "ccnum",        limit: 255
    t.float    "amount"
    t.boolean  "is_refund"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "payments", ["appraisal_id"], name: "index_payments_on_appraisal_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "payouts", force: :cascade do |t|
    t.integer  "appraisal_id",             null: false
    t.integer  "appraiser_id",             null: false
    t.float    "amount",                   null: false
    t.integer  "status",       default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "payouts", ["appraisal_id"], name: "index_payouts_on_appraisal_id", using: :btree
  add_index "payouts", ["appraiser_id"], name: "index_payouts_on_appraiser_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "appraisal_id"
    t.integer  "user_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "asset_file_name",    limit: 255
    t.string   "asset_content_type", limit: 255
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.boolean  "default",                        default: false
    t.string   "picture",            limit: 255
    t.string   "name",               limit: 255
    t.string   "asset",              limit: 255
  end

  add_index "photos", ["appraisal_id"], name: "index_photos_on_appraisal_id", using: :btree
  add_index "photos", ["user_id"], name: "index_photos_on_user_id", using: :btree

  create_table "phototags", force: :cascade do |t|
    t.integer  "photo_id"
    t.string   "label",      limit: 255
    t.integer  "width"
    t.integer  "height"
    t.integer  "top"
    t.integer  "left"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id"
  end

  add_index "phototags", ["photo_id"], name: "index_tags_on_photo_id", using: :btree
  add_index "phototags", ["user_id"], name: "index_tags_on_user_id", using: :btree

  create_table "promotions", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.boolean  "active",                  default: true
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id"
    t.string   "resource_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title",         limit: 255
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "key",         limit: 255
    t.string   "value",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "description"
  end

  create_table "sharecounts", force: :cascade do |t|
    t.integer  "appraisal_id"
    t.integer  "user_id"
    t.string   "network",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sharecounts", ["appraisal_id"], name: "index_sharecounts_on_appraisal_id", using: :btree
  add_index "sharecounts", ["user_id"], name: "index_sharecounts_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "discipline",   limit: 255
    t.integer  "since"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "category_id"
    t.integer  "appraiser_id"
  end

  add_index "skills", ["appraiser_id"], name: "index_skills_on_appraiser_id", using: :btree
  add_index "skills", ["category_id"], name: "index_skills_on_category_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "appraisal_id"
    t.integer  "task_mapper_id"
    t.string   "task_mapper_provider", limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "tickets", ["appraisal_id"], name: "index_tickets_on_appraisal_id", using: :btree
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

  create_table "trade_references", force: :cascade do |t|
    t.string   "company",      limit: 255
    t.string   "contact",      limit: 255
    t.string   "phone",        limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "appraiser_id"
  end

  add_index "trade_references", ["appraiser_id"], name: "index_trade_references_on_appraiser_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                 limit: 255,                          default: "",                    null: false
    t.string   "encrypted_password",                    limit: 255,                          default: "",                    null: false
    t.string   "reset_password_token",                  limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                              default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                    limit: 255
    t.string   "last_sign_in_ip",                       limit: 255
    t.datetime "created_at",                                                                                                 null: false
    t.datetime "updated_at",                                                                                                 null: false
    t.string   "role",                                  limit: 255
    t.boolean  "notify_by_sms",                                                              default: false
    t.boolean  "notify_by_email",                                                            default: true
    t.integer  "next_notification_interval_in_minutes",                                      default: 60
    t.datetime "next_notification_due_at",                                                   default: '2012-08-20 00:17:41'
    t.string   "payment_method",                        limit: 255,                          default: "cheque"
    t.boolean  "uspap",                                                                      default: false
    t.string   "name",                                  limit: 255
    t.string   "facebook_token",                        limit: 255
    t.string   "facebook_location",                     limit: 255
    t.string   "facebook_location_id",                  limit: 255
    t.string   "facebook_gender",                       limit: 255
    t.string   "facebook_verified",                     limit: 255
    t.string   "facebook_updated",                      limit: 255
    t.string   "facebook_locale",                       limit: 255
    t.string   "facebook_id",                           limit: 255
    t.text     "appraiser_info"
    t.string   "username",                              limit: 255
    t.text     "signature_json"
    t.integer  "status"
    t.string   "confirmation_token",                    limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "avatar",                                limit: 255
    t.string   "type",                                  limit: 255
    t.string   "website",                               limit: 255
    t.string   "paypal_email",                          limit: 255
    t.string   "last_step",                             limit: 255
    t.string   "signature",                             limit: 255
    t.string   "referral_id",                           limit: 255
    t.string   "vendor_token",                          limit: 255
    t.boolean  "is_partner",                                                                 default: false
    t.string   "client_id",                             limit: 255
    t.string   "secondary_contact_name",                limit: 255
    t.string   "secondary_contact_email",               limit: 255
    t.decimal  "negotiated_cost",                                   precision: 10, scale: 2, default: 0.0
    t.string   "payment_term",                          limit: 255
    t.boolean  "is_deny_email",                                                              default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_id"], name: "index_users_on_facebook_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

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

end
