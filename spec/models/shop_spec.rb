require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe '#get_distance_without_genre_id' do
    shops = Shop.get_distance(35.689407, 139.700306, 100)
    shops.each do |shop|
      puts shop.id
      puts shop.shop_name
      puts shop.distance
    end
  end
  
  describe '#get_distance_with_genre_id' do
    shops = Shop.get_distance(35.689407, 139.700306, 100, 2)
    shops.each do |shop|
      puts shop.id
      puts shop.shop_name
      puts shop.distance
    end
  end
end
