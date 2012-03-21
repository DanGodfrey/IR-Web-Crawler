class LinkExtractor
  attr_accessor :urls
  
  def initialize(doc, url)
    @urls = []
    root = get_root_url(url)
    puts doc
    doc.xpath("//a").each do |anchor|
      unless anchor['rel'] == 'nofollow'
        anchor = anchor['href']
        unless anchor.class == NilClass
          anchor = url_cleanup(anchor)
          anchor = prefix_domain(root, anchor)
          clean_anchor = "http://#{anchor}"
          unless anchor.eql?(root) then @urls << clean_anchor end
        end
      end
    end
  end
  
  def get_root_url(url)
    return url.match(/([\da-zA-Z\.-]+)\.([a-z\.]{2,6})\//).to_s
  end
  
  def prefix_domain(root, anchor)
    if anchor.match(/([\da-zA-Z\.-]+)\.([a-z\.]{2,6})\//).nil?
      anchor = "#{root}#{anchor}"
    end
    return anchor
  end
  
  def url_cleanup(anchor)
    anchor = anchor.gsub(/#.*/, "")
    anchor = anchor.gsub(/mailto:.*/, "")
    anchor = anchor.gsub(/\?.*/, "")
    anchor = anchor.gsub(/\?.*/, "")
    anchor = anchor.gsub(/\ /, "")
    anchor = anchor.gsub(/https?:\/\//, "")
    anchor = anchor.gsub(/^(\/)*/, "")
    return anchor
  end
end