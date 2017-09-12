//
//  Brokerage.m
//  PennyStocks
//
//  Created by Markus Bröker on 11.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

@implementation Brokerage

/**
 * Request the balance via API-Key
 *
 * @param apikey
 * @param secret
 * returns NSDictionary*
 */
+ (NSDictionary*)balance:(NSDictionary*)apikey withSecret:(NSString*)secret forExchange:(NSString*)exchange {
    if ([exchange isEqualToString:EXCHANGE_POLONIEX]) {
        return [Brokerage poloniexBalance:apikey withSecret:secret];
    }

    if ([exchange isEqualToString:EXCHANGE_BITTREX]) {
        return [Brokerage bittrexBalance:apikey withSecret:secret];
    }

    return nil;
}

/**
 * BUY via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * @param exchange
 * returns NSDictionary*
 */
+ (NSDictionary*)buy:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount onExchange:(NSString*)exchange {
    if ([exchange isEqualToString:EXCHANGE_POLONIEX]) {
        return [Brokerage poloniexBuy:apikey withSecret:secret currencyPair:currencyPair rate:rate amount:amount];
    }

    if ([exchange isEqualToString:EXCHANGE_BITTREX]) {
        return [Brokerage bittrexBuy:apikey withSecret:secret currencyPair:currencyPair rate:rate amount:amount];
    }

    return nil;
}

/**
 * SELL via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * @param exchange
 * returns NSDictionary*
 */
+ (NSDictionary*)sell:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount onExchange:(NSString*)exchange {
    if ([exchange isEqualToString:EXCHANGE_POLONIEX]) {
        return [Brokerage poloniexSell:apikey withSecret:secret currencyPair:currencyPair rate:rate amount:amount];
    }

    if ([exchange isEqualToString:EXCHANGE_BITTREX]) {
        return [Brokerage bittrexSell:apikey withSecret:secret currencyPair:currencyPair rate:rate amount:amount];
    }

    return nil;
}

@end
