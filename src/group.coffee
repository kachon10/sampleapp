mysql = require('mysql')
winston = require('winston')

# class to group user
class Group 
  constructor: (@db) ->

  group_by_grade: (cb) ->
    query = "select * from user"
    @db.conn.query(query, (err, rows, fields) ->
      if err
        winston.debug "group_by_grade callback #{err}"
        cb(null)
      else
        ret = {}
        for r in rows
          if r.grade not of ret
            ret[r.grade] = []
          ret[r.grade].push(r.user)
        cb(ret)
    )

module.exports = Group