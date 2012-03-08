class SimilarityModule

  attr_accessor :topic_texts

  def initialize
    initialize_stopwords
    @topic_texts = ""
  end
  
  def initialize_stopwords
    doc = File.open('resources/common-english-words.txt').read
    @stopwords = {}
    doc.split(',').each do |word|
      @stopwords[word] = 1
    end
  end
  
  def add_topic_texts(texts)
    @topic_texts += remove_stopwords(texts).downcase + "\n"
  end

  def calculate_similarity(text)
    text = remove_stopwords(text).downcase
    
    pairs1 = (0..@topic_texts.length-2).collect {|i| @topic_texts[i,2]}.reject {
      |pair| pair.include? " "}
    
    pairs2 = (0..text.length-2).collect {|i| text[i,2]}.reject {
      |pair| pair.include? " "}
      
    union = pairs1.size + pairs2.size 
    intersection = 0 
    pairs1.each do |p1| 
      0.upto(pairs2.size-1) do |i| 
          if p1 == pairs2[i] 
            intersection += 1 
            pairs2.slice!(i) 
            break 
          end 
      end 
    end
    
    return (2.0 * intersection) / union    
  end

  private

  def remove_stopwords(doc)
    doc.gsub!(/[^0-9a-z]/i, ' ')
    a_doc = doc.split(' ')
    a_doc.delete_if { |word| @stopwords.has_key?(word) }
    output = ""
    a_doc.each do |word|
      output << word << " "
    end
    return output
  end
end