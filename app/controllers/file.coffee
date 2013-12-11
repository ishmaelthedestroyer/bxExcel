Logger = require '../../lib/logger'
log = new Logger

File = require '../../app/models/File'

module.exports =
  list: (req, res, next) ->
    log.debug 'listing all files'
    File.find {}, (err, docs) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere.'
        return false

      if !docs
        res.json {}
        return false

      res.send docs
  create: (req, res, next) ->
    log.debug 'creating new file'

    File
      date: new Date
      name: req.body.name || null
      user: req.body.user || null
      location: req.body.location || null
    .save (err, doc) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere.'
        return false

      res.json doc

  find: (req, res, next) ->
    log.debug 'finding one file'
    File.findOne
      _id: req.params.id
    , (err, doc) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere.'
        return false

      if !doc
        res.send 400, 'Uh-oh. We couldn\'t find the file.'
        return false

      res.json doc

  update: (req, res, next) ->
    log.debug 'updating one file'
    log.debug req.body

    File.findOne
      _id: req.body._id
    , (err, doc) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere: ' + err
        return false

      if !doc
        res.send 400, 'Uh-oh. We couldn\'t find the file.'
        return false

      File.update
        _id: req.body._id
      ,
        name: req.body.name || null
        user: req.body.user || null
        location: req.body.location || null
      , (err) ->
        if err
          res.send 500, 'Uh-oh. An error occured somewhere: ' + err
          return false

        res.send 200

  delete: (req, res, next) ->
    log.debug 'deleting one file'
    File.find
      _id: req.params.id
    .remove (err, doc) ->
      if err
        res.send 500, 'Uh-oh. An error occured somewhere: ' + err
        return false

      res.send 200
