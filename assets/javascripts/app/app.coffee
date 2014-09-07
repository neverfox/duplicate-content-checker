define (require) ->
  "use strict"

  Ember = require "ember"

  Ember.LOG_BINDINGS = true
  Ember.ENV =
    HELPER_PARAM_LOOKUPS: true

  App = window.App = Ember.Application.create
    LOG_TRANSITIONS: true
    LOG_TRANSITIONS_INTERNAL: true
    LOG_VIEW_LOOKUPS: true
    LOG_ACTIVE_GENERATION: true

    rootElement: "#applicationHost"

    # Controllers
    IndexController: require "app/controllers/index"

    # Models

    # Routes

    # Views

    # Components
    NumeralFormatComponent: require "app/components/numeral-format"

    # Mixins
