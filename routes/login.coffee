express = require("express")
router = express.Router()

router.post "/", (req, res) ->
  console.log 'Got post'
  console.log "#{JSON.stringify req.body}"
  console.log req.body.abc
  res.send "respond with a resource"
  return

module.exports = router