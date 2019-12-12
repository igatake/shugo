class MapsController < ApplicationController
  def index; end

  def fetch_test
    @shops = JSON.parse(request.body.read)
    render json: @shops
  end
end
