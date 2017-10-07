//
//  Brokerage+JSON.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

@interface Brokerage (JSON)

/**
 *
 * @param jsonURL
 * @return
 */
+ (NSDictionary *)jsonRequest:(NSString *)jsonURL;

/**
 *
 * @param jsonURL
 * @param payload
 * @return
 */
+ (NSDictionary *)jsonRequest:(NSString *)jsonURL withPayload:(NSDictionary *)payload;

/**
 *
 * @param jsonURL
 * @param payload
 * @param header
 * @return
 */
+ (NSDictionary *)jsonRequest:(NSString *)jsonURL withPayload:(NSDictionary *)payload andHeader:(NSDictionary *)header;

/**
 *
 * @param string
 * @return
 */
+ (NSString *)urlStringEncode:(NSString *)string;

/**
 *
 * @param payload
 * @return
 */
+ (NSString *)urlEncode:(NSDictionary *)payload;

@end
