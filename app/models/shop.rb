class Shop < ApplicationRecord
  has_many :drinks, dependent: :destroy
  has_many :shop_drinks, dependent: :destroy
  has_many :drink_genres, through: :shop_drinks

  validates :shop_name, presence: true
  validates :shop_address, presence: true

  def self.beer_shops(lat_now, lng_now, genre_array, show_num)
    shops = Shop.beer_distance(lat_now, lng_now, genre_array, show_num)
    shops.as_json
    new_shops = []
    shops.each do |shop|
      drinks = []
      shop_drinks = []
      if genre_array.include?(2)
        shop_drinks = shop.drinks.where.not(drink_genre_id: 1)
      else
        genre_array.each do |genre|
          shop_drinks += shop.drinks.where(drink_genre_id: genre)
        end
      end
      shop_drinks.each do |drink|
        drinks.push([drink.drink_name, drink.drink_price])
      end
      shop_json = shop.as_json
      drinks = drinks.sort_by { |_, v| v }
      shop_json['drinks'] = drinks
      new_shops.push(shop_json)
    end
    new_shops.as_json
  end

  def self.beer_distance(lat_now, lng_now, genre_array, show_num)
    if genre_array.include?(2)
      option = '(SELECT `shops`.* FROM `shops` INNER JOIN `shop_drinks` ON `shops`.`id` = `shop_drinks`.`shop_id` WHERE `shop_drinks`.`drink_genre_id` = 2 OR `drink_genre_id` = 3 OR `drink_genre_id` = 4 OR `drink_genre_id` = 5 OR `drink_genre_id` = 6 OR `drink_genre_id` = 7 OR `drink_genre_id` = 8 ) AS drink_genre'
    else
      options = ''
      genre_array.each_with_index do |genre, index|
        options << if index == genre_array.size - 1
                     "`drink_genre_id` = #{genre}"
                   else
                     "`drink_genre_id` = #{genre} OR "
                   end
      end
      option = "(SELECT `shops`.* FROM `shops` INNER JOIN `shop_drinks` ON `shops`.`id` = `shop_drinks`.`shop_id` WHERE `shop_drinks`.#{options} ) AS drink_genre"
    end
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
      #{option}
    ORDER BY
      distance
    LIMIT :show_num
    ;
    SQL
    find_by_sql([query, { lat_now: lat_now, lng_now: lng_now, show_num: show_num }])
  end

  def self.drink_shops(lat_now, lng_now, serch_word, show_num)
    shops = Shop.drink_distance(lat_now, lng_now, serch_word, show_num)
    shops.as_json
    new_shops = []
    shops.each do |shop|
      drinks = []
      shop_drinks = shop.drinks.where("drink_name LIKE ?", "%#{serch_word}%")
      shop_drinks.each do |drink|
        drinks.push([drink.drink_name, drink.drink_price])
      end
      shop_json = shop.as_json
      drinks = drinks.sort_by { |_, v| v }
      shop_json['drinks'] = drinks
      new_shops.push(shop_json)
    end
    new_shops.as_json
  end

  def self.drink_distance(lat_now, lng_now, serch_word, show_num)
    serch_word = "%#{serch_word}%"
    query = <<-SQL
    SELECT DISTINCT
      id,
      shop_name,
      shop_url,
      shop_lat,
      shop_lng,
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
      (
        SELECT
          shops.id,
          shops.shop_name,
          shops.shop_url,
          shops.shop_lat,
          shops.shop_lng
        FROM
          drinks,
          shops
        WHERE
          shops.id = drinks.shop_id
          AND
          drinks.drink_name LIKE :serch_word
          ) AS shop_drinks
        ORDER BY
          distance
        LIMIT :show_num
    ;
    SQL
    find_by_sql([query, { lat_now: lat_now, lng_now: lng_now, serch_word: serch_word, show_num: show_num }])
  end
end