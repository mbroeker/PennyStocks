//
//  Brokerage+Crypto.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

/**
 * Category for Cryptographic Stuff
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
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