require 'assets/c_scrape'

namespace :cs do
  desc "Scrape"
  task :s => :environment do
    puts 'CS Start'
    CScrape.new.parse
    puts 'CS Complete'
  end
end
