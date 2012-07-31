// [https://github.com/uxalytics/mocking-server/blob/master/uiautomation/mocking-client.js]
mocking_server = {
  SERVER_URL: null,
  EXTRA_CURL_FLAGS: [],
  assert_then_clear_http_expectations: function(opt) {
    var info = mocking_server._api('/clear-expectations', {});
    if (
          (info.unmet_expectations.length == 0) &&
          (info.unexpected_requests.length == 0)) {
    
    }
    else {
      if (opt.error) {
        opt.error(info);
      }
    }
  },
  _api: function(path, params) {
    var args = JSON.parse(JSON.stringify(mocking_server.EXTRA_CURL_FLAGS));
    args.push('--silent');
    args.push('-H', 'X-Mocking-Server: API');
    args.push('-d', JSON.stringify(params));
    args.push(mocking_server.SERVER_URL + path);
    var host = UIATarget.localTarget().host();
    var result = host.performTaskWithPathArgumentsTimeout("/usr/bin/curl", args, 4);
    return JSON.parse(result.stdout);
  },
  _mock_request_with_method: function(params, method) {
    var params2 = JSON.parse(JSON.stringify(params));
    params2['method'] = method;
    mocking_server._api('/mock', params2);
  }
};
mock_get =      function(params) {mocking_server._mock_request_with_method(params, 'GET');};
mock_post =     function(params) {mocking_server._mock_request_with_method(params, 'POST');};
mock_put =      function(params) {mocking_server._mock_request_with_method(params, 'PUT');};
mock_delete =   function(params) {mocking_server._mock_request_with_method(params, 'DELETE');};
// [/ https://github.com/uxalytics/mocking-server/blob/master/uiautomation/mocking-client.js]
