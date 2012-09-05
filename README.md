# Nocilla
Stunning HTTP stubbing for iOS ans OS X. Testing HTTP requests has never been easier.

This library was inspired by [WebMock](https://github.com/bblimke/webmock) and is using [this approach](http://www.infinite-loop.dk/blog/2011/09/using-nsurlprotocol-for-injecting-test-data/) to stub the requests.

## Features
* Stub HTTP and HTTPS requests in your unit tests.
* Awesome DSL that will improve the readability and maintainability of your tests.
* Tested.
* Fast.
* Extendable to support more HTTP libraries.
* Huge community, we overflowed the number of Stars and Forks in GitHub (meh, not really).

## Limitations
* At this moment only works with request made with `NSURLConnection`, but it's possible to extend Nocilla to support more HTTP libraries. Nocilla has been tested with [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [MKNetworkKit](https://github.com/MugunthKumar/MKNetworkKit)

## Installation

## Usage
The following examples are describe using [Kiwi](https://github.com/allending/Kiwi)

#### Common parts
Until Nocilla can hook directly into Kiwi, you will have to include the following snippet in the specs that you want to stub HTTP requests:

<pre><code>#import "Kiwi.h"
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
  ...
});
SPEC_END
</code></pre>

#### Stubbing a simple request
It will return the default response, which is a 200 and an empty body

```objc
stubRequest(@"GET", @"http://www.google.com");
```

#### Stubbing a request with a particular header

```objc
stubRequest(@"GET", @"https://api.example.com").
withHeader(@"Accept", @"application/json");
```

#### Stubbing a request with multiple headers

Using the `withHeaders` method make sense with the new Objective-C literals, but it accepts an NSDictionary.

```objc
stubRequest(@"GET", @"https://api.example.com/dogs.json").
withHeaders(@{@"Accept": @"application/json", @"X-CUSTOM-HEADER": @"abcf2fbc6abgf"});
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

## Other alternatives
* [ILTesting](https://github.com/InfiniteLoopDK/ILTesting)
* [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs)

## Contributing

1. Fork it
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create new Pull Request