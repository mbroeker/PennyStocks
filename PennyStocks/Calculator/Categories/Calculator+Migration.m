//
//  Calculator+Migration.m
//  PennyStocks
//
// Created by Markus Bröker on 03.10.17.
// Copyright (c) 2017 Markus Bröker. All rights reserved.
//

#import "Calculator+Migration.h"

@implementation Calculator (Migration)

/**
 * Migration der URLs, Saldo und Ratings
 */
+ (void)migrateSaldoAndRatings {
    BOOL mustUpdate = NO;

    Calculator *calculator = [Calculator instance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *saldoUrls = [[defaults objectForKey:KEY_SALDO_URLS] mutableCopy];
    NSMutableDictionary *currentSaldo = [[defaults objectForKey:KEY_CURRENT_SALDO] mutableCopy];
    NSMutableDictionary *initialRatings = [[defaults objectForKey:KEY_INITIAL_RATINGS] mutableCopy];

    NSDictionary *tickerKeys = [calculator tickerKeys];
    NSDictionary *tickerKeysDescription = [calculator tickerKeysDescription];

    if (!saldoUrls[DASHBOARD]) {
        saldoUrls[DASHBOARD] = @"https://coinmarketcap.com/gainers-losers/";

        mustUpdate = YES;
    }

    if (!saldoUrls[ASSET_DESC(1)]) {
        NSString *exchange = ([calculator.defaultExchange isEqualToString:EXCHANGE_BITTREX]) ? @"bittrex" : @"poloniex";
        saldoUrls[ASSET_DESC(1)] = [NSString stringWithFormat:@"https://coinmarketcap.com/exchanges/%@/", exchange];

        mustUpdate = YES;
    }

    for (id key in tickerKeysDescription) {
        if (!saldoUrls[key]) {
            if ([calculator.defaultExchange isEqualToString:EXCHANGE_BITTREX]) {
                saldoUrls[key] = [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), tickerKeysDescription[key]];
            } else {
                saldoUrls[key] = [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, [tickerKeysDescription[key] lowercaseString]];
            }

            mustUpdate = YES;
        }
    }

    for (id key in tickerKeys) {
        if (!initialRatings[key]) {
            initialRatings[key] = @0;

            mustUpdate = YES;
        }
    }

    for (id key in tickerKeys) {
        if (!currentSaldo[key]) {
            currentSaldo[key] = @0;

            mustUpdate = YES;
        }
    }

    if (saldoUrls.count != 11) {
        mustUpdate = YES;
    }

    if (mustUpdate) {
        #ifdef DEBUG
        NSLog(@"Migrating Calculator settings...");
        #endif

        NSMutableDictionary *tempSaldoURLs = [saldoUrls mutableCopy];
        NSMutableDictionary *tempCurrentSaldo = [currentSaldo mutableCopy];
        NSMutableDictionary *tempInitialRatings = [initialRatings mutableCopy];

        for (id key in saldoUrls) {
            if ([tickerKeysDescription objectForKey:key] == nil) {
                if (![key isEqualToString:DASHBOARD]) {
                    [tempSaldoURLs removeObjectForKey:key];
                }
            }
        }

        for (id key in currentSaldo) {
            if ([tickerKeys objectForKey:key] == nil) {
                [tempCurrentSaldo removeObjectForKey:key];
                [tempInitialRatings removeObjectForKey:key];
            }
        }

        // Zurückspielen nicht vergessen
        [calculator saldoUrlsForDictionary:tempSaldoURLs];
        [calculator currentSaldoForDictionary:tempCurrentSaldo];
        [calculator initialRatingsWithDictionary:tempInitialRatings];
    }
}

/**
 * Migration der Applications
 */
+ (NSMutableDictionary *)migrateApplications {
    BOOL mustUpdate = NO;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    Calculator *calculator = [Calculator instance];
    NSMutableDictionary *applications = [[defaults objectForKey:TV_APPLICATIONS] mutableCopy];
    NSDictionary *tickerKeysDescription = [calculator tickerKeysDescription];

    for (id key in tickerKeysDescription) {
        if (!applications[key]) {
            applications[key] = @"";
            mustUpdate = YES;
        }
    }

    if (applications.count != 10) {
        mustUpdate = YES;
    }

    if (mustUpdate) {
        #ifdef DEBUG
        NSLog(@"Migrating applications...");
        #endif

        NSMutableDictionary *tempApplications = [applications mutableCopy];

        for (id key in applications) {
            if ([tickerKeysDescription objectForKey:key] == nil) {
                [tempApplications removeObjectForKey:key];
            }
        }

        applications = tempApplications;
        [defaults setObject:tempApplications forKey:TV_APPLICATIONS];

        [defaults synchronize];
    }

    return applications;
}

/**
 * Statische Reset-Methode zum Abräumen
 *
 */
+ (void)reset {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults removeObjectForKey:KEY_CURRENT_ASSETS];
    [defaults removeObjectForKey:KEY_CURRENT_SALDO];
    [defaults removeObjectForKey:KEY_DEFAULT_EXCHANGE];
    [defaults removeObjectForKey:KEY_FIAT_CURRENCIES];
    [defaults removeObjectForKey:KEY_INITIAL_RATINGS];
    [defaults removeObjectForKey:KEY_SALDO_URLS];

    [defaults synchronize];
}

@end