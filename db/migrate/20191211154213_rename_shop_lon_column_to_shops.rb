class RenameShopLonColumnToShops < ActiveRecord::Migration[6.0]
  def change
    rename_column :shops, :shop_lon, :shop_lng
  end
end
