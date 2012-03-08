CSI4107: Web Crawler 
==============================

Ruby Modules
------------

### SimularityModule.rb

The SimularityModule class can be used to maintain a collection of topic texts and calculate the similarity of a given string against the collection. 

When initialized, the collection is empty; as such a similarity score of 0.0 will always be returned. 

add_topic__texts(texts) - Adds "texts" to the collection of topic texts. Stop Words are removed from "texts" and it is downsized before being added to the collection. 

calculate_similarity(text) - Calculates the similarity score between the current collection of topic texts and "text". Stop Words are removed from "text" and it is downsized before the calculation. The "Strike a Match" algorithm proposed by [Simon White of Catalysoft](http://www.catalysoft.com/articles/StrikeAMatch.html) is used for calculating the similarity score. 

The full list of stop words considered can be found in common-english-words.txt under the resources directory. 