//
//  PennyStocksTests.m
//  PennyStocksTests
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../PennyStocks/Common/Calculator.h"
#import "../PennyStocks/Common/KeychainWrapper.h"
#import "../PennyStocks/Brokerage/Categories/Brokerage+JSON.h"
#import "../PennyStocks/Brokerage/Algorithm.h"

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

    [Calculator reset];
}

/**
 * Check TickerStatus and Key Mappings on Poloniex
 *
 */
- (void)testPoloniexTicker {
    NSDictionary *result = [Brokerage poloniexTicker:@[EUR, USD]];
    NSArray *tickerKeys = [self.calculator.tickerKeys allValues];

    NSLog(@"TESTING ALL KEYS ON POLONIEX");
    for (id key in tickerKeys) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@_%@", ASSET1, EUR]]) {
            continue;
        }

        XCTAssertNotNil(result[key], @"MISSING %@", key);
    }
}

/**
 * Check TickerStatus and Key Mappings on Bittrex
 *
 */
- (void)testBittrexTicker {
    NSDictionary *result = [Brokerage bittrexTicker:@[EUR, USD] forAssets:[self.calculator.tickerKeys allKeys]];
    NSArray *tickerKeys = [self.calculator.tickerKeys allValues];

    NSLog(@"TESTING ALL KEYS ON BITTREX");
    for (id key in tickerKeys) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@_%@", ASSET1, EUR]]) {
            continue;
        }

        XCTAssertNotNil(result[key], @"MISSING %@", key);
    }
}

/**
 * Check Keychain Management
 *
 */
- (void)testKeychain {
    // Create a TEST API-KEY AND CHECK the presence
    [KeychainWrapper createKeychainValue:@"key:secret" forIdentifier:@"TEST"];
    NSDictionary *test = [KeychainWrapper keychain2ApiKeyAndSecret:@"TEST"];
    XCTAssertNotNil(test, @"INVALID API-KEY");

    // Delete the Test API-KEY AND CHECK the removal
    [KeychainWrapper deleteItemFromKeychainWithIdentifier:@"TEST"];
    test = [KeychainWrapper keychain2ApiKeyAndSecret:@"TEST"];
    XCTAssertNil(test, @"API-KEY WAS NOT DELETED");
}

/**
 * Check Balances and Number of ASSETS
 */
- (void)testCurrentBalance {
    [self.calculator updateBalances:true];

    XCTAssert([[self.calculator currentSaldo] count] == 10, @"NUMBER OF ASSETS != 10");
}

/**
 * Check test calls to quandl
 */
- (void)testQuandlDatabase {
    NSString *key = [KeychainWrapper keychainStringFromMatchingIdentifier:@"QUANDL"];

    if (key == nil) {
        NSLog(@"YOU NEED A VALID API KEY ON QUANDL FOR THIS TEST");
        return;
    }

    NSString *baseAsset = ASSET1;
    NSString *asset = ASSET6;

    NSString *queryUrl = [NSString stringWithFormat:@"https://www.quandl.com/api/v3/datasets/BTER/%@%@.json?api_key=%@", asset, baseAsset, key];

    NSDictionary *response = [Brokerage jsonRequest:queryUrl];
    NSDictionary *dataset = response[@"dataset"];
    NSArray *data = dataset[@"data"];

    NSMutableDictionary *historicalData = [[NSMutableDictionary alloc] init];

    for (id value in data) {
        NSDictionary *row = @{
            @"high": value[1],
            @"low": value[2],
            @"last": value[3],
        };

        historicalData[value[0]] = row;
    }

    NSLog(@"RESULT: %@", historicalData);
}

/**
 * Check GAUSS Algorithm
 */
- (void)testGaussAlgorithm {
    NSArray *equation = @[
        @[@(2), @(3), @(27)],
        @[@(3), @(2), @(28)],
    ];

    NSArray *result = [Algorithm gaussAlgorithm:equation];

    NSArray *solution = @[
        @[@(1), @(0), @(6)],
        @[@(0), @(1), @(5)],
    ];

    XCTAssert([result isEqualToArray:solution], @"COMPUTED SOLUTION DIFFERS: %@", result);
}

/**
 * Check Nearest Rounding Method
 */
- (void)testNearest {
    double value = 0.12345678;

    NSLog(@"ROUNDING %.8f INTERNALY TO %.4f", value, value);

    double nearest = [Algorithm nearest:value withAccuracy:4];
    XCTAssert(nearest == 0.1235, @"Assumpion failed %f", nearest);
}

@end
