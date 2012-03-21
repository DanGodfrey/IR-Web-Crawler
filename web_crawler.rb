require 'nokogiri'
require 'open-uri'
require_relative 'link_extractor'
require_relative 'text_extractor'

class WebCrawler
  def initialize(url)
    
    html = Nokogiri::HTML(open(url))
    body = html.css("body")
    LinkExtractor.new(body, url).urls # Returns an array of urls.
    TextExtractor.new(body.to_s).text # Returns a string of space seperated words.
  end
end

puts "Enter a url. Remember to include http://..."
WebCrawler.new(gets.chomp)