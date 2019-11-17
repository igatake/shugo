class Drink < ApplicationRecord
  belongs_to :shop
  belongs_to :drink_genre, optional: true
  validates :drink_name, presence: true
  validates :drink_price, presence: true
end
