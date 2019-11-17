class CreateDrinks < ActiveRecord::Migration[6.0]
  def change
    create_table :drinks do |t|
      t.string :drink_name, null: false
      t.integer :drink_price, null: false
      t.integer :drink_genre_id
      t.integer :shop_id, null: false
      t.date :crawled_at

      t.timestamps
    end
  end
end
