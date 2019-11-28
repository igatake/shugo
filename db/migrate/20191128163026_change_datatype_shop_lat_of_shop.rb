class ChangeDatatypeShopLatOfShop < ActiveRecord::Migration[6.0]
  def change
    change_column :shops, :shop_lat, :decimal, :precision => 10, :scale => 7
    change_column :shops, :shop_lon, :decimal, :precision => 10, :scale => 7
  end
end
