class AddIndexDrinksDrinkName < ActiveRecord::Migration[6.0]
  def change
    add_index :drinks, :drink_name
  end
end
