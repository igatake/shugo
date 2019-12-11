class Shop < ApplicationRecord
  has_many :drinks, dependent: :destroy
  has_many :shop_drinks, dependent: :destroy
  has_many :drink_genres, through: :shop_drinks

  validates :shop_name, presence: true
  validates :shop_address, presence: true

  def self.greet
    shop = Shop.first
    puts shop.shop_name
  end

  def self.get_distance(lat_now, lon_now)
    shops = Shop.all
    distances = {}
    shops.each do |shop|
      # ラジアン単位に変換
      x1 = lat_now.to_f * Math::PI / 180
      y1 = lon_now.to_f * Math::PI / 180
      x2 = shop.shop_lat.to_f * Math::PI / 180
      y2 = shop.shop_lon.to_f * Math::PI / 180

      # 地球の半径 (km)
      radius = 6378.137

      # 差の絶対値
      diff_y = (y1 - y2).abs

      calc1 = Math.cos(x2) * Math.sin(diff_y)
      calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)

      # 分子
      numerator = Math.sqrt(calc1 ** 2 + calc2 ** 2)

      # 分母
      denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)

      # 弧度
      degree = Math.atan2(numerator, denominator)

      # 大円距離 (km)
      distance = degree * radius

      distances[distance] = shop.shop_url
    end
    near_distances = distances.sort
    puts near_distances
  end
end
