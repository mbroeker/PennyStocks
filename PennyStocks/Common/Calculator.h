//
//  Calculator.h
//  PennyStocks
//
// Created by Markus Bröker on 28.04.17.
// Copyright (c) 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brokerage.h"

@interface Calculator : NSObject

/**
 * Static Constructor implemented as singleton
 *
 * @return id
 */
+ (id)instance;

/**
 * Static Constructor implemented as singleton
 *
 * @param currencies
 * @return id
 */
+ (id)instance:(NSArray *)currencies;

+ (void)reset;

/**
 * INTERNAL SWITCH FOR AUTOMATED TRADING
 */
@property BOOL automatedTrading;

/**
 * SELL the current amount of ASSETs back into the MASTER-ASSET (ETH) IF the PROFIT is higher than "wantedEuros"
 *
 * @param wantedEuros
 */
- (void)sellWithProfitInEuro:(double)wantedEuros;

/**
 * SELL the current amount of ASSETs back into the MASTER-ASSET (ETH) IF the EXCHANGE-RATE is higher than "wantedPercent"
 *
 * @param wantedPercent
 */
- (void)sellWithProfitInPercent:(double)wantedPercent;

/**
 * SELL the current amount of ASSET's back into the MASTER-ASSET (ETH) IF the INVESTMENT-RATE is higher than "wantedPercent"
 *
 * @param wantedPercent
 */
- (void)sellByInvestors:(double)wantedPercent;

/**
 * BUY with the current amount of MASTER-ASSET (ETH) ANY ASSET WITH an EXCHANGE-RATE of "wantedPercent" and an INVESTMENT-RATE greater than "wantedRate"
 *
 * @param wantedPercent
 * @param wantedRate
 */
- (void)buyWithProfitInPercent:(double)wantedPercent andInvestmentRate:(double)wantedRate;

/**
 * BUY with the current amount of MASTER-ASSET (ETH) ANY ASSET WITH an investmentRate greater than "wantedRate"
 *
 * @param wantedRate
 */
- (void)buyByInvestors:(double)wantedRate;

/**
 * BUY with the current amount of MASTER-ASSET (ETH) the ASSET the highest INVESTMENT-RATE
 */
- (void)buyTheBest;

/**
 * BUY with the current amount of MASTER-ASSET (ETH) the ASSET the lowest INVESTMENT-RATE
 */
- (void)buyTheWorst;

- (NSString *)autoBuy:(NSString *)cAsset amount:(double)wantedAmount;

/**
 * BUY a specific ASSET with given parameters and rate and return the orderNumber
 *
 * @param cAsset
 * @param wantedAmount
 * @param wantedRate
 * @return NSString*
 */
- (NSString *)autoBuy:(NSString *)cAsset amount:(double)wantedAmount withRate:(double)wantedRate;

/**
 * SELL a specific ASSET with the given parameters and return the orderNumber
 *
 * @param cAsset
 * @param wantedAmount
 * @return NSString*
 */
- (NSString *)autoSell:(NSString *)cAsset amount:(double)wantedAmount;

/**
 * SELL a specific ASSET with the given parameters and "wantedRate" and return the orderNumber
 *
 * @param cAsset
 * @param wantedAmount
 * @param wantedRate
 * @return NSString*
 */
- (NSString *)autoSell:(NSString *)cAsset amount:(double)wantedAmount withRate:(double)wantedRate;

/**
 * BUY the given ASSET with the current amount of MASTER ASSET (ETH) to the current conditions
 *
 * @param cAsset
 */
- (void)autoBuyAll:(NSString *)cAsset;

/**
 * SELL the current amount of ASSET to the current conditions back into the MASTER-ASSET (ETH)
 *
 * @param cAsset
 */
- (void)autoSellAll:(NSString *)cAsset;

/**
 * Updates the balances automatically via API-KEY
 *
 * @param synchronized
 */
- (void)updateBalances:(BOOL)synchronized;

/**
 * Sums up the current balances of all cryptos in Fiat-Money (EUR, USD, GBP, JPY, CNY)
 *
 * @param currency
 * @return double
 */
- (double)calculate:(NSString *)currency;

/**
 * Sums up the current balances of all cryptos in Fiat-Money (EUR, USD, GBP, JPY, CNY) with specific ratings
 *
 * @param ratings
 * @param currency
 * @return double
 */
- (double)calculateWithRatings:(NSDictionary *)ratings currency:(NSString *)currency;

/**
 * Calculation of the Price/Volume/Ratio
 *
 * @return NSDictionary*
 */
- (NSDictionary *)realPrices;

/**
 * Calculate the ETH Price for the given ASSET
 *
 * @param asset
 * @return
 */
- (double)ethPriceForAsset:(NSString *)asset;

/**
 * Calculate the FIAT Price for the given ASSET with current settings(EUR, USD, GBP, CNY, JPY)
 *
 * @param asset
 * @return
 */
- (double)fiatPriceForAsset:(NSString *)asset;

/**
 * Calculate the current exchange factor for the given ASSET in relation to another asset
 *
 * @param asset
 * @param baseAsset
 * @return
 */
- (double)factorForAsset:(NSString *)asset inRelationTo:(NSString *)baseAsset;

/**
 * Update the internal ticker
 *
 * @param synchronized
 */
- (void)updateRatings:(BOOL)synchronized;

/**
 * SET the current Checkpoint for the given ASSET or all ASSETS(DASHBOARD)
 *
 * @param asset
 * @param btcUpdate
 */
- (void)updateCheckpointForAsset:(NSString *)asset withBTCUpdate:(BOOL)btcUpdate;

/**
 * SET a new Checkpoint for the given ASSET and a specific rate in MASTER-ASSET (ETH)
 *
 * @param asset
 * @param btcUpdate
 * @param wantedRate
 */
- (void)updateCheckpointForAsset:(NSString *)asset withBTCUpdate:(BOOL)btcUpdate andRate:(double)wantedRate;

/**
 * Get the current amount of an specific ASSET
 *
 * @param asset
 * @return
 */
- (double)currentSaldo:(NSString *)asset;

/**
 * SET the current amount of an ASSET to "saldo"
 *
 * @param asset
 * @param saldo
 */
- (void)currentSaldo:(NSString *)asset withDouble:(double)saldo;

/**
 * GETTER for an specific ASSET
 *
 * @param label
 * @return NSString*
 */
- (NSString *)saldoUrlForLabel:(NSString *)label;

/**
 * GET the current CHECKPOINT for an specific ASSET
 *
 * @param asset
 * @return NSDictionary*
 */
- (NSDictionary *)checkpointForAsset:(NSString *)asset;

/**
 * Retrieve the current checkpoint changes
 *
 * @return NSDictionary*
 */
- (NSDictionary *)checkpointChanges;

/**
 * Replaces internal SALDO Dictionary with "dictionary"
 *
 * @param dictionary
 */
- (void)currentSaldoForDictionary:(NSMutableDictionary *)dictionary;

/**
 * Replaces the internal saldoUrls (ADDRESSES) with "dictionary"
 *
 * @param dictionary
 */
- (void)saldoUrlsForDictionary:(NSMutableDictionary *)dictionary;

/**
 * Replaces the internal "initialRatings" with "dictionary"
 *
 * @param dictionary
 */
- (void)initialRatingsWithDictionary:(NSMutableDictionary *)dictionary;

/**
 * Get the current used exchange
 *
 * @return
 */
- (NSString *)defaultExchange;

/**
 * SET the exchange to use for further operations
 *
 * @param exchange
 */
- (void)defaultExchange:(NSString *)exchange;

/**
 * Retrieve the currently active Fiat-Currency-Pair (EUR/USD) or (USD/EUR) ...
 *
 * @return NSArray*
 */
- (NSArray *)fiatCurrencies;

/**
 * Get an editable copy of the currentSaldo
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)currentSaldo;

/**
 * Get an editable copy of the current saldoUrls
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)saldoUrls;

/**
 * Get an editable copy of the initalRatings
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)initialRatings;

/**
 * Get an editable copy of the currentRatings
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)currentRatings;

/**
 * Get an editable copy of the current ticker
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)ticker;

/**
 * Get a dictionary with the 10 tickerKeys
 *
 * @return NSDictionary*
 */
- (NSDictionary *)tickerKeys;
@end
