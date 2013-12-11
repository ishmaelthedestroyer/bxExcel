EventEmitter = require('events').EventEmitter
util = require '../../lib/util'

Logger = require '../../lib/logger'
log = new Logger

File = require '../../app/models/File'

$q = require 'q'
fs = require 'fs'

AWS = require 'aws-sdk'
awsCONFIG = require '../../config/env/aws.js'
AWS.config.update awsCONFIG
s3 = new AWS.S3()

knox = require 'knox'
client = knox.createClient
  key: awsCONFIG.accessKeyId
  secret: awsCONFIG.secretAccessKey
  bucket: awsCONFIG.bucket

MultiPartUpload = require 'knox-mpu'

options = {}

S3 = (options) ->
  if !(@ instanceof S3)
    return new S3 options

  EventEmitter.call @

  util.extend @, log
  util.inherits @, EventEmitter

  @init()

  return @



S3::init = () ->
  s3.headBucket # make sure bucket exists
    Bucket: awsCONFIG.bucket
  , (err, data) =>
    if err # bucket doesn't exist
      @debug 'S3::init() determined bucket doesn\'t exist. Installing...', err

      # create bucket if doesn't exist
      s3.createBucket
        Bucket: awsCONFIG.bucket
      , (err, data) =>
        if err # error creating bucket
          @error 'S3::init() encountered an error creating the bucket.'
          return

        # creation success
        @debug 'S3::init() successfully created the bucket: ' + awsCONFIG.bucket

    # bucket already exists
    @debug 'S3::init() determined bucket exists.'



S3::listFiles = () -> # list files in bucket
  deferred = $q.defer()

  s3.listObjects
    Bucket: awsCONFIG.bucket
  , (err, data) =>
    if err
      @error 'S3::listFiles() encountered an error listing the files.', err
      return deferred.reject err

    @debug 'S3::listFiles() got files.', data
    deferred.resolve data

  return deferred.promise



S3::listDir = () ->
  deferred = $q.defer()

  s3.listBuckets {}, (err, result) =>
    if err
      @debug.error 'An error occurred at S3::list()', err
      return deferred.reject err

    deferred.resolve result

  deferred.promise



S3::download = (stream, file) ->
  client.getFile file.name, (err, res) =>
    if err
      @error 'An error occured at S3::download()', err
      return notify 'ERROR'

    # notify res
    @debug 'Got file. Piping out to stream.'
    res.pipe(stream)

  ###
  data = ''
  client.get(file.name).on('response', (res) =>
    @debug 'Downloading from S3.',
      statusCode: res.statusCode
      headers: res.headers

    # res.setEncoding 'utf8'

    # res.setEncoding 'utf8'
    res.on 'data', (chunk) =>
      # @debug 'Got chunk.', chunk.toString()
      # data += chunk
      notify chunk #.toString()

    res.on 'end', () =>
      # notify data
      notify 'END OF STREAM'
      @debug 'END OF STREAM'
  ).end()
  ###



S3::upload = (stream, meta, notify) ->
  # @debug 'S3 got stream.'
  @debug 'S3 got stream.', meta
  filename = meta.name || util.random 10
  # filename = __dirname + '/../../tmp/' + meta.name || util.random 10
  # stream.pipe(fs.createWriteStream(filename))

  progress = 0
  stream.on 'data', (data) =>
    # calculate progress
    progress += data.length
    status = ((progress / meta.size) * 100).toFixed(2)

    if status == '100.00'
      status = 'saving...'
    else
      status += '%'

    @debug 'Progress: ' + status

    # call function to notify socket
    notify
      file: meta.id || filename
      status: status

  stream.on 'end', (data) =>
    @debug 'Stream ended.'

  upload = new MultiPartUpload
    client: client
    objectName: filename
    stream: stream
  , (err, data) =>
    if err
      @error 'An error occured at S3::upload().', err
      return

    @debug 'Finished upload.', data

    # save file
    File
      date: new Date()
      name: filename
      user: meta.user || null
      location: data.Location
      bucket: data.Bucket
      Key: data.Key
      ETag: data.ETag
      size: data.size
    .save (err) =>
      if err
        # TODO: delete file from cloud if couldn't save into db
        @error 'An error occured saving the file into the database.', err
        return false

      @debug 'Saved file into database.'

      # notify user
      notify
        file: meta.id || filename
        status: 'finished'



module.exports = S3
