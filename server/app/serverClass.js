// Generated by CoffeeScript 1.3.3
(function() {
  var createServer, express;

  express = require('express');

  createServer = function() {
    var app;
    app = express();
    app.configure(function() {
      var port;
      app.use('/app', express["static"]('../../'));
      app.use(express.bodyParser());
      app.use(app.router);
      port = process.env.PORT || 8081;
      return app.listen(port);
    });
    return app;
  };

  module.exports = createServer;

}).call(this);
