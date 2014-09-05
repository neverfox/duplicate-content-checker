"use strict"

Boilerpipe = require "boilerpipe"
Promise    = require "bluebird"
Tokenizer  = require "sentence-tokenizer"

tokenizer = new Tokenizer()

exports.post = (req, res) ->
  compareURLs(req.body.url1, req.body.url2).then (comparisons) ->
    res.send
      result: "success"
      comparisons: comparisons

compareURLs = (url1, url2) ->
  result =
    url1: url1
    url2: url2
    comparisons: []
  Promise.all([
    extractSentences url1
  ,
    extractSentences url2
  ]).spread (sentences1, sentences2) ->
    for sentence1 in sentences1
      for sentence2 in sentences2
        result.comparisons.push
          sentence1: sentence1
          sentence2: sentence2
          similarity: compareStrings sentence1, sentence2
    result

extractSentences = (url) ->
  boilerpipe = new Boilerpipe
    extractor: Boilerpipe.Extractor.ArticleSentences,
    url: url

  new Promise (resolve, reject) ->
    boilerpipe.getText (err, text) ->
      reject err  if err
      tokenizer.setEntry text
      resolve tokenizer.getSentences()

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
