//
//  Brokerage+Crypto.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

@interface Brokerage (Crypto)

/**
 *
 * @param plainText
 * @param secret
 * @return
 */
+ (NSString *)hmac:(NSString *)plainText withSecret:(NSString *)secret;

/**
 *
 * @param input
 * @return
 */
+ (NSString *)sha512:(NSString *)input;

@end