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
  options =
    url: 'https://api.foursquare.com/v2/users/self/checkins'
    qs:
      v: '20190401'
      oauth_token: token
      limit: 250
      offset: 0
    json: true

  promises = []
  loop
    if total == -1
      initial = await request options
      total = initial.response.checkins.count
      checkins.push ...initial.response.checkins.items
    else
      promises.push request options

    options.qs.offset += 250
    break unless options.qs.offset < total

  Promise.all promises
    .then (values) =>
      values.forEach (value) =>
        checkins.push ...value.response.checkins.items
    .then () ->
      checkins
