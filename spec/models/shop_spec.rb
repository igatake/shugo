require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe '#get_distance' do
    Shop.get_distance(35.689407, 139.700306)
  end
end
