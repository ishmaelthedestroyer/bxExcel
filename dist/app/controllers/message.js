var Logger, Message, log;

Logger = require('../../lib/logger');

log = new Logger;

Message = require('../../app/models/Message');

module.exports = {
  list: function(req, res, next) {
    log.debug('listing all messages');
    return Message.find({}, function(err, docs) {
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
    log.debug('creating new message');
    return Message({
      date: new Date,
      name: req.body.name,
      email: req.body.email,
      message: req.body.message
    }).save(function(err, doc) {
      if (err) {
        res.send(500, 'Uh-oh. An error occured somewhere.');
        return false;
      }
      return res.json(doc);
    });
  },
  find: function(req, res, next) {
    log.debug('finding one message');
    return Message.findOne({
      _id: req.params.id
    }, function(err, doc) {
      if (err) {
        res.send(500, 'Uh-oh. An error occured somewhere.');
        return false;
      }
      if (!doc) {
        res.send(400, 'Uh-oh. We couldn\'t find the message.');
        return false;
      }
      return res.json(doc);
    });
  },
  update: function(req, res, next) {
    log.debug('updating one message');
    log.debug(req.body);
    return Message.findOne({
      _id: req.body._id
    }, function(err, doc) {
      if (err) {
        res.send(500, 'Uh-oh. An error occured somewhere: ' + err);
        return false;
      }
      if (!doc) {
        res.send(400, 'Uh-oh. We couldn\'t find the message.');
        return false;
      }
      return Message.update({
        _id: req.body._id
      }, {
        name: req.body.name,
        email: req.body.email,
        message: req.body.message
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
    log.debug('deleting one message');
    return Message.find({
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
