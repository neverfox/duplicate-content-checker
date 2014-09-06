express      = require "express"

bodyParser   = require "body-parser"
compression  = require "compression"
cookieParser = require "cookie-parser"
engines      = require "consolidate"
errorHandler = require "errorhandler"
favicon      = require "serve-favicon"

similarity = require "./similarity"

exports.startServer = (config, callback) ->
  app = express()

  # setup views and port
  app.set "views", config.server.views.path
  app.engine config.server.views.extension, engines[config.server.views.compileWith]
  app.set "view engine", config.server.views.extension
  app.set "port", process.env.PORT or config.server.port or 3000

  # middleware
  app.use compression()
  # uncomment and point path at favicon if you have one
  # app.use favicon "path to fav icon"
  app.use bodyParser.json()
  app.use bodyParser.urlencoded {extended: true}
  app.use cookieParser()
  app.use express.static config.watch.compiledDir
  if app.get("env") isnt "production"
    app.use errorHandler dumpExceptions: on
  else
    app.use errorHandler()

  routeOptions =
    reload:    config.liveReload.enabled
    optimize:  config.isOptimize ? false
    cachebust: if process.env.NODE_ENV isnt "production" then "?b=#{(new Date()).getTime()}" else ""

  router = express.Router()
  router.get "/", (req, res) ->
    res.render "index", routeOptions

  # routes
  app.use "/", router

  app.post "/similarity", similarity.post

  # start it up
  server = app.listen app.get("port"), ->
    console.log "Express server listening on port " + app.get "port"

  callback server
