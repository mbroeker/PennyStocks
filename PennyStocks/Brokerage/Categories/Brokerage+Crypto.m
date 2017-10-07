//
//  Brokerage+Crypto.m
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage+Crypto.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation Brokerage (Crypto)

/**
 * HMAC SHA512
 */
+ (NSString *)hmac:(NSString *)plainText withSecret:(NSString *)secret {
    NSDebug(@"Brokerage::hmac");

    const char *cKey = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plainText cStringUsingEncoding:NSASCIIStringEncoding];

    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];

    const unsigned char *buffer = (const unsigned char *) [HMACData bytes];
    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];

    for (int i = 0; i < HMACData.length; ++i) {
        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long) buffer[i]];
    }

    return HMAC;
}

/**
 * SHA512
 *
 * @param input
 * @return NSString*
 */
+ (NSString *)sha512:(NSString *)input {
    NSDebug(@"Brokerage::sha512");

    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, (CC_LONG) data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

@end
