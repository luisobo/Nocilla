#import "LSHTTPSStubberConnection.h"

// http://stackoverflow.com/questions/8850524/seccertificateref-how-to-get-the-certificate-information
// http://stackoverflow.com/questions/10238559/creating-a-seccertificateref-for-nsurlconnection-authentication-challenge
// http://stackoverflow.com/questions/1460626/iphone-https-client-cert-authentication


@implementation LSHTTPSStubberConnection

- (BOOL)isSecureServer {
	return YES;
}

/**
 * Overrides HTTPConnection's method
 *
 * This method is expected to returns an array appropriate for use in kCFStreamSSLCertificates SSL Settings.
 * It should be an array of SecCertificateRefs except for the first element in the array, which is a SecIdentityRef.
 **/
- (NSArray *)sslIdentityAndCertificates {
    SecIdentityRef identityApp = nil;
    NSString *thePath = nil;
    
    for (NSBundle *bundle in [NSBundle allBundles]) {
        thePath = [bundle pathForResource:@"getshopkeep" ofType:@"p12"];
        if (thePath != nil) {
            break;
        }
    }
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef password = CFSTR("password");
    const void *keys[] = { kSecImportExportPassphrase };//kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
    CFRelease(options);
    CFRelease(password);
    if (securityError == errSecSuccess) {
        NSLog(@"Success opening p12 certificate. Items: %ld", CFArrayGetCount(items));
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
    } else {
        NSLog(@"Error opening Certificate.");
    }
    SecCertificateRef certificateRef = nil;
    SecIdentityCopyCertificate(identityApp, &certificateRef);
    
    SecCertificateRef certs[1] = { certificateRef };
    CFArrayRef array = CFArrayCreate(NULL, (const void **) certs, 1, NULL);
    NSArray *result = (NSArray *)CFBridgingRelease(array);
    return result;
    
}

// Returns an array containing the certificate
- (CFArrayRef)getCertificate {
    SecCertificateRef certificate = nil;
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"getshopkeep" ofType:@"p12"];
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    certificate = SecCertificateCreateWithData(nil, inPKCS12Data);
    SecCertificateRef certs[1] = { certificate };
    CFArrayRef array = CFArrayCreate(NULL, (const void **) certs, 1, NULL);
    
    SecPolicyRef myPolicy   = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    
    OSStatus status = SecTrustCreateWithCertificates(array, myPolicy, &myTrust);
    if (status == noErr) {
        NSLog(@"No Err creating certificate");
    } else {
        NSLog(@"Possible Err Creating certificate");
    }
    return array;
}


// Returns the identity
- (SecIdentityRef)getIdentity {
    SecIdentityRef identityApp = nil;
    NSString *thePath = nil;
    
    for (NSBundle *bundle in [NSBundle allBundles]) {
        thePath = [bundle pathForResource:@"getshopkeep" ofType:@"p12"];
        if (thePath != nil) {
            break;
        }
    }
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef password = CFSTR("password");
    const void *keys[] = { kSecImportExportPassphrase };//kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
    CFRelease(options);
    CFRelease(password);
    if (securityError == errSecSuccess) {
        NSLog(@"Success opening p12 certificate. Items: %ld", CFArrayGetCount(items));
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
    } else {
        NSLog(@"Error opening Certificate.");
    }
    return identityApp;
}


@end
