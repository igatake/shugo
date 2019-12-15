class DrinkGenre < ApplicationRecord
  has_many :drinks
  has_many :shop_drinks
  has_many :shops, through: :shop_drinks
  belongs_to :parent, class_name: :DrinkGenre
  has_many :children, class_name: :DrinkGenre, foreign_key: :parent_id

end
