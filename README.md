# Nocilla [![](https://api.travis-ci.org/luisobo/Nocilla.png?branch=master)](https://travis-ci.org/luisobo/Nocilla)
Stunning HTTP stubbing for iOS and OS X. Testing HTTP requests has never been easier.

This library was inspired by [WebMock](https://github.com/bblimke/webmock) and it's using [this approach](http://www.infinite-loop.dk/blog/2011/09/using-nsurlprotocol-for-injecting-test-data/) to stub the requests.

## Features
* Stub HTTP and HTTPS requests in your unit tests.
* Supports NSURLConnection, NSURLSession and ASIHTTPRequest.
* Awesome DSL that will improve the readability and maintainability of your tests.
* Match requests with regular expressions.
* Stub requests with errors.
* Tested.
* Fast.
* Extendable to support more HTTP libraries.

```ruby
pod 'Nocilla', :podspec => 'https://raw.github.com/luisobo/Nocilla/master/Nocilla.podspec'
```

```objc
[[LSNocilla sharedInstance] registerHook:[[LSASIHTTPRequestHook alloc] init]];
[[LSNocilla sharedInstance] start];
```

## Installation
### As a [CocoaPod](http://cocoapods.org/)
Just add this to your Podfile
```ruby
pod 'Nocilla'
```

### Other approaches
* You should be able to add Nocilla to you source tree. If you are using git, consider using a `git submodule`

## Usage
_Yes, the following code is valid Objective-C, or at least, it should be_

The following examples are described using [Kiwi](https://github.com/allending/Kiwi)

### Common parts
Until Nocilla can hook directly into Kiwi, you will have to include the following snippet in the specs you want to use Nocilla:

```objc
#import "Kiwi.h"
#import "Nocilla.h"
SPEC_BEGIN(ExampleSpec)
beforeAll(^{
  [[LSNocilla sharedInstance] start];
});
afterAll(^{
  [[LSNocilla sharedInstance] stop];
});
afterEach(^{
  [[LSNocilla sharedInstance] clearStubs];
});

it(@"should do something", ^{
  // Stub here!
});
SPEC_END
```

### Stubbing requests
#### Stubbing a simple request
It will return the default response, which is a 200 and an empty body.

```objc
stubRequest(@"GET", @"http://www.google.com");
```

#### Stubbing requests with regular expressions
```objc
stubRequest(@"GET", @"^http://(.*?)\\.example\\.com/v1/dogs\\.json".regex);
```


#### Stubbing a request with a particular header

```objc
stubRequest(@"GET", @"https://api.example.com").
withHeader(@"Accept", @"application/json");
```

#### Stubbing a request with multiple headers

Using the `withHeaders` method makes sense with the Objective-C literals, but it accepts an NSDictionary.

```objc
stubRequest(@"GET", @"https://api.example.com/dogs.json").
withHeaders(@{@"Accept": @"application/json", @"X-CUSTOM-HEADER": @"abcf2fbc6abgf"});
```

#### Stubbing a request with a particular body

```objc
stubRequest(@"POST", @"https://api.example.com/dogs.json").
withHeaders(@{@"Accept": @"application/json", @"X-CUSTOM-HEADER": @"abcf2fbc6abgf"}).
withBody(@"{\"name\":\"foo\"}");
```

You can also use `NSData` for the request body:

```objc
stubRequest(@"POST", @"https://api.example.com/dogs.json").
withHeaders(@{@"Accept": @"application/json", @"X-CUSTOM-HEADER": @"abcf2fbc6abgf"}).
withBody([@"foo" dataUsingEncoding:NSUTF8StringEncoding]);
```

#### Returning a specific status code
```objc
stubRequest(@"GET", @"http://www.google.com").andReturn(404);
```

#### Returning a specific status code and header
The same approch here, you can use `withHeader` or `withHeaders`

```objc
stubRequest(@"POST", @"https://api.example.com/dogs.json").
andReturn(201).
withHeaders(@{@"Content-Type": @"application/json"});
```

#### Returning a specific status code, headers and body
```objc
stubRequest(@"GET", @"https://api.example.com/dogs.json").
andReturn(201).
withHeaders(@{@"Content-Type": @"application/json"}).
withBody(@"{\"ok\":true}");
```

#### Returning a specific status code and body from a file inside of test bundle
```objc
stubRequest(@"GET", @"https://api.example.com/dogs.json").
andReturn(201).
withHeaders(@{@"Content-Type": @"application/json"}).
withBodyFile(@"content.json");
```

You can also use `NSData` for the response body:

```objc
stubRequest(@"GET", @"https://api.example.com/dogs.json").
andReturn(201).
withHeaders(@{@"Content-Type": @"application/json"}).
withBody([@"bar" dataUsingEncoding:NSUTF8StringEncoding]);
```

#### Returning raw responses recorded with `curl -is`
`curl -is http://api.example.com/dogs.json > /tmp/example_curl_-is_output.txt`

```objc
stubRequest(@"GET", @"https://api.example.com/dogs.json").
andReturnRawResponse([NSData dataWithContentsOfFile:@"/tmp/example_curl_-is_output.txt"]);
```

#### All together
```objc
stubRequest(@"POST", @"https://api.example.com/dogs.json").
withHeaders(@{@"Accept": @"application/json", @"X-CUSTOM-HEADER": @"abcf2fbc6abgf"}).
withBody(@"{\"name\":\"foo\"}").
andReturn(201).
withHeaders(@{@"Content-Type": @"application/json"}).
withBody(@"{\"ok\":true}");
```

#### Making a request fail
This will call the failure handler (callback, delegate... whatever your HTTP client uses) with the specified error.

```objc
stubRequest(@"POST", @"https://api.example.com/dogs.json").
withHeaders(@{@"Accept": @"application/json", @"X-CUSTOM-HEADER": @"abcf2fbc6abgf"}).
withBody(@"{\"name\":\"foo\"}").
andFailWithError([NSError errorWithDomain:@"foo" code:123 userInfo:nil]);
```

### Unexpected requests
If some request is made but it wasn't stubbed, Nocilla won't let that request hit the real world. In that case your test should fail.
At this moment Nocilla will raise an exception with a meaningful message about the error and how to solve it, including a snippet of code on how to stub the unexpected request.

## Other alternatives
* [ILTesting](https://github.com/InfiniteLoopDK/ILTesting)
* [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs)

## Contributing

1. Fork it
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create new Pull Request
