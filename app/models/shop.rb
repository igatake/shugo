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

  def self.get_shops(lat_now, lng_now, show_num, genre_id = 2)
    shops = Shop.get_distance(lat_now, lng_now, show_num, genre_id)
    shops.as_json
    new_shops = []
    shops.each do |shop|
      drinks = {}
      shop.drinks.each do |drink|
        if genre_id == 2
          drinks[drink.drink_name] = drink.drink_price if drink.drink_genre.parent_id == 2 || drink.drink_genre.id == 2
        else
          drinks[drink.drink_name] = drink.drink_price if drink.drink_genre.id == genre_id
        end
      end
      shop_json = shop.as_json
      # puts shop_json
      shop_json['drink'] = drinks
      new_shops.push(shop_json)
    end
    shops_json = new_shops.as_json
  end

  def self.get_distance(lat_now, lng_now, show_num, genre_id)
    if genre_id == 2
      query = <<-SQL
      SELECT DISTINCT
        id, shop_name, shop_address, shop_url, shop_lat, shop_lng,
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
        (SELECT `shops`.*
          FROM `shops`
          INNER JOIN `shop_drinks`
          ON `shops`.`id` = `shop_drinks`.`shop_id`
          WHERE `shop_drinks`.`drink_genre_id` = 2 OR
                              `drink_genre_id` = 3 OR
                              `drink_genre_id` = 4 OR
                              `drink_genre_id` = 5 OR
                              `drink_genre_id` = 6 OR
                              `drink_genre_id` = 7 OR
                              `drink_genre_id` = 8
          ) AS drink_genre
      ORDER BY
        distance
      LIMIT :show_num
      ;
      SQL
      find_by_sql([query, { lat_now: lat_now, lng_now: lng_now, show_num: show_num }])
    else
      query = <<-SQL
      SELECT
        *,
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
        (SELECT `shops`.*
          FROM `shops`
          INNER JOIN `shop_drinks`
          ON `shops`.`id` = `shop_drinks`.`shop_id`
          WHERE `shop_drinks`.`drink_genre_id` = :genre_id
          ) AS drink_genre
      ORDER BY
        distance
      LIMIT :show_num
      ;
      SQL
      find_by_sql([query, { genre_id: genre_id, lat_now: lat_now, lng_now: lng_now, show_num: show_num }])
    end
  end
end