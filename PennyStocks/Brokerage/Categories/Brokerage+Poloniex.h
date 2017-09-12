//
//  Brokerage+Poloniex.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

@interface Brokerage (Poloniex)
+ (NSDictionary*)poloniexTicker:(NSArray*)fiatCurrencies;
+ (NSDictionary*)poloniexBalance:(NSDictionary*)apikey withSecret:(NSString*)secret;
+ (NSDictionary*)poloniexBuy:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount;
+ (NSDictionary*)poloniexSell:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount;
@end
