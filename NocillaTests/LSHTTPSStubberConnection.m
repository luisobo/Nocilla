#import "Kiwi.h"
#import "LSHTTPSStubberConnection.h"
#import <Security/Security.h>

SPEC_BEGIN(LSHTTPSStubberConnectionSpec)

//it(@"should load the identity", ^{
//    SecIdentityRef identityApp = nil;
//    NSString *thePath = nil;
//    
//    for (NSBundle *bundle in [NSBundle allBundles]) {
//        thePath = [bundle pathForResource:@"getshopkeep" ofType:@"p12"];
//        if (thePath != nil) {
//            break;
//        }
//    }
//    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
//    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
//    CFStringRef password = CFSTR("password");
//    const void *keys[] = { kSecImportExportPassphrase };//kSecImportExportPassphrase };
//    const void *values[] = { password };
//    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
//    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
//    CFRelease(options);
//    CFRelease(password);
//    if (securityError == errSecSuccess) {
//        NSLog(@"Success opening p12 certificate. Items: %ld", CFArrayGetCount(items));
//        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
//        identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
//    } else {
//        NSLog(@"Error opening Certificate.");
//    }
//    SecCertificateRef certificateRef = nil;
//    SecIdentityCopyCertificate(identityApp, &certificateRef);
//
//    SecCertificateRef certs[1] = { certificateRef };
//    CFArrayRef array = CFArrayCreate(NULL, (const void **) certs, 1, NULL);
//    
    
//    [theValue(nil) shouldBeNil];
//});

SPEC_END