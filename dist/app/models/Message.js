var Message, config, db;

config = require('../../config/app/mongo');

db = config.connect();

Message = new config.mongoose.Schema({
  date: Date,
  name: String,
  email: String,
  subject: String,
  message: String
});

module.exports = db.model('Message', Message);
