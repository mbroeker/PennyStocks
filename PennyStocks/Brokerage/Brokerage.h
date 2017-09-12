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
+ (NSDictionary*)balance:(NSDictionary*)apikey withSecret:(NSString*)secret forExchange:(NSString*)exchange;
+ (NSDictionary*)buy:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount onExchange:(NSString*)exchange;
+ (NSDictionary*)sell:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount onExchange:(NSString*)exchange;
@end

#import "Categories/Brokerage+Bittrex.h"
#import "Categories/Brokerage+Poloniex.h"
