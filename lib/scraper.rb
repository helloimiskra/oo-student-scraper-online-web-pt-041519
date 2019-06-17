require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :profile_url


  def self.scrape_index_page(index_url)
    url = Nokogiri::HTML(open('./fixtures/student-site/index.html'))
    url.css('div.student-card').map.with_index do |s, i|
      s = {
        :name => url.css('h4.student-name').map{|el| el.text}[i],
        :location => url.css('p.student-location').map{|el| el.text}[i],
        :profile_url => url.css('a').map { |link| link['href'] }[i+1],
      }
      s
    end

    # binding.pry
    # s_names = url.css('div.student-card h4.student-name').map{|el| el.text}
    # s_locations = url.css('div.student-card p.student-location').map{|el| el.text}
    # profile_url = url.css('div.student-icon-container a').map { |link| link['href'] }[1]

  end

  def self.scrape_profile_page(profile_url)
    url = Nokogiri::HTML(open(profile_url))
    social = url.css('div.social-icon-container a').map { |link| nil ? nil : link['href'] || nil }
    #  binding.pry
    profile_details = {
      :linkedin => social.each_with_index do |x, i|
        if x[i].include?("linkedin")
          x[i]
      end,
      :github => social[2],
      # social.each {|social| social.include?('github') ? social : nil},
      # social[2].include?('github') ? social[2] : nil,
      :blog => social[3],
      # social.each {|social| social.include?('.com') ? social : nil},
      # # social[3].include?('.com') ? social[3] : nil,
      :twitter => social[0],
      # social.each {|social| social.include?('twitter') ? social : nil},
      # social[0].include?('twitter') ? social[0] : nil,
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
