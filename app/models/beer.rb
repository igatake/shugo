class Beer < ApplicationRecord
  validates :beer_name, presence: true
  validates :beer_price, presence: true
  validates :beer_genre, presence: true
  validates :shop_name, presence: true
  validates :shop_address, presence: true
  validates :shop_url, presence: true
end
