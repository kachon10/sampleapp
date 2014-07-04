mysql = require('mysql')
winston = require('winston')

# class to group user
class Group 
  constructor: (@db) ->

  validate_req: (data) ->
    if data.country?
      return 
    else 
      throw "Missing parameters"

  group_by_grade: (country_filter, cb) ->
    query = "select group_concat(user) as user, grade from user where country = '#{country_filter}' group by grade"
    @db.conn.query(query, (err, rows, fields) ->
      if err
        cb(null)
      else
        ret = {}
        for r in rows
          ret[r.grade] = r.user.split(",")
        cb(ret)
    )

module.exports = Group