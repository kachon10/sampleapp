#files example
#get files under subdir1
request = require('request')
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

#sign in
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
        console.log("Sign in success: #{body}")
        #get token
        token = JSON.parse(body).token
        console.log("#{token}")
        #get files
        request.get('https://localhost:3000/v1/files',
            qs:
              folder: "subdir1"
            ,
            headers:
              "x-token": token
          ,
            (error, response, body) ->
              if error 
                console.log("error #{error}")
              else if response.statusCode != 200
                console.log("ErrorCode: #{response.statusCode} #{body}")
              else
                console.log("Get system status success")
                console.log("#{JSON.stringify JSON.parse(body), null, 2}")
          )
  )