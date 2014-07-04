Auth = require('../src/auth')
Group = require('../src/group')
Db = require('../src/db')
config = require('../configut.json')
winston = require('winston')
require('../src/initlog')(config.debug.level)

db = new Db(config.db)
db.init()
auth = new Auth(db)
group = new Group(db)

describe "Group Test", ->

  it "should be able to add table", ->
    db.conn.query("DROP table user;", (err, rows, fields) ->
      winston.debug "DROP table callback #{err}"
      )
    db.conn.query("CREATE table user (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
                                      user VARCHAR(20), 
                                      pwd_hash VARCHAR(128),
                                      token VARCHAR(128),
                                      grade VARCHAR(1));", (err, rows, fields) ->
      winston.debug "CREATE table callback #{err}"
      )

  it "should group with grade", ->
    got_resp = false
    got_user = false
    user = "user1"
    pwd = "hash1"
    grade = "A"
    auth.add_user(user, pwd, grade, (token) ->
      winston.debug ("got token #{token}")
      )

    user = "user2"
    pwd = "hash1"
    grade = "A"
    auth.add_user(user, pwd, grade, (token) ->
      winston.debug ("got token #{token}")
      )

    user = "user3"
    pwd = "hash1"
    grade = "B"
    auth.add_user(user, pwd, grade, (token) ->
      winston.debug ("got token #{token}")
      )

    user = "user4"
    pwd = "hash1"
    grade = "B"
    auth.add_user(user, pwd, grade, (token) ->
      winston.debug ("got token #{token}")
      )

    group.group_by_grade( (ret) ->
      winston.debug ("got ret #{JSON.stringify ret, null, 2}")
      if 'A' of ret and 'B' of ret
        if ret.A.length == 2 and ret.B.length
          got_user = true

      got_resp = true   
      )

    waitsFor(->
        if got_resp
          return true
        else
          return false
      ,
        "Timeout waiting"
      , 7500
      )
    runs( ->
        expect(got_user).toBe(true)
      )

  it "should have terminate the db", ->
    expect(->
      db.end()
      ).not.toThrow()