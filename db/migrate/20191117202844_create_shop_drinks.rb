class CreateShopDrinks < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_drinks do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :drink_genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
