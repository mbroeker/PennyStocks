//
//  KeychainWrapper.h
//  imported into PennyStocks
//
//  Created by Chris Lowe on 10/31/11.
//  Copyright (c) 2011 USAA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Simplified Keychain Management
 *
 * @author      Chris Lowe
 * @copyright   Copyright (C) 2011 USAA
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface KeychainWrapper : NSObject

/**
 *
 * @param identifier
 * @return
 */
+ (NSData *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier;

/**
 *
 * @param identifier
 * @return
 */
+ (NSString *)keychainStringFromMatchingIdentifier:(NSString *)identifier;

/**
 *
 * @param value
 * @param identifier
 * @return
 */
+ (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

/**
 *
 * @param value
 * @param identifier
 * @return
 */
+ (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

/**
 *
 * @param identifier
 */
+ (void)deleteItemFromKeychainWithIdentifier:(NSString *)identifier;

/**
 *
 * @param identifier
 * @return
 */
+ (NSDictionary *)keychain2ApiKeyAndSecret:(NSString *)identifier;

@end
