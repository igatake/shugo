class Shop < ApplicationRecord
  has_many :drinks, dependent: :destroy
  has_many :shop_drinks, dependent: :destroy
  has_many :drink_genres, through: :shop_drinks

  validates :shop_name, presence: true
  validates :shop_address, presence: true

  def self.get_shops(lat_now, lng_now, genre_array, show_num)
    shops = Shop.get_distance(lat_now, lng_now, genre_array, show_num)
    shops.as_json
    new_shops = []
    shops.each do |shop|
      drinks = []
      shop.drinks.each do |drink|
        if genre_array.include?(2)
          drinks.push([drink.drink_name, drink.drink_price]) if drink.drink_genre.parent_id == 2 || drink.drink_genre.id == 2
        else
          drinks.push([drink.drink_name, drink.drink_price]) if genre_array.include?(drink.drink_genre.id)
        end
      end
      shop_json = shop.as_json
      drinks = drinks.sort_by { |_, v| v }
      shop_json['drinks'] = drinks
      new_shops.push(shop_json)
    end
    new_shops.as_json
  end

  def self.get_distance(lat_now, lng_now, genre_array, show_num)
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
end