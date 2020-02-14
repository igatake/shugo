class BeerController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index; end

  def fetch_beers
    @lat = params[:now_lat]
    @lng = params[:now_lng]
    @drink_genre = params[:genre_array]
    @shop_num = params[:shop_num].to_i
    @job = params[:job]
    log = Logger.new(STDOUT)
    log.info(@lat)
    log.info(@lng)
    log.info(@drink_genre)
    log.info(@shop_num)
    log.info(@job)
    job_log = Logger.new("log/working.log", 2, 10 * 1024)
    job_log.info(@job)

    @shops = Shop.beer_shops(@lat, @lng, @drink_genre, @shop_num)
    render json: @shops
  end
end