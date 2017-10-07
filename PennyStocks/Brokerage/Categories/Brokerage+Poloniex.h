//
//  Brokerage+Poloniex.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

@interface Brokerage (Poloniex)

/**
 * Retrieve the Ticker from Poloniex
 *
 * @param fiatCurrencies
 * @return
 */
+ (NSDictionary *)poloniexTicker:(NSArray *)fiatCurrencies;

/**
 * Retrieve the balance from Poloniex via API-KEY
 *
 * @param apikey
 * @param secret
 * @return
 */
+ (NSDictionary *)poloniexBalance:(NSDictionary *)apikey withSecret:(NSString *)secret;

/**
 * Buy an ASSET with the MASTER ASSET (ETH) via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * @return
 */
+ (NSDictionary *)poloniexBuy:(NSDictionary *)apikey withSecret:(NSString *)secret currencyPair:(NSString *)currencyPair rate:(double)rate amount:(double)amount;

/**
 * Sell an ASSET back into the master ASSET (ETH) via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * @return
 */
+ (NSDictionary *)poloniexSell:(NSDictionary *)apikey withSecret:(NSString *)secret currencyPair:(NSString *)currencyPair rate:(double)rate amount:(double)amount;

/**
 * Get Open Orders from Poloniex via API-KEY
 *
 * @param apikey
 * @param secret
 * @return
 */
+ (NSArray *)poloniexOpenOrders:(NSDictionary *)apikey withSecret:(NSString *)secret;

/**
 *
 * @param apikey
 * @param secret
 * @param orderId
 * @return
 */
+ (BOOL)poloniexCancelOrder:(NSDictionary *)apikey withSecret:(NSString *)secret orderId:(NSString *)orderId;

@end
