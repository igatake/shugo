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

  def self.get_distance(lat_now, lng_now, show_num, genre_id = nil)
    unless genre_id == nil
      query = <<-SQL
      SELECT
        id, shop_name, shop_url,
        (
          6371 * acos(
            cos(radians(:lat_now))
            * cos(radians(shop_lat))
            * cos(radians(shop_lng) - radians(:lng_now))
            + sin(radians(:lat_now))
            * sin(radians(shop_lat))
          )
        ) AS distance
      FROM
        (SELECT `shops`.* FROM `shops` INNER JOIN `shop_drinks` ON `shops`.`id` = `shop_drinks`.`shop_id` WHERE `shop_drinks`.`drink_genre_id` = :genre_id) AS drink_genre
      ORDER BY
        distance
      LIMIT :show_num
      ;
      SQL
      find_by_sql([query, { genre_id: genre_id, lat_now: lat_now, lng_now: lng_now, show_num: show_num }])
    else
      query = <<-SQL
      SELECT
        id, shop_name, shop_url,
        (
          6371 * acos(
            cos(radians(:lat_now))
            * cos(radians(shop_lat))
            * cos(radians(shop_lng) - radians(:lng_now))
            + sin(radians(:lat_now))
            * sin(radians(shop_lat))
          )
        ) AS distance
      FROM
          shops
      ORDER BY
        distance
      LIMIT :show_num
      ;
      SQL
      find_by_sql([query, {lat_now: lat_now, lng_now: lng_now, show_num: show_num }])
    end
  end
end