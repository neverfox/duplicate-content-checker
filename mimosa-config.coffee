exports.config =
  "modules": [
    "bower"
    "coffeelint"
    "coffeescript"
    "copy"
    "emblem"
    "fix-rjs-ember"
    "handlebars-on-window"
    "less"
    "live-reload"
    "minify-css"
    "minify-js"
    "require"
    "server"
    "server-reload"
    "stylus"
    "web-package"
  ]

  bower:
    copy:
      mainOverrides:
        "bootstrap-stylus": [
          "fonts": "../../fonts"
          "js": "bootstrap"
          "stylus": "bootstrap"
        ]
        "footable": [
          "js/footable.js"
          "js/footable.sort.js"
          "js/footable.paginate.js"
          "css/footable.core.css"
          "css/footable.standalone.css"
          "css/footable.metro.css"
          "css/fonts": "footable/fonts"
        ]
        "spin.js": ["spin.js": "spin/spin.js"]
        "toastr-stylus": [
          "stylus": "toastr"
          "toastr.js": "toastr/toastr.js"
        ]

  coffeelint:
    rules:
      "max_line_length":
        value: 150

  emblem:
    helpers: ["app/templates/handlebars-helpers"]
    emberPath: "ember"

  serverReload:
    watch: ["server.coffee"]

  template:
    nameTransform: (path) ->
      m = path.match /templates?\/(.*)$/
      if m?.length and m.length == 2
        return m[1]
      path = path.split '/'
      return path[path.length - 1]

  webPackage:
    archiveName: null
    exclude: [
      ".git"
      ".mimosa"
      "assets"
      "generators"
      "node_modules"
      ".gitignore"
      "README.md"
      "bower.json"
      "makefile"
      "mimosa-config.coffee"
      "mimosa-config-documented.coffee"
      "three-ships.sublime-project"
      "three-ships.sublime-workspace"
      "test.sh"
    ]
