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

ActiveRecord::Schema.define(version: 20170609020931) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "address_type"
    t.string   "contact_name"
    t.string   "cellphone"
    t.string   "address"
    t.string   "zipcode"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.index ["user_id", "address_type"], name: "index_addresses_on_user_id_and_address_type"
  end

  create_table "buyers", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.decimal  "price",      precision: 10, scale: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["user_id"], name: "index_buyers_on_user_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "subproduct_id"
    t.integer  "quantity",      default: 1
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "is_selected",   default: true
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.string   "title"
    t.integer  "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "weight"
  end

  create_table "evaluation_photos", force: :cascade do |t|
    t.integer  "evaluation_id"
    t.string   "evaluation_image"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["evaluation_id"], name: "index_evaluation_photos_on_evaluation_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "grade",       default: 5
    t.text     "description"
    t.string   "subtitle"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "explain"
    t.index ["grade"], name: "index_evaluations_on_grade"
    t.index ["product_id"], name: "index_evaluations_on_product_id"
    t.index ["user_id"], name: "index_evaluations_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "main_image"
    t.string   "minor_image"
    t.text     "intro"
    t.text     "description"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "category_id"
    t.decimal  "price",       precision: 10, scale: 2
    t.integer  "weight"
    t.string   "effect"
    t.integer  "sales_count",                          default: 0
  end

  create_table "orders", force: :cascade do |t|
    t.decimal  "total",           precision: 10, scale: 2
    t.integer  "user_id"
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.string   "token"
    t.boolean  "is_paid",                                  default: false
    t.string   "payment_method"
    t.string   "aasm_state",                               default: "order_placed"
    t.integer  "payment_id"
    t.decimal  "carriage",        precision: 10, scale: 2, default: "0.0"
    t.boolean  "of_lesson",                                default: false
    t.integer  "lesson_id"
    t.datetime "payment_at"
    t.string   "carriage_no"
    t.string   "carriage_method"
    t.index ["aasm_state"], name: "index_orders_on_aasm_state"
    t.index ["of_lesson"], name: "index_orders_on_of_lesson"
    t.index ["payment_id"], name: "index_orders_on_payment_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "payment_no"
    t.string   "transaction_no"
    t.string   "status",                                  default: "initial"
    t.decimal  "total_money",    precision: 10, scale: 2
    t.datetime "payment_at"
    t.text     "raw_response"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.index ["payment_no"], name: "index_payments_on_payment_no", unique: true
    t.index ["transaction_no"], name: "index_payments_on_transaction_no"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "post_evas", force: :cascade do |t|
    t.text     "content"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "eva_image"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "chapter_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "weight"
    t.integer  "lesson_id"
    t.integer  "so_easy",     default: 0
    t.integer  "okay",        default: 0
  end

  create_table "product_lists", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "product_name"
    t.decimal  "product_price", precision: 10, scale: 2
    t.integer  "quantity",                               default: 1
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "address"
    t.string   "cellphone"
    t.string   "contact_name"
    t.string   "subproduct"
    t.string   "lists_image"
    t.integer  "product_id"
  end

  create_table "product_params", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "weight"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_params_on_product_id"
  end

  create_table "product_photos", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "weight",        default: 0
    t.string   "product_image"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["product_id"], name: "index_product_photos_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "quantity"
    t.decimal  "price",            precision: 10, scale: 2
    t.integer  "evaluation_count",                          default: 0
    t.integer  "sales_count",                               default: 0
    t.integer  "category_id"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "slogan"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["title"], name: "index_products_on_title"
  end

  create_table "slider_photos", force: :cascade do |t|
    t.string   "slider_image"
    t.integer  "weight"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "is_hidden",    default: false
    t.string   "link"
  end

  create_table "subproducts", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "subtitle"
    t.decimal  "msrp",             precision: 10, scale: 2
    t.decimal  "price",            precision: 10, scale: 2
    t.string   "activity"
    t.integer  "carriage",                                  default: 0
    t.string   "place"
    t.integer  "quantity"
    t.string   "subproduct_image"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "weight",                                    default: 0
    t.index ["product_id"], name: "index_subproducts_on_product_id"
    t.index ["subtitle"], name: "index_subproducts_on_subtitle"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "cellphone"
    t.boolean  "is_admin",                        default: false
    t.integer  "default_address_id"
    t.string   "username"
    t.boolean  "is_overseas",                     default: false
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["cellphone"], name: "index_users_on_cellphone"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  create_table "verify_tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "cellphone"
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cellphone", "token"], name: "index_verify_tokens_on_cellphone_and_token"
  end

end
