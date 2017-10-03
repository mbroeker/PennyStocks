//
//  Calculator+Migration.h
//  PennyStocks
//
// Created by Markus Bröker on 03.10.17.
// Copyright (c) 2017 Markus Bröker. All rights reserved.
//

#import "Calculator.h"

@interface Calculator (Migration)

/**
 * Migration of Preferences
 *
 * MIGRATION OF
 *      KEY_CURRENT_SALDO
 *      KEY_INITIAL_RATINGS
 *      KEY_SALDO_URLS
 */
+ (void)migrateSaldoAndRatings;

/**
 * Migration of Preferences
 *
 * Migrate TV_APPLICATIONS
 */
+ (NSMutableDictionary *)migrateApplications;

/**
 * Migration of Preferences
 *
 * REMOVAL OF
 *      KEY_CURRENT_SALDO
 *      KEY_INITIAL_RATINGS
 *      KEY_SALDO_URLS
 */
+ (void)reset;

@end