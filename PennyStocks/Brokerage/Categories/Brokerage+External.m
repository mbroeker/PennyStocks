//
//  Brokerage+External.m
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage+External.h"
#import "Brokerage+JSON.h"

@implementation Brokerage (External)

/**
 * Besorge den Umrechnungsfaktor EUR/USD
 * 
 * @param fiatCurrencies
 * @return NSNumber*
 */
+ (NSNumber*)fiatExchangeRate:(NSArray*)fiatCurrencies {
    NSString *jsonURL =
        [NSString stringWithFormat:@"https://min-api.cryptocompare.com/data/pricemulti?fsyms=%@&tsyms=%@&extraParams=de.4customers.PennyStocks", fiatCurrencies[0], fiatCurrencies[1]];

    NSDictionary *data = [Brokerage jsonRequest:jsonURL];

    if (!data[fiatCurrencies[0]]) {
        NSLog(@"API-ERROR: Cannot retrieve exchange rates for %@/%@", fiatCurrencies[0], fiatCurrencies[1]);

        return nil;
    }

    return @([data[fiatCurrencies[0]][fiatCurrencies[1]] doubleValue]);
}

/**
 * Besorge den fehlenden BTC-Ticker von bitstamp und fake diesen ins Poloniex-Format
 *
 * @param asset
 * @return NSDictionary*
 */
+ (NSDictionary*)bitstampAsset1Ticker:(NSString*)asset {
    NSString *jsonURL = [NSString stringWithFormat:@"https://www.bitstamp.net/api/v2/ticker/%@%@/", [ASSET1 lowercaseString], [asset lowercaseString]];

    NSDictionary *theirData = [Brokerage jsonRequest:jsonURL];

    if (!theirData[@"last"]) {
        NSLog(@"API-ERROR: Cannot retrieve exchange rates for %@/%@", ASSET1, asset);

        return nil;
    }

    // aktuelle Anfragen und Käufe
    double ask = [theirData[@"ask"] doubleValue];
    double bid = [theirData[@"bid"] doubleValue];

    // 24h Change
    double high24 = [theirData[@"high"] doubleValue];
    double low24 = [theirData[@"low"] doubleValue];

    // aktueller Kurs
    double last = [theirData[@"last"] doubleValue];

    // Heutiger Eröffnungskurs
    double open= [theirData[@"open"] doubleValue];
    double percent = (last / open) - 1;

    NSMutableDictionary *poloniexData = [[NSMutableDictionary alloc] init];

    poloniexData[POLONIEX_HIGH24] = @(high24);
    poloniexData[POLONIEX_LOW24] = @(low24);
    poloniexData[POLONIEX_ASK] = @(ask);
    poloniexData[POLONIEX_BID] = @(bid);
    poloniexData[POLONIEX_LAST] = @(last);

    // Poloniex liefert ausgerechnete Werte (50% sind halt 50 / 100 = 0.5)
    poloniexData[POLONIEX_PERCENT] = @(percent);

    return poloniexData;
}

@end
