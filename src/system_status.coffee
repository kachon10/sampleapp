mysql = require('mysql')
winston = require('winston')
config = require('../config.json')
Db = require('../src/db')

class SystemStatus
  constructor: ->
    @status = {}
    @db_monitor = null

  get_status: ->
    return @status

  start_monitor: ->
    winston.debug "start_monitor"
    @db_monitor = setInterval(@_get_db_status, 1000)

  stop_monitor: ->
    if @db_monitor?
      clearInterval(@db_monitor)
      @db_monitor = null

  _get_db_status: =>
    db = new Db(config.db)
    db.init( (err) =>
      if err
        @status.db = 
          "status": "error"
          "msg": "failed to connect to db"
      else
        @status.db = 
          "status": "ok"
          "msg" : ""
      db.conn.end()
    )

module.exports = SystemStatus