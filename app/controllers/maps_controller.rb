class MapsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index; end

  def fetch_drinks
    @lat = params[:now_lat]
    @lng = params[:now_lng]
    @serch_word = params[:serch_word]
    @shop_num = params[:shop_num].to_i
    @job = params[:job]
    log = Logger.new(STDOUT)
    log.info(@lat)
    log.info(@lng)
    log.info(@serch_word)
    log.info(@shop_num)
    job_log = Logger.new("log/working.log", 2, 10 * 1024)
    job_log.info(@job)

    @shops = Shop.drink_shops(@lat, @lng, @serch_word, @shop_num)
    render json: @shops
  end
end

