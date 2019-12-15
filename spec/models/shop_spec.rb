require 'rails_helper'

RSpec.describe Shop, type: :model do
  # describe '#get_distance_without_genre_id' do
  #   shops = p Shop.get_distance(35.689407, 139.700306, 100)
  #   shops.each do |shop|
  #     puts shop.id
  #     puts shop.shop_name
  #     puts shop.distance
  #   end
  # end

  describe '#get_distance_with_genre_id' do
    shops = Shop.get_distance(35.689407, 139.700306, 20, 2)
    new_shops = []
    shops.each do |shop|
      drinks = {}
      shop.drinks.each do |drink|
        drinks[drink.drink_name] = drink.drink_price if drink.drink_genre.parent_id == 2
      end
      shop_json = shop.as_json
      shop_json['drink'] = drinks
      new_shops.push(shop_json)
    end
    puts new_shops.as_json
    puts '============================================='
  end

  describe '#get_distance_with_genre_id' do
    shops = Shop.get_distance(35.689407, 139.700306, 20, 3)
    new_shops = []
    shops.each do |shop|
      drinks = {}
      shop.drinks.each do |drink|
        drinks[drink.drink_name] = drink.drink_price if drink.drink_genre.id == 3
      end
      shop_json = shop.as_json
      shop_json['drink'] = drinks
      new_shops.push(shop_json)
    end
    puts new_shops.as_json
  end
end
