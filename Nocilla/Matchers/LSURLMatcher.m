//
//  LSURLMatcher.m
//  Nocilla
//
//  Created by Nick Lockwood on 16/01/2017.
//  Copyright © 2017 Luis Solano Bonet. All rights reserved.
//

#import "LSURLMatcher.h"

@interface LSURLMatcher ()

@property (nonatomic, copy) NSURL *url;

@end

@implementation LSURLMatcher

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];

    if (self) {
        _url = url;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (BOOL)matchesURL:(NSURL *)otherURL {
    // Sort the query items alphabetically
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.url resolvingAgainstBaseURL:YES];
    components.queryItems = [components.queryItems sortedArrayUsingComparator:^NSComparisonResult(NSURLQueryItem *a, NSURLQueryItem *b) {
        return [a.name compare:b.name];
    }];
    NSURLComponents *otherComponents = [NSURLComponents componentsWithURL:otherURL resolvingAgainstBaseURL:YES];
    otherComponents.queryItems = [otherComponents.queryItems sortedArrayUsingComparator:^NSComparisonResult(NSURLQueryItem *a, NSURLQueryItem *b) {
        return [a.name compare:b.name];
    }];
    // Compare normalized copies of the URLs
    return [components.string isEqualToString:otherComponents.string];
}


- (BOOL)matches:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    if (url == nil) {
        return self.url == nil;
    }
    return [self matchesURL:url];
}


#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[LSURLMatcher class]]) {
        return NO;
    }

    return [self.url isEqual:((LSURLMatcher *)object).url];
}

- (NSUInteger)hash {
    return self.url.hash;
}

@end
