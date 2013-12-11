var Logger, app, appCONFIG, argv, express, log, port;

argv = require('optimist').argv;

if ((argv.environment != null) && argv.environment === 'production') {
  process.env.NODE_ENV = 'production';
} else {
  process.env.NODE_ENV = 'development';
}

Logger = require('./lib/logger');

log = new Logger;

express = require('express');

app = express();

require('./config/app/express')(app);

require('./config/app/routes')(app);

app.get('*', function(req, res) {
  return res.sendfile(__dirname + '/public/index.html');
});

/*
server = require('http').createServer app
# bootstrap socket.io
io = require('./config/app/io') server
require('./app/controllers/socket') io
*/


appCONFIG = require('./config/env/app');

port = process.env.PORT || appCONFIG.port || 3000;

app.listen(port);

log.debug(appCONFIG.name + ' listening on port ' + port + ' (' + process.env.NODE_ENV + ').');
