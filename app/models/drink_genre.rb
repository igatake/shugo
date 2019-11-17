class DrinkGenre < ApplicationRecord
  has_many :drinks
  has_many :shop_drinks
  has_many :shops, through: :shop_drinks

end
