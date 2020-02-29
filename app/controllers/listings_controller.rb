class ListingsController < ApplicationController
  def index
    @listings = Listing.order(created_at: :desc).page(params[:page]).per(1000)

    @hal = hal
  end

  def show
    @listing = Listing.find(params[:id])
    @listing.update(visited: true)
    redirect_to @listing.url
  end
end
