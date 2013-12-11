module.exports = function(app) {
  var Logger, express, log;
  Logger = require('../../lib/logger');
  log = new Logger;
  express = require('express');
  app.use(express.compress({
    filter: function(req, res) {
      return /json|text|javascript|css/.test(res.getHeader('Content-Type'));
    },
    level: 9
  }));
  app.use(express["static"](__dirname + '/../../public'));
  return app.configure(function() {
    /*
    app.use express.cookieParser()
    app.use express.json()
    app.use express.urlencoded()
    app.use express.methodOverride()
    
    # sessions w/ redis + passport
    app.use express.session
      store: redisCONFIG.sessionStore
      secret: redisCONFIG.secret
      cookie: redisCONFIG.cookie
    
    # authenticate with passport
    app.use passport.initialize()
    app.use passport.session()
    */

    return app.use(app.router);
  });
};
