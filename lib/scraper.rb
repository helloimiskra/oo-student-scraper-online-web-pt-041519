require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :profile_url


  def self.scrape_index_page(index_url)
    url = Nokogiri::HTML(open('./fixtures/student-site/index.html'))
    binding.pry
    url.css('div.student-card').map.with_index do |s, i|
      s = {
        :name => url.css('h4.student-name').map{|el| el.text}[i],
        :location => url.css('p.student-location').map{|el| el.text}[i],
        :profile_url => url.css('a').map { |link| link['href'] }[i+1],
      }
      s
    end
  end

  def self.scrape_profile_page(profile_url)
    url = Nokogiri::HTML(open('./fixtures/student-site/students/david-kim.html'))
    social = url.css('div.social-icon-container a').map { |link| nil ? nil : link['href'] || nil }
    profile_details = {
      :linkedin => social.map do |x|
        if x.include?("linkedin")
          puts "#{x}"
        end
      end,
      :github => social.map do |x|
        if x.include?("github")
          puts "#{x}"
        end
      end,
      :blog => social.map do |x|
        if x.include?(".com")
          puts "#{x}"
        end
      end,
  
      :twitter => social.map do |x|
        if x.include?("twitter")
          puts "#{x}"
        end
      end,

      :profile_quote => url.css('div.profile-quote').text.strip,
      :bio => url.css('div.description-holder p').text.strip
    }
    profile_details

  end

#student names url.css('div.roster-cards-container div.student-card h4.student-name').first
#student location url.css('div.roster-cards-container div.student-card p.student-location')
#student url
#   list = url.css('student-name').text.split()
# div.main-wrapper.roster div.roster-body-wrapper
end
