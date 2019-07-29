compression = require 'compression'
express = require 'express'
moment = require 'moment'
request = require 'request-promise-native'
ical = require 'ical-generator'

app = express()
app.use compression()

app.get '/:token/json', (req, res) ->
  data = await getCheckins req.params.token
  res.json data

app.get '/:token/ics', (req, res) ->
  cal = ical
    name: 'Foursquare Check-ins'
    domain: 'checkins.foursquare.com'
    prodId:
      company: 'matthewhuie.com'
      product: 'foursquare-checkins'
    method: 'publish'
    ttl: 21600
  data = await getCheckins req.params.token
  data.forEach (checkin) =>
    event = if checkin.event? then " (#{checkin.event.name})" else ''
    name = checkin.venue.name || ''
    formattedAddress = checkin.venue.location.formattedAddress.join ', ' || ''
    if checkin.type == 'checkin' and checkin.venue?
      cal.createEvent
        start: moment.unix checkin.createdAt
        end: moment.unix checkin.createdAt
        summary: name + event
        uid: checkin.id
        geo:
          lat: checkin.venue.location.lat
          lon: checkin.venue.location.lng
        location: "#{name}, #{formattedAddress}"
        url: 'https://www.swarmapp.com/checkin/' + checkin.id

  res.type 'ics'
  res.send cal.toString()

app.use (req, res) ->
  res.sendStatus 404

app.listen process.env.PORT if process.env.PORT? and not module.parent?

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

module.exports = app
