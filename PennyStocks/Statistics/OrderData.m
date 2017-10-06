//
//  OrderData.m
//  PennyStocks
//
//  Created by Markus Bröker on 26.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "OrderData.h"
#import "Brokerage.h"
#import "Calculator.h"

@implementation OrderData

/**
 *
 */
+ (NSArray*)fetchOrderData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *defaultExchange = [defaults objectForKey:KEY_DEFAULT_EXCHANGE];
    NSDictionary *apiKey = [[Calculator instance] apiKey];
    NSDictionary *ak = apiKey[@"apiKey"];
    NSString *sk = apiKey[@"secret"];

    if (ak == nil || sk == nil) {
        return nil;
    }

    NSArray *fetchedData = [Brokerage openOrders:ak withSecret:sk onExchange:defaultExchange];

    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0; i < fetchedData.count; i++) {
        data[i] = [[OrderData alloc] initWithArray:fetchedData[i]];
    }

    return data;
}

/**
 *
 */
- (id)initWithArray:(NSArray*)data {
    if (self = [super init]) {
        self.orderId = data[0];
        self.date = data[1];
        self.pair = data[2];
        self.amount = data[3];
        self.rate = data[4];
    }

    return self;
}

/**
 *
 * @return
 */
- (BOOL)cancelOrder {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *defaultExchange = [defaults objectForKey:KEY_DEFAULT_EXCHANGE];
    NSDictionary *apiKey = [[Calculator instance] apiKey];
    NSDictionary *ak = apiKey[@"apiKey"];
    NSString *sk = apiKey[@"secret"];

    if (ak == nil || sk == nil) {
        return NO;
    }

    return [Brokerage cancelOrder:ak withSecret:sk orderId:self.orderId onExchange:defaultExchange];
}

@end
