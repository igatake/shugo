class CreateDrinkGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :drink_genres do |t|
      t.string :genre_name

      t.timestamps
    end
  end
end
