require_relative 'c_scrape/c_locations'
require_relative 'c_scrape/c_listings'
require_relative 'c_scrape/c_pages'

class CScrape
  INDEX_PAGE = 'https://www.craigslist.org/about/sites'

  def initialize(search_pages, include_expressions, search_depth: 30, regions: [:us],
                  exclude_expressions: [], states: nil, locations: nil)
    # max search depth is 100, as that is max number of results per page
    set_ghost

    @search_pages = search_pages
    @include_experessions = include_expressions
    @exclude_expressions = exclude_expressions
    @regions = get_locations(regions)
    @search_depth = search_depth
    @states = states
    @locations = locations
  end


  def exec
    walk_regions
  end

  def CScrape.purge_records
    c = Listing.count
    Listing.destroy_all
    puts "DESTROYED #{c} Records!"
  end

  def CScrape.count
    puts "Record count: #{Listing.count}"
  end

  private

  def walk_regions
    @search_pages.each do |search_page|
      @regions.each do |region_name, states|
        states.each do |state_name, locations|
          if @states.nil? || @states.include?(state_name)
            locations.each do |location_name, url|
              if @locations.nil? || @locations.include?(location_name)

                clean_listings(get_listings(url + search_page)).each do |listing|
                  puts '......................................................'
                  puts '......................................................'
                  puts listing
                  puts '......................................................'
                  puts '......................................................'
                  create_listing(listing, search_page, region_name, state_name, location_name)
                end
              end
            end
          end
        end
      end
    end
  end

  #--- Set Ghost -------------------------------------------
  def set_ghost
    @ghost = JsScrape.new(timeout: 10, :proxy => false, :debug => false)
  end
end
