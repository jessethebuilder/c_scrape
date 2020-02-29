require 'assets/c_scrape'

require Rails.root.to_s + '/app/helpers/hal_helper'
include HalHelper

namespace :cs do
  desc "Scrape"
  task :scrape => :environment do
    while hal.on do
      puts 'CS Start....................................'
      c = CScrape.new(['search/cpg', 'search/web', 'search/sof'],
                      [/web developer/i, /ruby ?on ?rails/i, /web ?site/i,
                       /word ?press/i, /scraping/i, /data ?mining/i, /ruby/i,
                       /excel/i, /angular/i, /front ?end/i, /java ?script/i,
                       /php/i, /plugin/i, /elixir/i],
                      exclude_expressions: [/survey/i, /partner/i, /intern/i],
                      search_depth: 30)
      c.exec

      puts "CS Complete in #{Time.now - t} seconds."

      sleep 5 * 60
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
