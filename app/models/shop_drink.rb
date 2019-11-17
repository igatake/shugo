class ShopDrink < ApplicationRecord
  belongs_to :shop
  belongs_to :drink_genre
end
