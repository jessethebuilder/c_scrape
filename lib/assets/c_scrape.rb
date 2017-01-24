require_relative 'c_scrape/c_locations'
require_relative 'c_scrape/c_listings'
require_relative 'c_scrape/c_pages'

class CScrape
  INDEX_PAGE = 'https://www.craigslist.org/about/sites'

  def initialize(search_pages: ['search/cpg', 'search/web'], search_depth: 20, regions: [:us],
                   include_expressions: [/web developer/, /ruby on rails/, /web ?site/,
                                      /word ?press/, /scraping/, /mining/, /ruby/,
                                      /excel/, /angular/, /web ?design/, /front.?end/, /java.?script/],
                  exclude_expressions: [/survey/, /partner/])
    # max search depth is 100, as that is max number of results per page
    set_ghost

    @search_pages = search_pages
    @include_experessions = include_expressions
    @exclude_expressions = exclude_expressions
    @regions = get_locations(regions)
    @search_depth = search_depth
  end


  def exec(fresh: false)
    purge_records if fresh
    walk_regions
  end

  private

  def walk_regions
    @search_pages.each do |search_page|
      @regions.each do |region_name, states|
        states.each do |state_name, locations|
          locations.each do |location_name, url|
            clean_listings(get_listings(url + search_page)).each do |listing|
              create_listing(listing, search_page, region_name, state_name, location_name)
            end
          end
        end
      end
    end
  end

  def purge_records
    Listing.destroy_all
    puts "-------! DESTROYED #{Listing.count} Records !----------"
  end
  #--- Set Ghost -------------------------------------------
  def set_ghost
    @ghost = JsScrape.new(timeout: 10, :proxy => false, :debug => false)
  end
end
