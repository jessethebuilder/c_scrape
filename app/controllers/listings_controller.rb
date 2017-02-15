class ListingsController < ApplicationController
  def index
    # if params[:search]
    #   search = params[:search].split(',')
    #   @listings = Listing.where(search.first => search.last)
    # elsif params[:all]
    #   @listings = Listing.all
    # elsif params[:minutes_old]
    #   @listings= Listing.where(created_at: (params[:minutes_old].to_i.minutes.ago..Time.now))
    # else
    #   @listings = Listing.where(:seen => false)
    # end
    #
    # @listings = @listings.order(:created_at => :desc)
    #
    # @listings.each{ |l| l.update(seen: true) }

    @listings = Listing.all.order(created_at: :desc).page(params[:page]).per(50)
  end

  def show
    @listing = Listing.find(params[:id])
    @listing.update(visited: true)
    redirect_to @listing.url
  end
end
