//
//  Brokerage+External.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

@interface Brokerage (External)
+ (NSNumber*)fiatExchangeRate:(NSArray*)fiatCurrencies;
+ (NSDictionary*)bitstampAsset1Ticker:(NSString*)asset;
@end
