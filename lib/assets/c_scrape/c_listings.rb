class CScrape

  private

  def create_listing(listing, search_page, region, state, location)
    l = Listing.new
    [:url, :text, :search, :hood].each do |attr|
      l.send("#{attr}=", listing[attr])
    end
    l.search_page = search_page
    l.region = region
    l.state = state
    l.location = location
    announce_listing(l)
    l.save
  end

  def announce_listing(listing)
    puts "Listing created in #{listing.location.titlecase}, #{listing.state} for #{listing.search_page}"
  end

  def get_listings(url)
    @ghost.goto url
    rows = @ghost.page.find_all('.result-row')[0..@search_depth]

    a = []
    rows.each do |row|
      h = {}
      link = row.find('.result-title')
      h[:url] = link['href']
      h[:text] = link.text.downcase

      hoods = row.all('.result-hood')
      if hoods.count > 0
      # if row.has_css?('.result-hood')
        h[:hood] = hoods[0].text.gsub(/[()]/, '')
      end

      a << h
    end
    a
  end

  def clean_listings(listings)
    clean = listings.map{ |listing| clean_listing(listing) }
    clean.delete_if{ |l| l == nil }
  end

  def clean_listing(listing)
    listing if !listing_exists?(listing) && !listing_is_excluded?(listing) && listing_is_included?(listing)
  end

  def listing_exists?(listing)
    Listing.where(:url => listing[:url]).count > 1
  end

  def listing_is_excluded?(listing)
    @exclude_expressions.each do |exp|
      return true if exp =~ listing[:text]
    end

    false
  end

  def listing_is_included?(listing)
    @include_experessions.each  do |exp|
      listing[:search] = exp.to_s
      return true if exp =~ listing[:text]
    end

    false
  end
end
