require 'nokogiri'
require 'open-uri'
require 'thread'
require 'robotstxt'
require_relative 'link_extractor'
require_relative 'text_extractor'
require_relative 'SimilarityModule'

class WebCrawler
  def initialize()
    
    robot_id = "mr_roboto_csi4107"
    sm = SimilarityModule.new
    links_to_traverse = Queue.new
    links_already_traversed = Hash.new
    texts_found = 0
    similarity_threshold = 0.5
    
    File.open("./resources/seeds.txt").read.split("\n").each do |seed|
      html = Nokogiri::HTML(open(seed))
      body = html.css("body")
      urls = LinkExtractor.new(body, seed).urls
      sm.add_topic_texts(TextExtractor.new(body.to_s).text)
      links_already_traversed[seed] = 1
      urls.each do |url|
        links_to_traverse << url
      end
    end
    
    puts "---after seed---"
    puts "left: " << links_to_traverse.size.to_s
    puts "traversed/blocked: " << links_already_traversed.size.to_s
    
    while texts_found < 1000 && !links_to_traverse.empty?
      link = links_to_traverse.pop
      begin
        if Robotstxt.allowed?(link, robot_id) && ! links_already_traversed.has_key?(link)
          links_already_traversed[link] = 1
          html = Nokogiri::HTML(open(link))
          body = html.css("body")
          text = TextExtractor.new(body.to_s).text
      
          if sm.calculate_similarity(text) > similarity_threshold
            texts_found += 1        
            File.open("./output/part4/" + texts_found.to_s + ".txt", 'w+').write("URL: " + link + "\n\n\n" + text)
            #File.open("./output/part4/sim.txt", 'a').write(sm.calculate_similarity(text).to_s + "\n")
            urls = LinkExtractor.new(body, link).urls
            urls.each do |url|
              links_to_traverse << url
            end
          end
        else
          links_already_traversed[link] = 0
        end 
      rescue
        puts "Bad URL: " << link
        links_already_traversed[link] = 0
      end       
    end
    puts "---after 1000 found---"
    puts "left: " << links_to_traverse.size.to_s
    puts "traversed/blocked: " << links_already_traversed.size.to_s
  end
end

WebCrawler.new()