//
//  Brokerage.h
//  PennyStocks
//
//  Created by Markus Bröker on 11.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define RELEASE_BUILD 1

#import "CalculatorConstants.h"

@interface Brokerage : NSObject

/**
 * Retrieve the current balance from the crypto exchange of choice
 *
 * @param apikey
 * @param secret
 * @param exchange
 * @return NSDictionary*
 */
+ (NSDictionary *)balance:(NSDictionary *)apikey withSecret:(NSString *)secret forExchange:(NSString *)exchange;

/**
 * Buy an ASSET with the MASTER-ASSET (ETH) via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * @param exchange
 * @return NSDictionary*
 */
+ (NSDictionary *)buy:(NSDictionary *)apikey withSecret:(NSString *)secret currencyPair:(NSString *)currencyPair rate:(double)rate amount:(double)amount onExchange:(NSString *)exchange;

/**
 * Sell an ASSET back into the MASTER-ASSET (ETH) via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * @param exchange
 * @return NSDictionary*
 */
+ (NSDictionary *)sell:(NSDictionary *)apikey withSecret:(NSString *)secret currencyPair:(NSString *)currencyPair rate:(double)rate amount:(double)amount onExchange:(NSString *)exchange;

/**
 * Get Open Orders from the given exchange via API-KEY
 *
 * @param apikey
 * @param secret
 * @param exchange
 * @return
 */
+ (NSArray *)openOrders:(NSDictionary *)apikey withSecret:(NSString *)secret onExchange:(NSString *)exchange;

/**
 * Cancel Order from the given exchange via API-KEY
 *
 * @param apikey
 * @param secret
 * @param exchange
 * @return
 */
+ (BOOL)cancelOrder:(NSDictionary *)apikey withSecret:(NSString *)secret orderId:(NSString*)orderId onExchange:(NSString *)exchange;

@end

#import "Categories/Brokerage+Bittrex.h"
#import "Categories/Brokerage+Poloniex.h"
