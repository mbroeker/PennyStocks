//
//  OrderData.h
//  PennyStocks
//
//  Created by Markus Bröker on 26.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderData : NSObject
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *pair;
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, copy) NSString *rate;

/**
 *
 * @param data
 * @return
 */
- (id)initWithArray:(NSArray *)data;

/**
 *
 * @return
 */
+ (NSArray *)fetchOrderData;

/**
 *
 * @return
 */
- (BOOL)cancelOrder;

@end
