class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :shop_name, null: false
      t.string :shop_address, null: false
      t.string :shop_url, null: false
      t.float :shop_lat
      t.float :shop_lon
      t.date :crawled_at

      t.timestamps
    end
  end
end
