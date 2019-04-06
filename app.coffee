express = require 'express'
request = require 'request-promise-native'
app = express()

app.get '/:token/json', (req, res) ->
  data = await getCheckins req.params.token
  res.json data

app.use (req, res) ->
  res.sendStatus 404

app.listen process.env.PORT or 8080

getCheckins = (token) ->
  total = -1
  checkins = []
  qs =
    v: '20190401'
    oauth_token: token
    limit: 250
    offset: 0

  loop
    data = await request
      url: 'https://api.foursquare.com/v2/users/self/checkins'
      qs: qs

    checkins.push ...JSON.parse(data).response.checkins.items
    total = JSON.parse(data).response.checkins.count if total == -1
    qs.offset += 250
    break unless qs.offset < total

  checkins
