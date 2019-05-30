# API Endpoints for Foursquare Check-ins
This application provides API endpoints for Foursquare check-ins.  It can be deployed to Heroku, Google App Engine, AWS Elastic Beanstalk, or any Node.js-compatible PaaS.  This was written in CoffeeScript for Node.js.

## Getting Started
Simply deploy this repo to your PaaS of choice.

## API Endpoints
To use any of the available API endpoints, you will need to pass in a Foursquare OAuth token.  It is highly recommended that these endpoints are exposed securely via HTTPS to ensure that OAuth credentials aren't sent in plaintext.

**GET /OAUTH_TOKEN/json**

Returns a JSON array of Foursquare check-ins for the specified user.

**GET /OAUTH_TOKEN/ics**

Returns an iCal-standard (RFC 5545) output of Foursquare check-ins for the specified user.  This output can be imported into calendar apps like Google Calendar.

## TODO
- [x] getCheckins via Foursquare API
- [x] getCheckins using Promises
- [ ] getCheckins as Express middleware
- [x] JSON implementation
- [x] iCal implementation
- [ ] Memcache support
- [ ] Google Cloud Functions (or AWS Lambda) support
- [ ] Rethink security of using tokens via HTTPS URL

## Links
- https://foursquare.com
- https://developer.foursquare.com/docs/api/checkins/details
