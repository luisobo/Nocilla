{MockingServer} = require 'mocking-server'

server = new MockingServer
server.httpsListen {
  key_path: "#{__dirname}/ssl/theshopkeep_events.key"
  cert_path: "#{__dirname}/ssl/theshopkeep_events.cert"
  port: 12001
}, (e) ->

console.log 'activated!'