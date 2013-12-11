Logger = require '../../lib/logger'
log = new Logger

Message = require '../../app/models/Message'

module.exports =
  list: (req, res, next) ->
    log.debug 'listing all messages'
    Message.find {}, (err, docs) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere.'
        return false

      if !docs
        res.json {}
        return false

      res.send docs
  create: (req, res, next) ->
    log.debug 'creating new message'

    Message
      date: new Date
      name: req.body.name
      email: req.body.email
      message: req.body.message
    .save (err, doc) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere.'
        return false

      res.json doc

  find: (req, res, next) ->
    log.debug 'finding one message'
    Message.findOne
      _id: req.params.id
    , (err, doc) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere.'
        return false

      if !doc
        res.send 400, 'Uh-oh. We couldn\'t find the message.'
        return false

      res.json doc

  update: (req, res, next) ->
    log.debug 'updating one message'
    log.debug req.body

    Message.findOne
      _id: req.body._id
    , (err, doc) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere: ' + err
        return false

      if !doc
        res.send 400, 'Uh-oh. We couldn\'t find the message.'
        return false

      Message.update
        _id: req.body._id
      ,
        name: req.body.name
        email: req.body.email
        message: req.body.message
      , (err) ->
        if err
          res.send 500, 'Uh-oh. An error occured somewhere: ' + err
          return false

        res.send 200

  delete: (req, res, next) ->
    log.debug 'deleting one message'
    Message.find
      _id: req.params.id
    .remove (err, doc) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere: ' + err
        return false

      res.send 200
