define (require) ->
  "use strict"

  Ember  = require "ember"
  ajax   = require "ic-ajax"
  toastr = require "toastr"

  toastr.options.positionClass = "toast-bottom-right"

  IndexController = Ember.ArrayController.extend
    url1: null
    url2: null

    actions:
      submit: ->
        @set "content", []
        toastr.success "Submitted", "Success"
        ajax.request
          url: "similarity"
          type: "POST"
          data:
            url1: @get "url1"
            url2: @get "url2"
        .then (response) =>
          toastr.success "Comparison Complete", "Success"
          @set "content", response.comparisons.comparisons
        .catch (err) ->
          toastr.error err, "Error"
