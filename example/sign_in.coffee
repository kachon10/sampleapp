#sign_in example
request = require('request')
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

request.post('https://localhost:3000/v1/sign_in',
    form:
      user: "user1",
      pwd: "pwd1",
  ,
    (error, response, body) ->
      if error 
        console.log("error #{error}")
      else if response.statusCode != 200
        console.log("ErrorCode: #{response.statusCode} #{body}")
      else
        console.log("Success")
        console.log("#{JSON.stringify JSON.parse(body), null, 2}")
)