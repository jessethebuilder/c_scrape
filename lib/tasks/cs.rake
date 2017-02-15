require 'assets/c_scrape'

namespace :cs do
  desc "Scrape"
  task :scrape => :environment do
    t = Time.now
    puts 'CS Start....................................'
    c = CScrape.new(['search/cpg', 'search/web', 'search/sof'],
                    [/web developer/, /ruby on rails/, /web ?site/,
                     /word ?press/, /scraping/, /mining/, /ruby/,
                     /excel/, /angular/, /web ?design/, /front.?end/, /java.?script/,
                     /square ?space/],
                    exclude_expressions: [/survey/, /partner/, /intern/],
                    search_depth: 20,
                    regions: ['us'])
    c.exec

    puts "CS Complete in #{Time.now - t} seconds."
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
