class AddParentIdToDrinkGenres < ActiveRecord::Migration[6.0]
  def change
    add_column :drink_genres, :parent_id, :integer
  end
end
