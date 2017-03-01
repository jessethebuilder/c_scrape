require 'assets/c_scrape'

namespace :cs do
  desc "Scrape"
  task :scrape => :environment do
    # everything is UTC.
    t = Time.now
    h = t.hour

    pass = Rails.env.production? ? ((0..6).member?(h) || (17..24).member?(h)) : true
    if pass
      puts 'CS Start....................................'
      c = CScrape.new(['search/cpg', 'search/web', 'search/sof'],
                      [/web developer/i, /ruby on rails/i, /web ?site/i,
                       /word ?press/i, /scraping/i, /mining/i, /ruby/i,
                       /excel/i, /angular/i, /web ?design/i, /front.?end/i, /java.?script/i,
                       /square ?space/i, /php/i, /plugin/i, /weebly/i],
                      exclude_expressions: [/survey/i, /partner/i, /intern/i],
                      search_depth: 30)
      c.exec

      puts "CS Complete in #{Time.now - t} seconds."
    end
  end

  task :s => :scrape

  task :purge => :environment do
    CScrape.purge_records
  end

  task :p => :purge

  task :count => :environment do
    CScrape.count
  end
end
