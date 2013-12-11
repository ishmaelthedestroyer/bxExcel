var File, config, db;

config = require('../../config/app/mongo');

db = config.connect();

File = new config.mongoose.Schema({
  date: Date,
  name: String,
  user: String,
  location: String,
  bucket: String,
  Key: String,
  ETag: String,
  size: Number
});

module.exports = db.model('File', File);
