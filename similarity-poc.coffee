"use strict"

Boilerpipe = require "boilerpipe"
Tokenizer  = require "sentence-tokenizer"

tokenizer = new Tokenizer()

boilerpipe = new Boilerpipe
  extractor: Boilerpipe.Extractor.ArticleSentences,
  url: "http://www.fastmed.com/health-resources/related-searches/looking-for-asheville-medical-clinic"

boilerpipe.getText (err, text) ->
  tokenizer.setEntry text
  sentences = tokenizer.getSentences()
  for sentence1 in sentences
    for sentence2 in sentences
      console.log "Sentence 1: ", sentence1
      console.log "Sentence 2: ", sentence2
      console.log "Similarity: ", compareStrings sentence1, sentence2

letterPairs = (str) ->
  numPairs = str.length - 1
  pairs = []
  for i in [1..numPairs]
    pairs.push str.substr i, 2
  pairs

wordLetterPairs = (str) ->
  allPairs = []
  words = str.match /\S+/g
  for word in words
    pairsInWord = letterPairs word
    allPairs.push.apply allPairs, pairsInWord
  allPairs

compareStrings = (str1, str2) ->
  pairs1 = wordLetterPairs str1.toUpperCase()
  pairs2 = wordLetterPairs str2.toUpperCase()
  intersection = 0
  union = pairs1.length + pairs2.length
  for pair1 in pairs1
    for pair2, i in pairs2
      if pair1 is pair2
        intersection++
        pairs2.splice i, 1
        break
  (2.0 * intersection) / union
