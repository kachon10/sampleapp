require 'coffee-script/register'
Auth = require('./src/auth')
bcrypt = require('bcrypt-nodejs')
Db = require('./src/db')
config = require('./config.json')
winston = require('winston')
require('./src/initlog')(config.debug.level)

db = new Db(config.db)
db.init()
auth = new Auth(db)

task "db:seed", "Seed the database", ->
  users = [
    user: "user1",
    pwd: "pwd1",
    grade: "A"
  ,
    user: "user2",
    pwd: "pwd2",
    grade: "A"
  ,
    user: "user3",
    pwd: "pwd3",
    grade: "A"
  ,
    user: "user4",
    pwd: "pwd4",
    grade: "B"
  ,
    user: "user5",
    pwd: "pwd5",
    grade: "B"
  ,
    user: "user6",
    pwd: "pwd6",
    grade: "B"
  ]
  for user in users
    winston.debug ("Add #{user.user}")
    auth.add_user(user.user, user.pwd, user.grade, (token) ->
      winston.debug ("Add #{token}")
    )
  db.conn.end()

task "db:reset", "Reset the database to a clean development state", ->
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
  db.conn.end()
