class TextExtractor
  attr_accessor :text
  
  def initialize(_text)
    @text = remove_styles(_text)
    @text = remove_scripts(@text)
    @text = remove_comments(@text)
    @text = remove_tags(@text)
    @text = remove_whitespace(@text)
  end
  
  def remove_scripts(_document)
    document = _document.gsub(/<script.*?<\/script>/m, "")
    return document
  end
  
  def remove_styles(_document)
    document = _document.gsub(/<style.*?<\/style>/m, "")
    return document
  end
  
  def remove_comments(_document)
    document = _document.gsub(/<!--.*?-->/m, "")
    return document
  end
  
  def remove_tags(_document)
    document = _document.gsub(/<.*?>/m, "")
    return document
  end
  
  def remove_whitespace(_document)
    document = _document.squeeze(" ").strip
    document = document.gsub(/\r/," ")
    document = document.gsub(/\n/," ")
    document = document.gsub(/\t/," ")
    document = document.gsub(/\s\s*/," ")
    return document
  end
end
