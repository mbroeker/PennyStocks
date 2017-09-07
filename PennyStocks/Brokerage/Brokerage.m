//
//  Brokerage.m
//  iBroker
//
//  Created by Markus Bröker on 11.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"
#import "CalculatorConstants.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include <SystemConfiguration/SystemConfiguration.h>

@implementation Brokerage

/**
 * Allgemeiner jsonRequest Handler
 *
 * @param jsonURL
 * @return NSDictionary*
 */
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL {

    if (![Brokerage isInternetConnection]) {
        return nil;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:jsonURL]];
    [request setHTTPMethod:@"GET"];
    
    __block NSMutableDictionary *result;
    __block BOOL hasFinished = false;

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

        NSData *jsonData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;

        result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&jsonError];
        if (jsonError && !RELEASE_BUILD) {
            // Fehlermeldung wird angezeigt
            NSLog(@"JSON-ERROR for URL %@\n%@", jsonURL, [jsonError description]);
        }

        hasFinished = true;

    }] resume];

    while(!hasFinished) {
        [Brokerage safeSleep:0.1];
    }
    
    return result;
}

/**
 * Allgemeiner jsonRequest Handler mit Payload
 *
 * @param jsonURL
 * @param payload
 * @return NSDictionary*
 */
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL withPayload:(NSDictionary*)payload {
    return [Brokerage jsonRequest:jsonURL withPayload:payload andHeader:nil];
}

/**
 * Allgemeiner jsonRequest Handler mit Payload und Header
 *
 * @param jsonURL
 * @param payload
 * @param header
 *
 * @return NSDictionary*
 */
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL withPayload:(NSDictionary*)payload andHeader:(NSDictionary*)header {

    if (![Brokerage isInternetConnection]) {
        return nil;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setHTTPMethod:(payload == nil) ? @"GET" : @"POST"];
    [request setURL:[NSURL URLWithString:jsonURL]];

    for (id field in header) {
        [request setValue:header[field] forHTTPHeaderField:field];
    }

    if (payload != nil) {
        NSString *payloadAsString = [Brokerage urlEncode:payload];
        NSData *data = [payloadAsString dataUsingEncoding:NSASCIIStringEncoding];

        [request setHTTPBody:data];
    }

    __block NSMutableDictionary *result;
    __block BOOL hasFinished = false;

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

        NSData *jsonData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;

        result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&jsonError];
        if (jsonError && !RELEASE_BUILD) {
            // Fehlermeldung wird angezeigt
            NSLog(@"JSON-ERROR for URL %@\n%@", jsonURL, [jsonError description]);
        }

        hasFinished = true;

    }] resume];

    while(!hasFinished) {
        [Brokerage safeSleep:0.1];
    }
    
    return result;
}

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

/**
 * Request the balance from poloniex via API-Key
 *
 * @param apikey
 * @param secret
 * returns NSDictionary*
 */
+ (NSDictionary*)poloniexBalance:(NSDictionary*)apikey withSecret:(NSString*)secret {
    NSString *jsonURL = @"https://poloniex.com/tradingApi";

    if ([secret isEqualToString:@""]) {
        return nil;
    }

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *header = [apikey mutableCopy];

    time_t t = 1975.0 * time(NULL);

    payload[@"command"] = @"returnCompleteBalances";
    payload[@"nonce"] = [NSString stringWithFormat:@"%ld", t];

    header[@"Sign"] = [Brokerage hmac:[Brokerage urlEncode:payload] withSecret:secret];

    NSDictionary *data = [Brokerage jsonRequest:jsonURL withPayload:payload andHeader:header];

    if (data == nil) {
        return @{
            @"error": @"API-ERROR: Cannot fetch Data from Poloniex"
        };
    }

    return data;
}

/**
 * Request the balance from Bittrex via API-Key
 *
 * @param apikey
 * @param secret
 * returns NSDictionary*
 */
+ (NSDictionary*)bittrexBalance:(NSDictionary*)apikey withSecret:(NSString*)secret {

    time_t t = 1000 * time(NULL);
    NSString *nonce = [NSString stringWithFormat:@"%ld", t];

    NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/account/getbalances?apikey=%@&nonce=%@", apikey[@"Key"], nonce];

    if ([secret isEqualToString:@""]) {
        return nil;
    }

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    header[@"apisign"] = [Brokerage hmac:[Brokerage urlStringEncode:jsonURL] withSecret:secret];

    NSDictionary *data = [Brokerage jsonRequest:jsonURL withPayload:nil andHeader:header];

    if (data == nil) {
        return @{
            @"error": @"API-ERROR: Cannot fetch Data from Bittrex"
        };
    }

    if ([data[@"success"] intValue] == 0) {
        return @{
            @"error": data[@"message"]
        };
    }

    NSArray *dataRows = data[@"result"];

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    for (NSDictionary *row in dataRows) {
        NSString *asset = row[@"Currency"];

        double available = [row[@"Available"] doubleValue];
        double onOrders = [row[@"Pending"] doubleValue];

        result[asset] = @{
            @"available": @(available),
            @"onOrders": @(onOrders)
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
+ (NSDictionary*)poloniexBuy:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount {
    NSString *jsonURL = @"https://poloniex.com/tradingApi";

    if ([secret isEqualToString:@""]) {
        return nil;
    }

    // Bitcoin Cash heißt BCH auf Poloniex
    if ([currencyPair isEqualToString:@"BTC_BCC"]) {
        currencyPair = @"BTC_BCH";
    }

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *header = [apikey mutableCopy];

    time_t t = 1975.0 * time(NULL);

    payload[@"command"] = @"buy";
    payload[@"currencyPair"] = currencyPair;
    payload[@"rate"] = [NSNumber numberWithDouble:rate];
    payload[@"amount"] = [NSNumber numberWithDouble:amount];
    payload[@"nonce"] = [NSString stringWithFormat:@"%ld", t];

    header[@"Sign"] = [Brokerage hmac:[Brokerage urlEncode:payload] withSecret:secret];

    return [Brokerage jsonRequest:jsonURL withPayload:payload andHeader:header];
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
+ (NSDictionary*)poloniexSell:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount {
    NSString *jsonURL = @"https://poloniex.com/tradingApi";

    if ([secret isEqualToString:@""]) {
        return nil;
    }

    // Bitcoin Cash heißt BCH auf Poloniex
    if ([currencyPair isEqualToString:@"BTC_BCC"]) {
        currencyPair = @"BTC_BCH";
    }

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *header = [apikey mutableCopy];

    time_t t = 1975.0 * time(NULL);

    payload[@"command"] = @"sell";
    payload[@"currencyPair"] = currencyPair;
    payload[@"rate"] = [NSNumber numberWithDouble:rate];
    payload[@"amount"] = [NSNumber numberWithDouble:amount];
    payload[@"nonce"] = [NSString stringWithFormat:@"%ld", t];

    header[@"Sign"] = [Brokerage hmac:[Brokerage urlEncode:payload] withSecret:secret];

    return [Brokerage jsonRequest:jsonURL withPayload:payload andHeader:header];
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
+ (NSDictionary*)bittrexBuy:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount {

    if ([apikey[@"Key"] isEqualToString:@""]) {
        return nil;
    }

    NSString *bittrexCurrencyPair = [currencyPair stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    NSString *bittrexRate = [NSString stringWithFormat:@"%.8f", rate];
    NSString *bittrexAmount = [NSString stringWithFormat:@"%.8f", amount];

    time_t t = time(NULL);
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
            @"orderNumber": result[@"uuid"]
        };
    } else {
        NSLog(@"Buy-LIMIT: %@/%@/%@: %@", bittrexCurrencyPair, bittrexAmount, bittrexRate, response[@"message"]);
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
+ (NSDictionary*)bittrexSell:(NSDictionary*)apikey withSecret:(NSString*)secret currencyPair:(NSString*)currencyPair rate:(double)rate amount:(double)amount {

    if ([apikey[@"Key"] isEqualToString:@""]) {
        return nil;
    }

    NSString *bittrexCurrencyPair = [currencyPair stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    NSString *bittrexRate = [NSString stringWithFormat:@"%.8f", rate];
    NSString *bittrexAmount = [NSString stringWithFormat:@"%.8f", amount];

    time_t t = time(NULL);
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
            @"orderNumber": result[@"uuid"]
        };
    } else {
        NSLog(@"Sell-LIMIT: %@/%@/%@: %@", bittrexCurrencyPair, bittrexAmount, bittrexRate, response[@"message"]);
    }

    return nil;
}

/**
 * HMAC SHA512
 */
+ (NSString *)hmac:(NSString *)plainText withSecret:(NSString*)secret {
    const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plainText cStringUsingEncoding:NSASCIIStringEncoding];

    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];

    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];

    for (int i = 0; i < HMACData.length; ++i)
        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)buffer[i]];

    return HMAC;
}

/**
 * SHA512
 *
 * @param input
 * @return NSString*
 */
+ (NSString *)sha512:(NSString *)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

/**
 * Simpler Text Encoder
 *
 * @param string
 */
+ (NSString*) urlStringEncode:(NSString*)string {
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/**
 * Simpler URL-Encoder
 *
 * @param payload
 * @return NSString*
 */
+ (NSString*)urlEncode:(NSDictionary*)payload {
    NSMutableString *str = [@"" mutableCopy];

    for (id key in payload) {
        if (![str isEqualToString:@""]) {
            [str appendString:@"&"];
        }

        [str appendString:[NSString stringWithFormat:@"%@=%@", key, payload[key]]];
    }

    return str;
}

/**
 * Besorge den Ticker von Poloniex
 *
 * @param fiatCurrencies
 * @return NSDictionary*
 */
+ (NSDictionary*)poloniexTicker:(NSArray*)fiatCurrencies {
    NSString *jsonURL = @"https://poloniex.com/public?command=returnTicker";

    NSMutableDictionary *ticker = [[Brokerage jsonRequest:jsonURL] mutableCopy];

    if (!ticker[@"BTC_XMR"]) {
        NSLog(@"API-ERROR: Cannot retrieve ticker data from poloniex");

        return nil;
    }

    NSDictionary *btcTicker = [Brokerage bitstampBTCTicker:fiatCurrencies[0]];

    if (!btcTicker) {
        return nil;
    }

    NSNumber *exchangeRate = [Brokerage fiatExchangeRate:fiatCurrencies];

    if (!exchangeRate) {
        return nil;
    }

    NSString *btcFiat = [NSString stringWithFormat:@"%@_%@", ASSET1, fiatCurrencies[0]];
    ticker[btcFiat] = btcTicker;
    ticker[fiatCurrencies[1]] = @([exchangeRate doubleValue]);


    ticker[@"BTC_BCC"] = ticker[@"BTC_BCH"];

    return ticker;
}

/**
 * Besorge den Ticker von Bittrex
 *
 * @param fiatCurrencies
 * @return NSDictionary*
 */
+ (NSDictionary*)bittrexTicker:(NSArray*)fiatCurrencies forCurrencyPairs:(NSArray*)currencyPairs {

    NSMutableDictionary *ticker = [[NSMutableDictionary alloc] init];
    for (id key in currencyPairs) {
        if ([key isEqualToString:ASSET1]) continue;

        NSString *pair = [NSString stringWithFormat:@"%@-%@", [ASSET1 lowercaseString], [key lowercaseString]];
        NSString *jsonURL = [NSString stringWithFormat:@"https://bittrex.com/api/v1.1/public/getmarketsummary?market=%@", pair];

        NSMutableDictionary *innerTicker = [[Brokerage jsonRequest:jsonURL] mutableCopy];

        if (!innerTicker[@"result"]) {
            NSLog(@"API-ERROR: Cannot retrieve ticker data from bittrex for key %@", key);

            return nil;
        }

        if ([innerTicker[@"message"] isEqualToString:@"INVALID_MARKET"]) {
            NSLog(@"Invalid Market: %@/%@", ASSET1, key);
            continue;
        }

        NSDictionary *data = innerTicker[@"result"][0];

        if (!data[@"MarketName"]) {
            return nil;
        }

        NSString *marketName = data[@"MarketName"];

        marketName = [marketName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];

        double percent = ([data[@"Last"] doubleValue] / [data[@"PrevDay"] doubleValue]) -1;

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
    }

    NSDictionary *btcTicker = [Brokerage bitstampBTCTicker:fiatCurrencies[0]];

    if (!btcTicker) {
        return nil;
    }

    NSNumber *exchangeRate = [Brokerage fiatExchangeRate:fiatCurrencies];

    if (!exchangeRate) {
        return nil;
    }

    NSString *btcFiat = [NSString stringWithFormat:@"%@_%@", ASSET1, fiatCurrencies[0]];
    ticker[btcFiat] = btcTicker;
    ticker[fiatCurrencies[1]] = @([exchangeRate doubleValue]);

    return ticker;
}

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
+ (NSDictionary*)bitstampBTCTicker:(NSString*)asset {
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

/**
 * Warte timeout Sekunden
 *
 * @param timeout
 */
+ (void)safeSleep:(NSTimeInterval)timeout {
    [NSThread sleepForTimeInterval:timeout];
}

/**
 * Prüfe, ob es überhaupt eine Netzwerkverbindung gibt
 *
 * @return BOOL
 */
+ (BOOL) isInternetConnection {
    BOOL returnValue = NO;

    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;

    SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr*)&zeroAddress);

    if (reachabilityRef != NULL) {
        SCNetworkReachabilityFlags flags;

        if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
            BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
            BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
            returnValue = isReachable && !connectionRequired;
        }

        CFRelease(reachabilityRef);
    }

    return returnValue;
}

@end
