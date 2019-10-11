class CreateBeers < ActiveRecord::Migration[6.0]
  def change
    create_table :beers do |t|
      t.string :beer_name, null:false
      t.integer :beer_price, null:false
      t.integer :beer_genre, null:false
      t.string :shop_name, null:false
      t.string :shop_address, null:false
      t.string :shop_url, null:false

      t.timestamps
    end
  end
end
