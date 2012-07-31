
## Running the server

    {MockingServer} = require 'mocking-server'

    server = new MockingServer
    server.httpsListen {
      key: fs.readFileSync "#{__dirname}/ssl/foo.com.key"
      cert: fs.readFileSync "#{__dirname}/ssl/foo.com.cert"
      port: 12001
    }, (e) ->

You can `httpsListen` multiple `(key, cert, port)` triples at once.


## API

    Required header:
      X-Mocking-Server: API

    POST /mock
    req: {...}
    res: {}

    POST /clear-expectations
    req: {}
    res: {
      unmet_expectations: []
      unexpected_requests: []
      message: "..."
    }


## Properties

    method
    url           # If the hostname is specified, it must match exactly
                  # If the (pathname + querystring) is specified, it must match exactly
    req_body      # Exact match
    req_headers   # Exact match apart from ignoring Content-Length

    code          # default: 200
    res_headers   # Content-Length will always be added
    res_body      # default: empty string


## UIAutomation integration example

    // in your helper.js
    #import "node_modules/mocking-server/uiautomation/mocking-client.js"
    mocking_server.SERVER_URL = "https://mocking-server.theshopkeep.com";
    mocking_server.EXTRA_CURL_FLAGS = ['--insecure', '-x', '127.0.0.1:8888'];

    // in your test abstraction, after the test runs
    assert_then_clear_http_expectations({
      error: function(e) {
        UIALogger.logFail(e.message);
        // handle the failure in your framework-specific way
      }
    })

    // in some test
    mock_post({
      url: "skynet.mil/activate",
      req_headers: {
        'Content-Type': 'application/json'
      },
      req_body: "{}"
    });
    target.frontMostApp().mainWindow().buttons()["Don't Click This!"].tap();
