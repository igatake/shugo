class Shop < ApplicationRecord
  has_many :drinks, dependent: :destroy
  has_many :shop_drinks, dependent: :destroy
  has_many :drink_genres, through: :shop_drinks

  validates :shop_name, presence: true
  validates :shop_address, presence: true

  # after_validation :geocode

  # private
  # def geocode
  #   uri = URI.escape("https://maps.googleapis.com/maps/api/geocode/json?address="+self.shop_address.gsub(" ", "")+"&key=#{ENV['API_KEY']}")
  #   res = HTTP.get(uri).to_s
  #   response = JSON.parse(res)
  #   self.shop_lat = response["results"][0]["geometry"]["location"]["lat"]
  #   self.shop_lon = response["results"][0]["geometry"]["location"]["lng"]
  # end
end
