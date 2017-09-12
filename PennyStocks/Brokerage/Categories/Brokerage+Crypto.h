//
//  Brokerage+Crypto.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@interface Brokerage (Crypto)
+ (NSString *)hmac:(NSString *)plainText withSecret:(NSString*)secret;
+ (NSString *)sha512:(NSString *)input;
@end