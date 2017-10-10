//
//  Brokerage+Bittrex.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

/**
 * Category for Bittrex
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface Brokerage (Bittrex)

/**
 * Retrieve the ticker from Bittrex
 *
 * @param fiatCurrencies
 * @param assetsArray
 * @return NSDictionary*
 */
+ (NSDictionary *)bittrexTicker:(NSArray *)fiatCurrencies forAssets:(NSArray *)assetsArray;

/**
 * Retrieve the balance from Bittrex via API-KEY
 *
 * @param apikey
 * @param secret
 * @return NSDictionary*
 */
+ (NSDictionary *)bittrexBalance:(NSDictionary *)apikey withSecret:(NSString *)secret;

/**
 * Buy an ASSET with the MASTER-ASSET (ETH) on Bittrex via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * @return NSDictionary*
 */
+ (NSDictionary *)bittrexBuy:(NSDictionary *)apikey withSecret:(NSString *)secret currencyPair:(NSString *)currencyPair rate:(double)rate amount:(double)amount;

/**
 * Sell an ASSET back into the MASTER-ASSET (ETH) on Bittrex via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * @return NSDictionary*
 */
+ (NSDictionary *)bittrexSell:(NSDictionary *)apikey withSecret:(NSString *)secret currencyPair:(NSString *)currencyPair rate:(double)rate amount:(double)amount;

/**
 * Get Open Orders from Bittrex via API-KEY
 *
 * @param apikey
 * @param secret
 * @return
 */
+ (NSArray *)bittrexOpenOrders:(NSDictionary *)apikey withSecret:(NSString *)secret;

/**
 *
 * @param apikey
 * @param secret
 * @param orderId
 * @return
 */
+ (BOOL)bittrexCancelOrder:(NSDictionary *)apikey withSecret:(NSString *)secret orderId:(NSString *)orderId;

@end
