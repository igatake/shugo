# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_10_175526) do

  create_table "drink_genres", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "genre_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
  end

  create_table "drinks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "drink_name", null: false
    t.integer "drink_price", null: false
    t.integer "drink_genre_id"
    t.integer "shop_id", null: false
    t.date "crawled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drink_name"], name: "index_drinks_on_drink_name"
  end

  create_table "shop_drinks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "drink_genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drink_genre_id"], name: "index_shop_drinks_on_drink_genre_id"
    t.index ["shop_id"], name: "index_shop_drinks_on_shop_id"
  end

  create_table "shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "shop_name", null: false
    t.string "shop_address", null: false
    t.string "shop_url", null: false
    t.decimal "shop_lat", precision: 10, scale: 7
    t.decimal "shop_lng", precision: 10, scale: 7
    t.date "crawled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "shop_drinks", "drink_genres"
  add_foreign_key "shop_drinks", "shops"
end
