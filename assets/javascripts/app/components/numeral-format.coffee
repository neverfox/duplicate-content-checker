define (require) ->
  "use strict"
  
  Ember   = require "ember"
  numeral = require "numeral"

  NumeralFormatComponent = Ember.Component.extend
    tagName: "span"
    attributeBindings: ["format", "value"]

    willInsertElement: ->
      @setNumeral()

    updateNumeral: (->
      @setNumeral()
    ).observes "format", "value"

    setNumeral: ->
      @set "numeral", numeral(@get "value").format @get "format"
