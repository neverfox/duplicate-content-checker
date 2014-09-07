Similarity
==========

The **Similarity** middleware module implements a similarity ranking algorithm for the sentences found in the article
content of two URLs.

The algorithm was driven by the following requirements (as laid out by Simon White, PhD):

* **A true reflection of lexical similarity** - strings with small differences should be recognised as being similar.
In particular, a significant substring overlap should point to a high level of similarity between the strings.
* **A robustness to changes of word order** - two strings which contain the same words, but in a different order,
should be recognised as being similar. On the other hand, if one string is just a random anagram of the characters
contained in the other, then it should (usually) be recognised as dissimilar.
* **Language Independence** - the algorithm should work not only in English, but in many different languages.

The resulting similarity metric is "twice the number of character pairs that are common to both strings divided by the
sum of the number of character pairs in the two strings. Note that the formula rates completely dissimilar strings with
a similarity value of 0, since the size of the letter-pair intersection in the numerator of the fraction will be zero.
On the other hand, if you compare a (non-empty) string to itself, then the similarity is 1." This metric is known as a
[Sørensen–Dice](http://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient) coefficient (or index).

Helpers & Initial Setup
-----------------------

Enable [strict mode](http://www.nczonline.net/blog/2012/03/13/its-time-to-start-using-javascript-strict-mode/) for the entire module.

    "use strict"

Require external dependencies.

    Boilerpipe = require "boilerpipe"
    Promise    = require "bluebird"
    Tokenizer  = require "sentence-tokenizer"

Initialize the sentence tokenizer.

    tokenizer = new Tokenizer()

Core Algorithm
--------------

The basis of the algorithm is the method `letterPairs` that computes the pairs of characters contained
in the input string. This method creates an array of strings to contain its result. It then iterates
through the input string, to extract character pairs and store them in the array. Finally, the array is returned.

    letterPairs = (str) ->
      numPairs = str.length - 1
      pairs = []
      for i in [1..numPairs]
        pairs.push str.substr i, 2
      pairs

The 'wordLetterPairs' method uses the `match` method of strings to split the input string into separate words, or tokens.
It then iterates through each of the words, computing the character pairs for each word using `letterPairs`. The character
pairs are added to an array, which is returned from the method.

    wordLetterPairs = (str) ->
      allPairs = []
      words = str.match /\S+/g
      for word in words
        pairsInWord = letterPairs word
        allPairs.push.apply allPairs, pairsInWord
      allPairs

The 'compareStrings' method computes the character pairs from the words of each of the two input strings using
`wordLetterPairs`, then iterates through the arrays to find the size of the intersection. Note that whenever a match is
found, that character pair is removed from the second array list to prevent us from matching against the same character pair
multiple times. (Otherwise, 'GGGGG' would score a perfect match against 'GG'.)

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
      # The final value returned is the Sørensen–Dice coefficient of the two strings.
      (2.0 * intersection) / union

Sentence Extraction & Comparison
--------------------------------

Now that the algorithm for string matching is in place, the module needs a method for extracting strings (in this case,
sentences) from an article located at a particular URL. Using *Boilerpipe*'s ArticleSentences extractor to extract the
article text and *sentence-tokenizer* to split it into sentences, `extractSentences` returns a Promise for an array of
sentences.

    extractSentences = (url) ->
      boilerpipe = new Boilerpipe
        extractor: Boilerpipe.Extractor.ArticleSentences,
        url: url

      new Promise (resolve, reject) ->
        boilerpipe.getText (err, text) ->
          reject err  if err
          tokenizer.setEntry text
          resolve tokenizer.getSentences()

The module needs to compare the sentences of one URL to another. `compareURLs` takes two URLs as input and returns a
Promise for an array of comparison results. Each element of the array is an object containing the two sentences compared
and the similarity score (the Sørensen–Dice coefficient) from `compareStrings`.

    compareURLs = (url1, url2) ->
      result =
        url1: url1
        url2: url2
        comparisons: []
      Promise.all([extractSentences(url1), extractSentences(url2)])
      .spread (sentences1, sentences2) ->
        for sentence1 in sentences1
          for sentence2 in sentences2
            result.comparisons.push
              sentence1: sentence1
              sentence2: sentence2
              similarity: compareStrings sentence1, sentence2
        result

Public API
----------

Finally, the module exports a middleware interface to be used with an API endpoint on the server. The middleware
compares the two URLs contained in the request and sends back the comparison results.

    exports.post = (req, res) ->
      compareURLs(req.body.url1, req.body.url2).then (comparisons) ->
        res.send
          result: "success"
          comparisons: comparisons
