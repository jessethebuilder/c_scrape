class ListingsController < ApplicationController
  def index
    # listings = Listing.all.order(created_at: :desc).page(params[:page]).per(50)
    # @listings = []
    # urls = []
    #
    # listings.each do |l|
    #   url = l.url
    #   unless urls.include?(url)
    #     @listings << l
    #   end
    #
    #   urls << url
    # end
    #
    # @listings = Kaminari.paginate_array(@listings).page(params[:page]).per(100)

    @listings = Listing.all.order(created_at: :desc).page(params[:page]).per(50)

    @hal = hal

  end

  def show
    @listing = Listing.find(params[:id])
    @listing.update(visited: true)
    redirect_to @listing.url
  end
end
