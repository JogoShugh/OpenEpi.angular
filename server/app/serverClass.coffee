express = require 'express'
fs = require 'fs'

createServer = ->
  app = express()

  app.configure ->   
    app.use '/app', express.static('../../')
    app.use express.bodyParser()
    app.use app.router

    port = process.env.PORT || 8081

    app.listen port

  app.get '/modules', (req, res) ->
    dir = __dirname + '/../../js/modules/'
    files = fs.readdirSync dir
    for file in files
      stat = fs.statSync dir + file
      console.log file if stat.isDirectory()
      #entry = JSON.parse fs.readFileSync('./examples/' + file, 'utf8')    

    res.send 'some data'    

  return app

module.exports = createServer