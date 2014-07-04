https = require("https")
http = require("http")
fs = require('fs')

debug = require("debug")("my-application")
app = require("../app")
app.set "port", process.env.PORT or 3000

options = {
  key: fs.readFileSync('./key.pem')
  cert: fs.readFileSync('./key-cert.pem')
}

server = https.createServer(options, app).listen(3000);