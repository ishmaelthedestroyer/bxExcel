var File, Logger, log;

Logger = require('../../lib/logger');

log = new Logger;

File = require('../../app/models/File');

module.exports = {
  list: function(req, res, next) {
    log.debug('listing all files');
    return File.find({}, function(err, docs) {
      if (err) {
        res.send(500, 'Uh-oh. An error occured somewhere.');
        return false;
      }
      if (!docs) {
        res.json({});
        return false;
      }
      return res.send(docs);
    });
  },
  create: function(req, res, next) {
    log.debug('creating new file');
    return File({
      date: new Date,
      name: req.body.name || null,
      user: req.body.user || null,
      location: req.body.location || null
    }).save(function(err, doc) {
      if (err) {
        res.send(500, 'Uh-oh. An error occured somewhere.');
        return false;
      }
      return res.json(doc);
    });
  },
  find: function(req, res, next) {
    log.debug('finding one file');
    return File.findOne({
      _id: req.params.id
    }, function(err, doc) {
      if (err) {
        res.send(500, 'Uh-oh. An error occured somewhere.');
        return false;
      }
      if (!doc) {
        res.send(400, 'Uh-oh. We couldn\'t find the file.');
        return false;
      }
      return res.json(doc);
    });
  },
  update: function(req, res, next) {
    log.debug('updating one file');
    log.debug(req.body);
    return File.findOne({
      _id: req.body._id
    }, function(err, doc) {
      if (err) {
        res.send(500, 'Uh-oh. An error occured somewhere: ' + err);
        return false;
      }
      if (!doc) {
        res.send(400, 'Uh-oh. We couldn\'t find the file.');
        return false;
      }
      return File.update({
        _id: req.body._id
      }, {
        name: req.body.name || null,
        user: req.body.user || null,
        location: req.body.location || null
      }, function(err) {
        if (err) {
          res.send(500, 'Uh-oh. An error occured somewhere: ' + err);
          return false;
        }
        return res.send(200);
      });
    });
  },
  "delete": function(req, res, next) {
    log.debug('deleting one file');
    return File.find({
      _id: req.params.id
    }).remove(function(err, doc) {
      if (err) {
        res.send(500, 'Uh-oh. An error occured somewhere: ' + err);
        return false;
      }
      return res.send(200);
    });
  }
};
