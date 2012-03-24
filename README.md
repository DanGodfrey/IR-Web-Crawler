CSI4107: Web Crawler 
==============================

Design Decisions / Discussion 
------------

To determine what threshold to use for the similarity scores we calculated the similarity scores fore the first 85 links extracted from the 10 seeds. Of those 85 links, 35 had a similarity score above 0.5 and 48 had scores above 0.4. The decision was made to go with a threshold of 0.5 in order to increase precision; however if we went with 0.4 we would have increased recall. These similarity scores can be found in output/sim.csv 

After manually looking at the first 30 texts collected by the crawler 23/30 were about the chosen topic Marvel Comics, giving a procession of 0.77. A detailed analysis of the first 30 texts can be found in `output/first_30_texts.csv`   

Other Stats:

after traversing the seed links, 2699 URLS had been added to the queue

after retrieving 1000 texts with similarity scores > the threshold, 8050 links has been traversed and there were 1,086,009 links remaining in the queue.

Ruby Modules/Classes Developed
------------

### SimularityModule.rb

The SimularityModule class can be used to maintain a collection of topic texts and calculate the similarity of a given string against the collection. 

When initialized, the collection is empty; as such a similarity score of 0.0 will always be returned. 

**add\_topic\_texts(texts)** - Adds "texts" to the collection of topic texts. Stop Words are removed from "texts" and it is downsized before being added to the collection. 

**calculate\_similarity(text)** - Calculates the similarity score between the current collection of topic texts and "text". Stop Words are removed from "text" and it is downsized before the calculation. The "Strike a Match" algorithm proposed by [Simon White of Catalysoft](http://www.catalysoft.com/articles/StrikeAMatch.html) is used for calculating the similarity score. 

The full list of stop words considered can be found in common-english-words.txt under the resources directory. 

### link\_extractor.rb

### text\_extractor.rb

Third-Party Ruby Gems Used 
------------

### Nokogiri

### Robotstxt

Robotstxt is a robots.txt parser written in Ruby. The source code can be found on [Github](https://github.com/rinzi/robotstxt).

Basic Usage:

`Robotstxt.allowed?(url, robot_id)`

Where url is the url you want to crawl and robot_id is the user-agent for your crawler. Robotstxt will return true if you are allowed to crawl the URL and false otherwise. 

We are using user-agent: mr\_roboto\_csi4107

web_crawler.rb 
------------

The web crawler utilizes the three modules written as well as the two third-party Gems. 

When initialized, the crawler creates an empty queue for storing the URLs that need to be traversed. Since queues follow a first in first out paradigm, we traverse the urls using a breadth first strategy. The crawler also creates a Hash for storing the urls already traversed using the URL as the key and a 1 if the link was successfully traversed or 0 if we did not traverse the link due to the robot exclusion protocol as the value. By using a hash, we can efficiently look up the URLs already traversed. 

The crawler begins by reading in the list of seed sites from resources/seeds.txt. It expects that each URL is separated by a line break. 

For each seed URL, the HTML of the page's body is retrieved using Nokogiri and the core library open-uri. The text is then extracted using the text\_extractor and added to the SimilarityModule's topic text to be used to calculate the similarity scores of the subsequent urls. A collection of URLs are then extracted from the page using the link\_extractor and added to the queue of links to traverse. Originally, we checked each url using Robotstxt before adding it to the queue; however, Robotstxt needs to hit the page every time it checks a URL. This meant that we were hitting the page before we even wanted to traverse the url, this also meant that any URLs still in the queue after we retrieved enough texts would have been hit for no reason. Clearly, this was inefficient so we simply add every URL to the queue and then check if we can crawl it immediately before traversing it. 

Once the seed urls are traversed, the crawler loops until either 1000 texts are found or there are no links remaining in the queue to traverse. On each iteration it pops the next url from the queue, if the url has not been traversed and it is allowed to be crawled it retrieves the HTML of the page's body using Nokogiri and extracts the text using the text\_extractor. The crawler then calculates the similarity score of the extracted text with the 10 topic texts extracted from the seed urls. If the score is above the given threshold, the text page is deemed similar and the text is written to output/part4/x.txt where x is the number of similar texts found so far. Furthermore if the page is deemed similar, each url on the page is extracted using the link\_extractor and added to the queue. The traversed link is also added to the hash of already traversed links with value 1. If the link is not allowed to be traversed, or a timeout occurs with Nokogiri or Robotstxt (usually caused by pages with infinite redirects or other issues) the link is not traversed and is added to the hash of already traversed links with value 0.  

TODO:
Make text and link extractor both work on strings.
remove tags: <.*?>
(<(script).*?<\/|(script)>)
<(style).*?<\/|(style)>