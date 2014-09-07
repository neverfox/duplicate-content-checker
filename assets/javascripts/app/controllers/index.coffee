define (require) ->
  "use strict"

  Ember  = require "ember"
  ajax   = require "ic-ajax"
  toastr = require "toastr"

  IndexController = Ember.ArrayController.extend
    url1: "http://www.fastmed.com/health-resources/related-searches/looking-for-asheville-medical-clinic"
    url2: "http://www.fastmed.com/health-resources/related-searches/need-a-burlington-medical-clinic"

    sortProperties: ["similarity"]
    sortAscending: false

    avgSimilarity: (->
      @getEach("similarity").reduce (p, c, i) ->
        p + (c - p) / (i + 1)
      , 0
    ).property "@each.similarity"

    perfect: Ember.computed.filterBy "content", "similarity", 1
    perfectCount: Ember.computed.alias "perfect.length"

    actions:
      submit: ->
        @set "content", []
        toastr.options.positionClass = "toast-bottom-right"
        toastr.success "Processing result...", "URLs Submitted"
        ajax.request
          url: "similarity"
          type: "POST"
          data:
            url1: @get "url1"
            url2: @get "url2"
        .then (response) =>
          toastr.options.positionClass = "toast-bottom-right"
          toastr.success "Comparison Complete", "Success!"
          @set "content", response.comparisons.comparisons
        .catch (err) ->
          toastr.error err, "Error"
