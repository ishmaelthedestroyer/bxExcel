var uuid;

uuid = require('node-uuid');

module.exports = {
  inherits: function(ctor, superCtor) {
    ctor.super_ = superCtor;
    return ctor.prototype = Object.create(superCtor.prototype, {
      constructor: {
        value: ctor,
        enumerable: false,
        writeable: true,
        configurable: true
      }
    });
  },
  extend: function(one, two) {
    var k;
    for (k in two) {
      one[k] = two[k];
    }
    return one;
  },
  uuid: function() {
    return uuid.v1();
  },
  random: function(length) {
    var list, token;
    token = '';
    list = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklm' + 'nopqrstuvwxyz0123456789';
    while (token.length < length) {
      token += list.charAt(Math.floor(Math.random() * list.length));
    }
    return token;
  },
  async: function(fn) {
    return setTimeout(function() {
      return fn;
    }, 0);
  },
  allowCrossDomain: function(req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET,PUT, POST,DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    return next();
  }
};
