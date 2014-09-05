requirejs.config
  paths:
    "bootstrap": "vendor/bootstrap/bootstrap"
    "ember": "vendor/ember/ember"
    "handlebars": "vendor/handlebars/handlebars"
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
