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
  end

  def self.scrape_profile_page(profile_url)
    url = Nokogiri::HTML(open(profile_url))
    social = url.css('div.social-icon-container a').map { |link| nil ? nil : link['href'] || nil }

    profile_details = {}

    social.map do |x|
      if x.include?("linkedin.com")
        profile_details[:linkedin] = x
      elsif x.include?("github.com")
        profile_details[:github] = x
      elsif x.include?("twitter.com")
        profile_details[:twitter] = x
      else
        profile_details[:blog] = x
      end
    end

    profile_details[:profile_quote] = url.css('div.profile-quote').text.strip
    profile_details[:bio] = url.css('div.description-holder p').text.strip

    profile_details
  end

end
