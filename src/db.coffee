mysql = require('mysql')
winston = require('winston')

#class to provide db connection
class Db
  constructor: (@config) ->

  init: (cb) ->
    @conn = mysql.createConnection(
        host: @config.host,
        user: @config.user,
        password: @config.password,
        port: @config.port,
        database: @config.database
      )
    @conn.connect( (err) => 
      if not err
        winston.debug("connect database #{@conn.threadId}")

      if cb
        cb(err)
      )

  conn: ->
    @conn

  end: () ->
    @conn.end()

  test: () ->
    @conn.query("SELECT COUNT(*) from user", (err, rows, fields) ->
        console.log "#{err}"
        console.log "#{JSON.stringify rows, null, 2}"
      )

module.exports = Db