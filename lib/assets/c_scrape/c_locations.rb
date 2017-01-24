class CScrape

  private

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
      h = locations
    end

    get_sub_locations(h)
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

  #--- Sub Locations Functions --------------------------------------
  def get_sub_locations(locations)
    hash = {}
    locations.each do |region, locations|
      hash[region] = get_sub_locations_for_region(locations)
    end

    hash
  end

  def get_sub_locations_for_region(locations)
    hash = {}
    locations.each do |location, links|
      hash[location] = get_sub_locations_for_location(links)
    end

    hash
  end

  def get_sub_locations_for_location(links)
    hash = {}
    links.each do |link|
      link =~ /https:\/\/(\w+)\.cr/
      hash[$1] = link
    end

    hash
  end
end
