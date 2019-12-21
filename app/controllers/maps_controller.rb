class MapsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index; end

  def fetch_test
    @lat = params[:now_lat]
    @lng = params[:now_lng]
    log = Logger.new(STDOUT)
    log.info(@lat)
    log.info(@lng)

    @shops = Shop.get_shops(@lat, @lng, 10)
    render json: @shops
  end
end

