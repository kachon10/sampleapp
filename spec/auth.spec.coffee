Auth = require('../src/auth')
bcrypt = require('bcrypt-nodejs')
Db = require('../src/db')
config = require('../configut.json')
winston = require('winston')
require('../src/initlog')(config.debug.level)

db = new Db(config.db)
db.init()
auth = new Auth(db)

describe "Auth Test", ->

  it "should throw with invalid input", ->
    expect( ->
      auth.validate_req( {} )
      ).toThrow()
    expect( ->
      auth.validate_req( {"user": "user1"} )
      ).toThrow()
    expect( ->
      auth.validate_req( {"pwd": "pwd1"} ) 
      ).toThrow()

  it "should not throw with valid input", ->
    expect( ->
      auth.validate_req( {"user": "user1", "pwd": "pwd1"} )
      ).not.toThrow()

  it "should convert pwd to hash", ->
    key = 'hello'
    hash = auth._convert_pwd_to_hash(key)
    expect(bcrypt.compareSync(key, hash)).toBe(true)

  it "should compare pwd to hash", ->
    key = 'hello'
    hash = auth._convert_pwd_to_hash(key)
    expect(auth._compare_pwd_with_hash(key, hash)).toBe(true)

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

  it "should be able to add user", ->
    user = "user1"
    pwd = "hash1"
    grade = "A"
    auth.add_user(user, pwd, grade, (token) ->
      winston.debug ("got token #{token}")
      )

  it "should be able to auth user", ->
    got_resp = false
    got_user = false

    auth.auth_user("user1", "hash1", (user) ->
        if user
          got_user = true

        got_resp = true
      )
    waitsFor(()->
      if got_resp
        return true
      else
        return false
    ,"Timeout waiting", 7500)
    runs( ->
        expect(got_user).toBe(true)
      )

  it "should be able to find user with token", ->
    got_resp = false
    got_user = false
    got_token = false

    user = "user2"
    pwd = "hash2"
    grade = "A"
    auth.add_user(user, pwd, grade, (token) ->
      auth.find_user_with_token(token, (user) =>
          if user
            got_user = true

          got_resp = true
        )
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

  it "should be able to update user with token", ->
    got_resp = false
    got_user = false
    got_token = false

    user = "user3"
    pwd = "hash3"
    grade = "A"
    auth.add_user(user, pwd, grade, (token) =>
      winston.debug "1 user: #{user}"
      auth._update_user_token(user, (user) =>
        winston.debug "2 user: #{user}"
        auth.find_user_with_token(token, (user) =>
          winston.debug "3 user: #{user}"
          if user
            got_user = true

          got_resp = true
          )
        )
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
        expect(got_user).toBe(false)
      )

  it "should have terminate the db", ->
    expect(->
      db.end()
      ).not.toThrow()
