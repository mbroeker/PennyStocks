//
//  PennyStocksTests.m
//  PennyStocksTests
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../PennyStocks/Common/Calculator.h"

@interface PennyStocksTests : XCTestCase
    @property Calculator *calculator;
@end

@implementation PennyStocksTests

- (void)setUp {
    [super setUp];

    self.calculator = [Calculator instance];
}

- (void)tearDown {
    [super tearDown];
}

/**
 * Check TickerStatus and Key Mappings on Poloniex
 *
 */
- (void)testPoloniexTicker {
    NSDictionary *result = [Brokerage poloniexTicker:@[EUR, USD]];
    NSArray *tickerKeys = [self.calculator.tickerKeys allValues];

    NSLog(@"Testing all Ticker Keys on Poloniex");
    for (id key in tickerKeys) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@_%@", ASSET1, EUR]]) {
            continue;
        }

        XCTAssertNotNil(result[key], @"Key %@ is missing", key);
    }
}

/**
 * Check TickerStatus and Key Mappings on Bittrex
 *
 */
- (void)testBittrexTicker {
    NSDictionary *result = [Brokerage bittrexTicker:@[EUR, USD] forAssets:[self.calculator.tickerKeys allKeys]];
    NSArray *tickerKeys = [self.calculator.tickerKeys allValues];

    NSLog(@"Testing all Ticker Keys on Bittrex");
    for (id key in tickerKeys) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@_%@", ASSET1, EUR]]) {
            continue;
        }

        XCTAssertNotNil(result[key], @"Key %@ is missing", key);
    }
}

@end
