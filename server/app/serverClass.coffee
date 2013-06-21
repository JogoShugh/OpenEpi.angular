express = require 'express'

createServer = ->
  app = express()

  app.configure ->   
    app.use '/app', express.static('../../')
    app.use express.bodyParser()
    app.use app.router

    port = process.env.PORT || 8081

    app.listen port

  return app

module.exports = createServer