//
//  Brokerage+Bittrex.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

@interface Brokerage (Bittrex)
+ (NSDictionary*)bittrexTicker:(NSArray*)fiatCurrencies forAssets:(NSArray*)assetsArray;
+ (NSDictionary*)bittrexBalance:(NSDictionary*)apikey withSecret:(NSString*)secret;
+ (NSDictionary*)bittrexBuy:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount;
+ (NSDictionary*)bittrexSell:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount;
@end
