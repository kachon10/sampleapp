bcrypt = require('bcrypt-nodejs')
mysql = require('mysql')
winston = require('winston')
uuid = require('node-uuid')

# class to provide authenication
class Auth 
  constructor: (@db) ->

  validate_req: (data) ->
    if data.user? and data.pwd?
      return 
    else 
      throw "Missing parameters"

  _convert_pwd_to_hash: (input) ->
    return bcrypt.hashSync(input)

  _compare_pwd_with_hash: (pwd, hash) ->
    try
      return bcrypt.compareSync(pwd, hash)
    catch error
      return false

  _get_new_token: ->
    return uuid.v4()

  _find_user: (user, cb) ->
    query = "select * from user where user = '#{user}'"
    winston.debug "_find_user query #{@db} #{@db.conn}"

    try
      @db.conn.query(query, (err, rows, fields) ->
        if err
          winston.debug "_find_user query err #{err}"
        if rows.length > 0
            cb(rows[0])
            return
        return cb(null)
      )
    catch error
      winston.debug "_find_user exception #{error}"
      cb(null)

  _update_user_token: (user, cb) ->
    token = @_get_new_token()
    query = "update user set token = \"#{token}\" where user = \"#{user}\""
    winston.debug "query #{query}"
    try
      @db.conn.query(query, (err, rows, fields) =>
        if err
          winston.debug "_update_user_token query err #{err}"
          cb(null)
          return
        else
          cb(token)
          return
      )
    catch error
      winston.debug "_update_user_token exception #{error}"
      cb(null)

  add_user: (user, pwd, country, grade, cb) ->
    hash = @_convert_pwd_to_hash(pwd)
    token = @_get_new_token()
    query = "INSERT INTO `user` (`id`,`user`,`pwd_hash`, `token`, `country`, `grade`) \
              VALUES (NULL, \"#{user}\", \"#{hash}\", \"#{token}\", \"#{country}\", \"#{grade}\")"
    @db.conn.query(query, (err, rows, fields) ->
      if err
        winston.debug "_add_user callback #{err}"
        cb(null)
      else
        cb(token)
    )

  find_user_with_token: (token, cb) ->
    query = "select * from user where token = '#{token}'"
    @db.conn.query(query, (err, rows, fields) ->
      if err
        winston.debug "_find_user_with_token callback #{err}"
      if rows.length > 0
          cb(rows[0])
          return
      return cb(null)
    )

  auth_user: (user, pwd, cb) =>
    winston.debug "auth_user #{user} #{pwd}"
    @_find_user user, (user) =>
      if user
        winston.debug "user found #{pwd} #{user.pwd_hash}"
        if @_compare_pwd_with_hash(pwd, user.pwd_hash)
          winston.debug "user hash match"
          cb(user)
        else 
          winston.debug "user hash not match"
          cb(null)
      else
        winston.debug "not found"
        cb(null)

  sign_out: (token, cb) ->
    winston.debug "sign_out #{token}"
    if token?
      @find_user_with_token(token, (user) =>
          if user?
            @_update_user_token(user.user, (token) =>
                winston.debug "sign_out new token #{token}"
                cb(user.user)
              )
          else
            cb(null)
        )
    else
      cb(null)



module.exports = Auth
