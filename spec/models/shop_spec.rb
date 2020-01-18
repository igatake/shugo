require 'rails_helper'

RSpec.describe Shop, type: :model do

  describe '#get_distance_with_genre_id_2' do
    puts Shop.get_shops(35.689407, 139.700306,[2], 1)
  end

  describe '#get_distance_with_genre_id_3' do
    puts Shop.get_shops(35.689407, 139.700306, [4, 6, 8], 1)
  end
end
