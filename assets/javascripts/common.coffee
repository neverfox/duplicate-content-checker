requirejs.config
  paths:
    "bootstrap": "vendor/bootstrap/bootstrap"
    "ember": "vendor/ember/ember"
    "handlebars": "vendor/handlebars/handlebars"
    "ic-ajax": "vendor/ic-ajax/ic-ajax"
    "jayson": "vendor/jayson/jayson.jquery.min"
    "jquery": "vendor/jquery/jquery"
    "numeral": "vendor/numeral/numeral"
    "spin": "vendor/spin/spin"
    "toastr": "vendor/toastr/toastr"
  shim:
    "bootstrap": ["jquery"]
    "ember":
      deps: ["handlebars", "jquery"]
      exports: "Ember"
    "handlebars":
      exports: "Handlebars"
    "jayson": ["jquery"]
