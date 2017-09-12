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

+ (id)instance;
+ (id)instance:(NSArray*)currencies;

+ (void)reset;

// Simpler Schalter zum Aktivieren und Deaktivieren der Trading API
@property BOOL automatedTrading;

// Trading API
- (void)sellWithProfitInEuro:(double)wantedEuros;
- (void)sellWithProfitInPercent:(double)wantedPercent;
- (void)sellByInvestors:(double)rate;
- (void)buyWithProfitInPercent:(double)wantedPercent andInvestmentRate:(double) rate;
- (void)buyByInvestors:(double)rate;
- (void)buyTheBest;
- (void)buyTheWorst;
- (NSString*)autoBuy:(NSString*)cAsset amount:(double)wantedAmount;
- (NSString*)autoSell:(NSString*)cAsset amount:(double)wantedAmount;
- (void)autoBuyAll:(NSString*)cAsset;
- (void)autoSellAll:(NSString*)cAsset;
- (void)updateBalances:(BOOL)synchronized;

// Umrechnungsmethoden für Crypto-Währungen
- (double)calculate:(NSString*)currency;
- (double)calculateWithRatings:(NSDictionary*)ratings currency:(NSString *)currency;
- (NSDictionary*)realPrices;
- (double)btcPriceForAsset:(NSString*)asset;
- (double)fiatPriceForAsset:(NSString*)asset;
- (double)factorForAsset:(NSString*)asset inRelationTo:(NSString*)baseAsset;

// Methoden fürs Aktualisieren der Wechselkurse und zum Updaten dieser
- (void)updateRatings:(BOOL)synchronized;
- (void)updateCheckpointForAsset:(NSString *)asset withBTCUpdate:(BOOL) btcUpdate;

// Methoden für das Aktualisieren des Saldos
- (double)currentSaldo:(NSString*)asset;
- (void)currentSaldo:(NSString*)asset withDouble:(double) saldo;

// Getter für einen spezifischen Saldo
- (NSString*)saldoUrlForLabel:(NSString*)label;

// Setter für die jeweiligen Dictionaries
- (NSDictionary*)checkpointForAsset:(NSString*)asset;
- (NSDictionary*)checkpointChanges;
- (void)currentSaldoForDictionary:(NSMutableDictionary*)dictionary;
- (void)saldoUrlsForDictionary:(NSMutableDictionary*)dictionary;
- (void)initialRatingsWithDictionary:(NSMutableDictionary*)dictionary;

// Setzten der Standardbörse
- (void)defaultExchange:(NSString*)exchange;

// die aktuellen Fiat-Währungen
- (NSArray*)fiatCurrencies;

// Getter für die Dictionaries
- (NSMutableDictionary*)currentSaldo;
- (NSMutableDictionary*)saldoUrls;
- (NSMutableDictionary*)initialRatings;
- (NSMutableDictionary*)currentRatings;
- (NSMutableDictionary*)ticker;
- (NSDictionary*)tickerKeys;
@end