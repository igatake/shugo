class MapsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index; end

  def fetch_test
    @lat = params[:now_lat]
    @lng = params[:now_lng]
    log = Logger.new(STDOUT)
    log.info(@lat)
    log.info(@lng)
    # params[:max_x], params[:min_y], params[:max_y])
    render json: {
      lat: @lat,
      lng: @lng
    }
  end
end
