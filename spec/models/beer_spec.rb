require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "beer_name, beer_pricem beer_genre, shop_name, shop_address, shop_urlがあればvalid" do
    beer = Beer.new(
      beer_name: 'サッポロ黒ラベル',
      beer_price: '430',
      beer_genre: '3',
      shop_name: '酒豪居酒屋',
      shop_address: '東京都豊島区123-45',
      shop_url: '/6789/'
    )
    expect(beer).to be_valid
  end

  # it "first_nameがなければinvalid"

  it ".fetch_beers" do
    Beer.fetch_beers
  end
end
