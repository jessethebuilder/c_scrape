class CScrape
  INDEX_PAGE = 'https://www.craigslist.org/about/sites'

  def initialize(regions = [:us])
    set_ghost
    locations = get_locations(regions)
    @listings = get_listings(locations)
  end


  def parse
    puts @listings
  end



  private

  #--- Parse Locations Functions --------------------------------------
  def get_listings(locations)
    hash = {}
    locations.each do |region, locations|
      hash[region] = get_listings_for_region(locations)
    end

    hash
  end

  def get_listings_for_region(locations)
    hash = {}
    locations.each do |location, links|
      hash[location] = get_listings_for_location(links)
    end

    hash
  end

  def get_listings_for_location(links)
    hash = {}
    links.each do |link|
      link =~ /https:\/\/(\w+)\.cr/
      hash[$1] = links
    end

    hash
  end

  #--- Get Locations Functions ----------------------------------------
  def get_locations(regions)
    locations = get_all_locations

    if regions
      h = {}
      regions.each do |region|
        h[region] = locations[region.to_s.upcase]
      end
      h
    else
      locations
    end
  end

  def get_all_locations
    @ghost.goto INDEX_PAGE
    hash = {}
    headings = @ghost.cap.find_all('h1')
    regions = @ghost.cap.find_all('.colmask')

    headings.each_with_index do |h, i|
      region = regions[i]
      hash[h.text] = parse_region(region)
    end
    hash
  end

  def parse_region(region)
    hash = {}
    headings = region.find_all('h4')
    sub_regions = region.find_all('ul')

    headings.each_with_index do |h, i|
      sub_region = sub_regions[i]
      hash[h.text] = parse_sub_region(sub_region)
    end
    hash
  end

  def parse_sub_region(sub_region)
    sub_region.find_all('a').map{ |link| link['href'] }
  end

  #--- Set Ghost -------------------------------------------
  def set_ghost
    @ghost = JsScrape.new(timeout: 10, :proxy => false, :debug => false)
  end
end
