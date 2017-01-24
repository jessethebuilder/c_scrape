require 'assets/c_scrape'

namespace :cs do
  desc "Scrape"
  task :s => :environment do
    t = Time.now
    puts 'CS Start....................................'
    CScrape.new.exec(fresh: false)
    puts "CS Complete in #{Time.now - t} seconds."
  end
end
