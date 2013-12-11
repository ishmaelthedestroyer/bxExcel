uuid = require 'node-uuid'

module.exports =
  inherits: (ctor, superCtor) ->
    ctor.super_ = superCtor
    ctor:: = Object.create superCtor::,
      constructor:
        value: ctor
        enumerable: false
        writeable: true
        configurable: true

  extend: (one, two) ->
    one[k] = two[k] for k of two
    return one

  uuid: () ->
    return uuid.v1()

  random: (length) ->
    token = ''
    list = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklm' +
      'nopqrstuvwxyz0123456789'
    while token.length < length
      token += list.charAt(Math.floor(Math.random() * list.length))
    return token

  async: (fn) ->
    setTimeout ->
      fn
    , 0

  allowCrossDomain: (req, res, next) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    res.setHeader 'Access-Control-Allow-Methods', 'GET,PUT, POST,DELETE'
    res.setHeader 'Access-Control-Allow-Headers', 'Content-Type'

    next()
