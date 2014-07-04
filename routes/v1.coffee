express = require("express")
winston = require('winston')
Auth = require('../src/auth')
Group = require('../src/group')
Db = require('../src/db')
Files = require('../src/files')
SystemStatus = require('../src/system_status')
config = require('../config.json')

#create router
router = express.Router()

#create db obj
db = new Db(config.db)
db.init()

#create auth obj
auth = new Auth(db)

#create group obj
group = new Group(db)

#create system status obj
system_status = new SystemStatus()
system_status.start_monitor()

#create files obj
files = new Files(config.files)

send_badreq = (res, msg) ->
  res.send(
      "msg": msg
      , 
      400
    )

send_forbidden = (res, msg) ->
  res.send(
      "msg": msg
      , 
      403
    )

handle_token = (req, res, cb) ->
  if req.headers["x-token"]?
    auth.find_user_with_token(req.headers["x-token"], (user)->
      if user?
        cb(user)
      else
        send_badreq(res, "invalid token")
      )
  else
    send_badreq(res, "missing token")
  return


module.exports = (options) ->
  router.post "/sign_in", (req, res) ->
    winston.debug "#{JSON.stringify req.body, null, 2}"
    try
      auth.validate_req(req.body)
    catch e
      send_badreq(res, e)
      return

    auth.auth_user(req.body.user, req.body.pwd, (user) =>
        if user?
          res.send(
              "token": user.token
            )
        else
          send_forbidden(res, "invalid user or pwd")
      )
    return

  router.post "/sign_out", (req, res) ->
    winston.debug "#{JSON.stringify req.headers, null, 2}"
    if req.headers["x-token"]?
      auth.sign_out(req.headers["x-token"], (user)->
          if user?
            res.send {"msg": "sign out #{user}"}
          else
            send_badreq(res, "failed to sign out")
        )
    else
      send_badreq(res, "missing token")
    return

  router.get "/system_status", (req, res) ->
    handle_token(req, res, (user) ->
      res.send system_status.get_status()
    )

  router.get "/files", (req, res) ->
    handle_token(req, res, (user) ->
      folder = req.query.folder
      res.send files.get_files(folder)
    )

  router.get "/grades", (req, res) ->
    handle_token(req, res, (user) ->
      group.group_by_grade( (ret) ->
        res.send ret
        )
    )
