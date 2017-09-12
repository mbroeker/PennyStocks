//
//  Brokerage.h
//  iBroker
//
//  Created by Markus Bröker on 11.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define RELEASE_BUILD 1

// Definition der verfügbaren Börsen
#define EXCHANGE_POLONIEX @"POLONIEX_EXCHANGE"
#define EXCHANGE_BITTREX @"BITTREX_EXCHANGE"

#define POLONIEX_ASK @"lowestAsk"
#define POLONIEX_BID @"highestBid"
#define POLONIEX_LOW24 @"low24hr"
#define POLONIEX_HIGH24 @"high24hr"
#define POLONIEX_QUOTE_VOLUME @"quoteVolume"
#define POLONIEX_BASE_VOLUME @"baseVolume"
#define POLONIEX_PERCENT @"percentChange"
#define POLONIEX_LAST @"last"

@interface Brokerage : NSObject
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL;
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL withPayload:(NSDictionary*)payload;
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL withPayload:(NSDictionary*)payload andHeader:(NSDictionary*)header;
+ (NSDictionary*)poloniexTicker:(NSArray*)fiatCurrencies;
+ (NSDictionary*)bittrexTicker:(NSArray*)fiatCurrencies forAssets:(NSArray*)assetsArray;
+ (NSDictionary*)balance:(NSDictionary*)apikey withSecret:(NSString*)secret forExchange:(NSString*)exchange;
+ (NSDictionary*)buy:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount onExchange:(NSString*)exchange;
+ (NSDictionary*)sell:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount onExchange:(NSString*)exchange;

+ (void)safeSleep:(NSTimeInterval)timeout;
@end
