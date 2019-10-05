//
//  Brokerage+Bittrex.m
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage+Bittrex.h"
#import "Brokerage+Crypto.h"
#import "Brokerage+JSON.h"
#import "Brokerage+External.h"

@implementation Brokerage (Bittrex)

/**
 * Besorge die Marktzusammenfassung von Bittrex
 *
 * @return NSDictionary*
 */
+ (NSDictionary *)bittrexMarketSummaries {

    if (![Brokerage isInternetConnection]) {
        return nil;
    }

    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/public/getmarketsummaries"];
    NSMutableDictionary *innerTicker = [[Brokerage jsonRequest:jsonURL] mutableCopy];

    if (!innerTicker[@"result"]) {
        return nil;
    }

    return innerTicker[@"result"];
}

/**
 * Besorge den Ticker von Bittrex
 *
 * @param fiatCurrencies NSArray*
 * @param assetsArray NSArray*
 * @return NSDictionary*
 */
+ (NSDictionary *)bittrexTicker:(NSArray *)fiatCurrencies forAssets:(NSArray *)assetsArray {

    NSDictionary *innerTicker = [Brokerage bittrexMarketSummaries];

    if (innerTicker == nil) {
        return nil;
    }

    NSMutableDictionary *ticker = [[NSMutableDictionary alloc] init];
    for (id key in assetsArray) {
        if ([key isEqualToString:ASSET_KEY(1)]) { continue; }

        NSString *pair = [NSString stringWithFormat:@"%@-%@", ASSET_KEY(1), key];

        for (id data in innerTicker) {

            if (!data[@"MarketName"]) {
                continue;
            }

            // Filter disabled markets
            if (![data[@"Volume"] isKindOfClass:[NSNumber class]]) {
                continue;
            }

            if ([data[@"MarketName"] isEqualToString:pair]) {
                NSString *marketName = data[@"MarketName"];
                marketName = [marketName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];

                double percent = ([data[@"Last"] doubleValue] / [data[@"PrevDay"] doubleValue]) - 1;

                ticker[marketName] = @{
                    POLONIEX_HIGH24: data[@"High"],
                    POLONIEX_LOW24: data[@"Low"],
                    POLONIEX_ASK: data[@"Ask"],
                    POLONIEX_BID: data[@"Bid"],
                    POLONIEX_LAST: data[@"Last"],
                    POLONIEX_BASE_VOLUME: data[@"BaseVolume"],
                    POLONIEX_QUOTE_VOLUME: data[@"Volume"],
                    POLONIEX_PERCENT: @(percent)
                };

                break;
            }
        }
    }

    NSDictionary *asset1Ticker = [Brokerage bitstampAsset1Ticker:fiatCurrencies[0]];

    if (!asset1Ticker) {
        return nil;
    }

    NSNumber *exchangeRate = [Brokerage fiatExchangeRate:fiatCurrencies];

    if (!exchangeRate) {
        return nil;
    }

    NSString *asset1Fiat = [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), fiatCurrencies[0]];
    ticker[asset1Fiat] = asset1Ticker;
    ticker[fiatCurrencies[1]] = @([exchangeRate doubleValue]);

    return ticker;
}

/**
 * Request the balance from Bittrex via API-Key
 *
 * @param apikey
 * @param secret
 * returns NSDictionary*
 */
+ (NSDictionary *)bittrexBalance:(NSDictionary *)apikey withSecret:(NSString *)secret {

    if (apikey == nil || secret == nil) {
        return nil;
    }

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];

    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/account/getbalances?apikey=%@&nonce=%@", apikey[@"Key"], nonce];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Brokerage hmac:[Brokerage urlStringEncode:jsonURL] withSecret:secret];

    NSDictionary *data = [Brokerage jsonRequest:jsonURL withPayload:nil andHeader:header];

    if (data == nil) {
        return @{
            POLONIEX_ERROR: @"API-ERROR: Cannot fetch Data from Bittrex"
        };
    }

    if ([data[@"success"] intValue] == 0) {
        return @{
            POLONIEX_ERROR: data[@"message"]
        };
    }

    NSArray *dataRows = data[@"result"];

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    for (NSDictionary *row in dataRows) {
        NSString *asset = row[@"Currency"];

        double available = 0.0;
        double onOrders = 0.0;

        /* Bittrex Technology Update Feb 2019-02-28 */
        if (![row[@"Available"] isEqual:[NSNull null]]) {
            available = [row[@"Available"] doubleValue];
        }

        if (![row[@"Balance"] isEqual:[NSNull null]]) {
            onOrders = [row[@"Balance"] doubleValue] - available;
        }
        /* Bittrex Technology Update Feb 2019-02-28 */

        result[asset] = @{
            POLONIEX_AVAILABLE: @(available),
            POLONIEX_ON_ORDERS: @(onOrders)
        };
    }

    return result;
}

/**
 * BUY via API-KEY
 *
 * @param apikey
 * @param secret
 * @param currencyPair
 * @param rate
 * @param amount
 * returns NSDictionary*
 */
+ (NSDictionary *)bittrexBuy:(NSDictionary *)apikey withSecret:(NSString *)secret currencyPair:(NSString *)currencyPair rate:(double)rate amount:(double)amount {

    if (apikey == nil || secret == nil) {
        return nil;
    }

    NSString *bittrexCurrencyPair = [currencyPair stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    NSString *bittrexRate = [NSString stringWithFormat:@"%.8f", rate];
    NSString *bittrexAmount = [NSString stringWithFormat:@"%.8f", amount];

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];
    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/market/buylimit?apikey=%@&market=%@&quantity=%@&rate=%@&nonce=%@",
        apikey[@"Key"],
        bittrexCurrencyPair,
        bittrexAmount,
        bittrexRate,
        nonce
    ];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Brokerage hmac:[Brokerage urlStringEncode:jsonURL] withSecret:secret];

    NSDictionary *response = [Brokerage jsonRequest:jsonURL withPayload:nil andHeader:header];

    if ([response[@"success"] integerValue] == 1) {
        NSDictionary *result = response[@"result"];

        return @{
            POLONIEX_ORDER_NUMBER: result[@"uuid"]
        };
    } else {
        return @{
            POLONIEX_ERROR: [NSString stringWithFormat:@"BUY-LIMIT: %@", response[@"message"]]
        };
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
 * returns NSDictionary*
 */
+ (NSDictionary *)bittrexSell:(NSDictionary *)apikey withSecret:(NSString *)secret currencyPair:(NSString *)currencyPair rate:(double)rate amount:(double)amount {

    if (apikey == nil || secret == nil) {
        return nil;
    }

    NSString *bittrexCurrencyPair = [currencyPair stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    NSString *bittrexRate = [NSString stringWithFormat:@"%.8f", rate];
    NSString *bittrexAmount = [NSString stringWithFormat:@"%.8f", amount];

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];
    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/market/selllimit?apikey=%@&market=%@&quantity=%@&rate=%@&nonce=%@",
        apikey[@"Key"],
        bittrexCurrencyPair,
        bittrexAmount,
        bittrexRate,
        nonce
    ];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Brokerage hmac:[Brokerage urlStringEncode:jsonURL] withSecret:secret];

    NSDictionary *response = [Brokerage jsonRequest:jsonURL withPayload:nil andHeader:header];

    if ([response[@"success"] integerValue] == 1) {
        NSDictionary *result = response[@"result"];

        return @{
            POLONIEX_ORDER_NUMBER: result[@"uuid"]
        };
    } else {
        return @{
            POLONIEX_ERROR: [NSString stringWithFormat:@"SELL-LIMIT: %@", response[@"message"]]
        };
    }

    return nil;
}

/**
 * Get Open Orders from Bittrex via API-KEY
 *
 * @param apikey
 * @param secret
 * @return
 */
+ (NSArray *)bittrexOpenOrders:(NSDictionary *)apikey withSecret:(NSString *)secret {

    if (apikey == nil || secret == nil) {
        return nil;
    }

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];
    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/market/getopenorders?apikey=%@&nonce=%@",
        apikey[@"Key"],
        nonce
    ];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Brokerage hmac:[Brokerage urlStringEncode:jsonURL] withSecret:secret];

    NSDictionary *response = [Brokerage jsonRequest:jsonURL withPayload:nil andHeader:header];

    NSMutableArray *orders = [[NSMutableArray alloc] init];
    if ([response[@"success"] integerValue] == 1) {
        NSArray *result = response[@"result"];

        int i = 0;
        for (NSDictionary *element in result) {
           /**
            * ORDER-ID
            * DATE
            * PAIR
            * AMOUNT
            * RATE
            */
            orders[i++] = @[
                element[@"OrderUuid"],
                element[@"Opened"],
                element[@"Exchange"],
                element[@"Quantity"],
                element[@"Limit"]
            ];
        }
    }

    return orders;
}

/**
 *
 * @param apikey
 * @param secret
 * @param orderId
 * @return
 */
+ (BOOL)bittrexCancelOrder:(NSDictionary *)apikey withSecret:(NSString *)secret orderId:(NSString *)orderId {

    if (apikey == nil || secret == nil) {
        return NO;
    }

    time_t t = 1975 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];
    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/market/cancel?apikey=%@&uuid=%@&nonce=%@",
        apikey[@"Key"],
        orderId,
        nonce
    ];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Brokerage hmac:[Brokerage urlStringEncode:jsonURL] withSecret:secret];

    NSDictionary *response = [Brokerage jsonRequest:jsonURL withPayload:nil andHeader:header];

    return ([response[@"success"] integerValue] == 1);
}

@end
