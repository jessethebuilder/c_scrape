class ListingsController < ApplicationController
  def index
    if params[:only_new]
      @listings = Listing.where(:seen => false)
    elsif params[:unvisited]
      @listings = Listing.where(:visited => false)
    else
      @listings = Listing.all
    end

    @listings.each{ |l| l.update(seen: true) }
  end

  def show
    @listing = Listing.find(params[:id])
    @listing.update(visited: true)
    redirect_to @listing.url
  end
end
