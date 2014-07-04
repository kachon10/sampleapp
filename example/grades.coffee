#grouping example
#get grades
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
        #get grades
        request.get('https://localhost:3000/v1/grades',
            headers:
              "x-token": token
            ,
            qs:
              country: "country_a"
          ,
            (error, response, body) ->
              if error 
                console.log("error #{error}")
              else if response.statusCode != 200
                console.log("ErrorCode: #{response.statusCode} #{body}")
              else
                console.log("Get grades success")
                console.log("#{JSON.stringify JSON.parse(body), null, 2}")
          )
  )