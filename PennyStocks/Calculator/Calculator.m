//
//  Calculator.m
//  PennyStocks
//
// Created by Markus Bröker on 28.04.17.
// Copyright (c) 2017 Markus Bröker. All rights reserved.
//

#import "Calculator.h"
#import "Helper.h"
#import "KeychainWrapper.h"

/**
 * Berechnungklasse für Crypto-Währungen
 */
@implementation Calculator {
    // Synchronisierte Einstellungen und Eigenschaften
    NSMutableDictionary *initialRatings;
    NSMutableDictionary *currentSaldo;
    NSMutableDictionary *saldoUrls;

    // Normale Eigenschaften
    NSMutableDictionary *currentRatings;
    NSMutableDictionary *ticker;

    // Die wählbare Fiatwährung
    NSArray *fiatCurrencies;

    // Die dynamischen TickerKeys
    NSDictionary *tickerKeys;
    NSDictionary *tickerKeysDescription;

    // Die standardmäßige Börse
    NSString *defaultExchange;

    // Mit oder ohne Abfrage
    NSNumber *tradingWithConfirmation;

    // Keychain Entries
    NSDictionary *keyAndSecret;
}

/**
 * Check for inf, nan or zero
 *
 * @param value
 */
+ (BOOL)zeroNanOrInfinity:(double)value {
    BOOL zeroNanOrInfinity = ((value == 0.0) || isinf(value) || isnan(value));

    return zeroNanOrInfinity;
}

/**
 *
 * @return
 */
+ (NSArray *)initialAssets {
    NSDebug(@"Calculator::initialAssets");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *assets = [defaults objectForKey:KEY_CURRENT_ASSETS];

    if (assets == nil) {
        NSDebug(@"Creating inital assets");

        assets = @[
            @[DASHBOARD, DASHBOARD],
            @[@"ETH", @"Ethereum"],
            @[@"DASH", @"Digital Cash"],
            @[@"ZEC", @"ZCash"],
            @[@"LTC", @"Litecoin"],
            @[@"NEO", @"Neo"],
            @[@"QTUM", @"Qtum"],
            @[@"OMG", @"Omise GO"],
            @[@"MCO", @"Monaco"],
            @[@"PAY", @"Pay Token"],
            @[@"BAT", @"Basic Attention"],
        ];

        [defaults setObject:assets forKey:KEY_CURRENT_ASSETS];
        [defaults synchronize];
    }

    return assets;
}

/**
 *
 * @param row
 * @param index
 * @return
 */
+ (NSString *)assetString:(unsigned int)row withIndex:(unsigned int)index {
    static NSArray *assets = nil;

    if (assets == nil) {
        assets = [Calculator initialAssets];
    }

    return assets[row][index];
}

/**
 * Der öffentliche Konstruktor mit Vorbelegung EUR/USD
 *
 * @return id
 */
+ (id)instance {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *fc = [defaults objectForKey:KEY_FIAT_CURRENCIES];

    // Vorbelegung mit EUR/USD
    if (fc == nil) {
        fc = @[EUR, USD];
    }

    return [Calculator instance:fc];
}

/**
 * Der öffentliche Konstruktor als statisches Singleton mit wählbaren Fiat-Währungen
 *
 * @param currencies
 * @return id
 */
+ (id)instance:(NSArray *)currencies {
    static Calculator *calculator = nil;

    if (calculator == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            calculator = [[Calculator alloc] initWithFiatCurrencies:currencies];
        });
    }

    return calculator;
}

/**
 * Der Standard Konstruktor mit Vorbelegung EUR/USD
 *
 * @return id
 */
- (id)init {
    NSDebug(@"Calculator::init");

    return [Calculator instance:@[EUR, USD]];
}

/**
 * Der private Konstruktor der Klasse, der deswegen nicht in Calculator.h gelistet wird.
 *
 * @param currencies
 * @return id
 */
- (id)initWithFiatCurrencies:(NSArray *)currencies {
    NSDebug(@"Calculator::initWithFiatCurrencies:%@", currencies);

    if (self = [super init]) {

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        fiatCurrencies = currencies;

        defaultExchange = [defaults objectForKey:KEY_DEFAULT_EXCHANGE];

        if (defaultExchange == nil) {
            defaultExchange = EXCHANGE_BITTREX;

            [defaults setObject:defaultExchange forKey:KEY_DEFAULT_EXCHANGE];
        }

        currentSaldo = [[defaults objectForKey:KEY_CURRENT_SALDO] mutableCopy];

        if (currentSaldo == nil) {
            currentSaldo = [@{
                ASSET_KEY(1): @0.0,
                ASSET_KEY(2): @0.0,
                ASSET_KEY(3): @0.0,
                ASSET_KEY(4): @0.0,
                ASSET_KEY(5): @0.0,
                ASSET_KEY(6): @0.0,
                ASSET_KEY(7): @0.0,
                ASSET_KEY(8): @0.0,
                ASSET_KEY(9): @0.0,
                ASSET_KEY(10): @0.0,
            } mutableCopy];

            [defaults setObject:currentSaldo forKey:KEY_CURRENT_SALDO];
        }

        saldoUrls = [[defaults objectForKey:KEY_SALDO_URLS] mutableCopy];

        if (saldoUrls == nil) {

            if ([defaultExchange isEqualToString:EXCHANGE_BITTREX]) {
                saldoUrls = [@{
                    DASHBOARD: [NSString stringWithFormat:@"https://coinmarketcap.com/exchanges/bittrex/"],
                    ASSET_DESC(1): [NSString stringWithFormat:@"https://coinmarketcap.com/currencies/%@/", ASSET_DESC(1).lowercaseString],
                    ASSET_DESC(2): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(2)],
                    ASSET_DESC(3): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(3)],
                    ASSET_DESC(4): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(4)],
                    ASSET_DESC(5): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(5)],
                    ASSET_DESC(6): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(6)],
                    ASSET_DESC(7): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(7)],
                    ASSET_DESC(8): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(8)],
                    ASSET_DESC(9): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(9)],
                    ASSET_DESC(10): [NSString stringWithFormat:@"https://bittrex.com/Market/Index?MarketName=%@-%@", ASSET_KEY(1), ASSET_KEY(10)],
                } mutableCopy];
            } else {
                saldoUrls = [@{
                    DASHBOARD: [NSString stringWithFormat:@"https://coinmarketcap.com/exchanges/poloniex/"],
                    ASSET_DESC(1): [NSString stringWithFormat:@"https://coinmarketcap.com/currencies/%@/", ASSET_DESC(1).lowercaseString],
                    ASSET_DESC(2): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(2).lowercaseString],
                    ASSET_DESC(3): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(3).lowercaseString],
                    ASSET_DESC(4): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(4).lowercaseString],
                    ASSET_DESC(5): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(5).lowercaseString],
                    ASSET_DESC(6): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(6).lowercaseString],
                    ASSET_DESC(7): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(7).lowercaseString],
                    ASSET_DESC(8): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(8).lowercaseString],
                    ASSET_DESC(9): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(9).lowercaseString],
                    ASSET_DESC(10): [NSString stringWithFormat:@"https://poloniex.com/exchange#%@_%@", ASSET_KEY(1).lowercaseString, ASSET_KEY(10).lowercaseString],
                } mutableCopy];
            }

            [defaults setObject:saldoUrls forKey:KEY_SALDO_URLS];
        }

        tickerKeys = @{
            ASSET_KEY(1): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), fiatCurrencies[0]],
            ASSET_KEY(2): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(2)],
            ASSET_KEY(3): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(3)],
            ASSET_KEY(4): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(4)],
            ASSET_KEY(5): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(5)],
            ASSET_KEY(6): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(6)],
            ASSET_KEY(7): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(7)],
            ASSET_KEY(8): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(8)],
            ASSET_KEY(9): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(9)],
            ASSET_KEY(10): [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), ASSET_KEY(10)],
        };

        tickerKeysDescription = @{
            ASSET_DESC(1): ASSET_KEY(1),
            ASSET_DESC(2): ASSET_KEY(2),
            ASSET_DESC(3): ASSET_KEY(3),
            ASSET_DESC(4): ASSET_KEY(4),
            ASSET_DESC(5): ASSET_KEY(5),
            ASSET_DESC(6): ASSET_KEY(6),
            ASSET_DESC(7): ASSET_KEY(7),
            ASSET_DESC(8): ASSET_KEY(8),
            ASSET_DESC(9): ASSET_KEY(9),
            ASSET_DESC(10): ASSET_KEY(10),
        };

        tradingWithConfirmation = [defaults objectForKey:KEY_TRADING_WITH_CONFIRMATION];

        if (tradingWithConfirmation == nil) {
            tradingWithConfirmation = [NSNumber numberWithBool:YES];

            [defaults setObject:tradingWithConfirmation forKey:KEY_TRADING_WITH_CONFIRMATION];
        }

        [defaults synchronize];

        [self updateRatings:YES];
    }

    return self;
}

/**
 * Aktualisiere die Kurse der jeweiligen Währung
 *
 * @param asset
 * @param btcUpdate
 */
- (void)updateCheckpointForAsset:(NSString *)asset withBTCUpdate:(BOOL)btcUpdate {
    NSDebug(@"Calculator::updateCheckpointForAsset:%@ withBTCUpdate:%d", asset, btcUpdate);

    [self updateCheckpointForAsset:asset withBTCUpdate:btcUpdate andRate:0.0];
}

/**
 * Aktualisiere die Kurse der jeweiligen Währung
 *
 * @param asset
 * @param btcUpdate
 */
- (void)updateCheckpointForAsset:(NSString *)asset withBTCUpdate:(BOOL)btcUpdate andRate:(double)wantedRate {
    NSDebug(@"Calculator::updateCheckpointForAsset:%@ withBTCUpdate:%d andRate:%.8f", asset, btcUpdate, wantedRate);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (currentRatings == nil || initialRatings == nil) {
        NSDebug(@"updateCheckPointForAsset: NO DATA");

        return;
    }

    if ([asset isEqualToString:DASHBOARD]) {
        initialRatings = [currentRatings mutableCopy];
    } else {
        // aktualisiere den Kurs der Währung
        double priceInFiat = [self fiatPriceForAsset:ASSET_KEY(1)] * wantedRate;
        initialRatings[asset] = ((wantedRate == 0.0) ? currentRatings[asset] : @(1.0 / priceInFiat));

        if (![asset isEqualToString:ASSET_KEY(1)] && btcUpdate) {
            // aktualisiere den BTC Kurs, auf den sich die Transaktion bezog
            initialRatings[ASSET_KEY(1)] = currentRatings[ASSET_KEY(1)];
        }
    }

    [defaults setObject:initialRatings forKey:KEY_INITIAL_RATINGS];
    [defaults synchronize];
}

/**
 * Liefert NSDictionary mit den Schlüsseln "initialPrice", "currentPrice", "percent"
 *
 * @param asset
 * @return NSDictionary*
 */
- (NSDictionary *)checkpointForAsset:(NSString *)asset {
    //NSDebug(@"Calculator::checkpointForAsset:%@", asset);

    double initialAssetRating = [initialRatings[asset] doubleValue];
    double currentAssetRating = [currentRatings[asset] doubleValue];

    if (initialAssetRating == 0.0) {
        initialAssetRating = currentAssetRating;
        [self updateCheckpointForAsset:asset withBTCUpdate:false andRate:[self ethPriceForAsset:asset]];
    }

    double initialPrice = 1.0 / initialAssetRating;
    double currentPrice = 1.0 / currentAssetRating;

#ifdef DEBUG
    // Das darf einfach nicht passieren
    assert(![Calculator zeroNanOrInfinity:currentPrice]);
#endif

    double percent = 100.0 * ((currentPrice / initialPrice) - 1);

    return @{
        CP_INITIAL_PRICE: @(initialPrice),
        CP_CURRENT_PRICE: @(currentPrice),
        CP_PERCENT: @(percent)
    };
}

/**
 * Berechne den ETH-Preis
 *
 * @param asset
 * @return double
 */
- (double)ethPriceForAsset:(NSString *)asset {
    NSDebug(@"Calculator::ethPriceForAsset:%@", asset);

    double ethRating = [currentRatings[ASSET_KEY(1)] doubleValue];
    double assetRating = [currentRatings[asset] doubleValue];

    double ethPrice = ethRating / assetRating;
    return ethPrice;
}

/**
 * Berechne den Umrechnungsfaktor
 *
 * @param asset
 * @param baseAsset
 * @return double
 */
- (double)factorForAsset:(NSString *)asset inRelationTo:(NSString *)baseAsset {
    NSDebug(@"Calculator::factorForAsset:%@ inRelationTo:%@", asset, baseAsset);

    return [self ethPriceForAsset:baseAsset] / [self ethPriceForAsset:asset];
}

/**
 * Berechne den Fiat-Preis
 *
 * @param asset
 * @return double
 */
- (double)fiatPriceForAsset:(NSString *)asset {
    NSDebug(@"Calculator::fiatPriceForAsset:%@", asset);

    return (1 / [currentRatings[asset] doubleValue]);
}

/**
 * Liefert die aktuellen Veränderungen in Prozent
 *
 * @return NSDictionary*
 */
- (NSDictionary *)checkpointChanges {
    NSDebug(@"Calculator::checkpointChanges");

    NSMutableDictionary *checkpointChanges = [[NSMutableDictionary alloc] init];

    for (id cAsset in currentRatings) {
        if ([cAsset isEqualToString:USD]) { continue; }

        NSDictionary *aCheckpoint = [self checkpointForAsset:cAsset];
        double cPercent = [aCheckpoint[CP_PERCENT] doubleValue];

        checkpointChanges[cAsset] = @(cPercent);
    }

    return checkpointChanges;
}

/**
 * Berechne den Gesamtwert der Geldbörsen in Euro oder Dollar...
 *
 * @param currency
 * @return double
 */
- (double)calculate:(NSString *)currency {
    return [self calculateWithRatings:currentRatings currency:currency];
}

/**
 * Berechne den Gesamtwert der Geldbörsen in Euro oder Dollar mit den übergebenen Ratings
 *
 * @param ratings
 * @param currency
 * @return double
 */
- (double)calculateWithRatings:(NSDictionary *)ratings currency:(NSString *)currency {
    NSDebug(@"Calculator::calculateWithRatings:%@ currency:%@", ratings, currency);

    for (id key in ratings) {
        if ([Calculator zeroNanOrInfinity:[ratings[key] doubleValue]]) {
            NSDebug(@"ERROR IN CALCULATOR: VALUE FOR %@ OUT OF RANGE", key);
            return 0;
        }
    }

    double asset1Rating = [ratings[ASSET_KEY(1)] doubleValue];
    double asset2Rating = [ratings[ASSET_KEY(2)] doubleValue];
    double asset3Rating = [ratings[ASSET_KEY(3)] doubleValue];
    double asset4Rating = [ratings[ASSET_KEY(4)] doubleValue];
    double asset5Rating = [ratings[ASSET_KEY(5)] doubleValue];

    double asset6Rating = [ratings[ASSET_KEY(6)] doubleValue];
    double asset7Rating = [ratings[ASSET_KEY(7)] doubleValue];
    double asset8Rating = [ratings[ASSET_KEY(8)] doubleValue];
    double asset9Rating = [ratings[ASSET_KEY(9)] doubleValue];
    double asset10Rating = [ratings[ASSET_KEY(10)] doubleValue];

    double price1 = [currentSaldo[ASSET_KEY(1)] doubleValue] / asset1Rating;
    double price2 = [currentSaldo[ASSET_KEY(2)] doubleValue] / asset2Rating;
    double price3 = [currentSaldo[ASSET_KEY(3)] doubleValue] / asset3Rating;
    double price4 = [currentSaldo[ASSET_KEY(4)] doubleValue] / asset4Rating;
    double price5 = [currentSaldo[ASSET_KEY(5)] doubleValue] / asset5Rating;

    double price6 = [currentSaldo[ASSET_KEY(6)] doubleValue] / asset6Rating;
    double price7 = [currentSaldo[ASSET_KEY(7)] doubleValue] / asset7Rating;
    double price8 = [currentSaldo[ASSET_KEY(8)] doubleValue] / asset8Rating;
    double price9 = [currentSaldo[ASSET_KEY(9)] doubleValue] / asset9Rating;
    double price10 = [currentSaldo[ASSET_KEY(10)] doubleValue] / asset10Rating;

    double sum = price1 + price2 + price3 + price4 + price5 + price6 + price7 + price8 + price9 + price10;

    if ([currency isEqualToString:fiatCurrencies[0]]) {
        return sum;
    }

    return sum * [ratings[currency] doubleValue];
}

/**
 * Berechnet die realen Preise anhand des Handelsvolumens auf DEFAULT_EXCHANGE
 *
 * @return NSDictionary*
 */
- (NSDictionary *)realPrices {
    NSDebug(@"Calculator::realprices");

    NSMutableDictionary *volumes = [[NSMutableDictionary alloc] init];

    for (id key in tickerKeys) {
        double base = [ticker[tickerKeys[key]][POLONIEX_BASE_VOLUME] doubleValue];
        double quote = [ticker[tickerKeys[key]][POLONIEX_QUOTE_VOLUME] doubleValue];

        volumes[key] = @{
            @"in": @(base),
            @"out": @(quote)
        };
    }

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    for (id key in volumes) {
        if ([key isEqualToString:ASSET_KEY(1)]) {
            continue;
        }

        double v1 = [volumes[key][@"in"] doubleValue];
        double v2 = [volumes[key][@"out"] doubleValue];

        double realPrice = v1 / v2;
        double price = [currentRatings[ASSET_KEY(1)] doubleValue] / [currentRatings[key] doubleValue];
        double percentChange = ((price / realPrice) - 1) * 100.0;

        result[key] = @{
            RP_REALPRICE: @(realPrice),
            RP_PRICE: @(price),
            RP_CHANGE: @(percentChange)
        };
    }

    return result;
}

/**
 * Simple Changes
 *
 * @return NSDictionary*
 */
- (NSDictionary *)realChanges {
    NSDebug(@"Calculator::realChanges");

    NSDictionary *realPrices = [self realPrices];
    NSMutableDictionary *changes = [[NSMutableDictionary alloc] init];

    for (id key in realPrices) {
        changes[key] = [realPrices[key] objectForKey:RP_CHANGE];
    }

    return changes;
}

/**
 * Automatisches Kaufen von Assets
 *
 * @param cAsset
 * @param wantedAmount
 * @return NSString*
 */
- (NSString *)autoBuy:(NSString *)cAsset amount:(double)wantedAmount {
    NSDebug(@"Calculator::autoBuy:%@ amount:%8f", cAsset, wantedAmount);

    return [self autoBuy:cAsset amount:wantedAmount withRate:0.0];
}

/**
 * Automatisches Kaufen von Assets
 *
 * @param cAsset
 * @param wantedAmount
 * @param wantedRate
 * @return NSString*
 */
- (NSString *)autoBuy:(NSString *)cAsset amount:(double)wantedAmount withRate:(double)wantedRate {
    NSDebug(@"Calculator::autoBuy:%@ amount:%8f withRate:%.8f", cAsset, wantedAmount, wantedRate);

    NSDictionary *apiKey = [self apiKey];
    NSDictionary *ak = apiKey[@"apiKey"];
    NSString *sk = apiKey[@"secret"];

    double feeAsFactor = 1.0;

    if ([defaultExchange isEqualToString:EXCHANGE_BITTREX]) {
        feeAsFactor = 0.9975;
    }

    if (ak == nil || sk == nil) {
        return nil;
    }

    double btcPrice = [currentRatings[ASSET_KEY(1)] doubleValue];
    double assetPrice = [currentRatings[cAsset] doubleValue];
    double cRate = wantedRate;

    if (cRate == 0.0) {
        cRate = btcPrice / assetPrice;
    }

    // Bestimme die maximale Anzahl an ASSET_KEY(1)'s, die verkauft werden können...
    double amountMax = feeAsFactor * ([self currentSaldo:ASSET_KEY(1)] / cRate);
    double amount = amountMax;

    if (wantedAmount > 0) {
        amount = wantedAmount;
    }

    if ([cAsset isEqualToString:ASSET_KEY(1)] || [cAsset isEqualToString:fiatCurrencies[0]] || [cAsset isEqualToString:fiatCurrencies[1]]) {
        // Illegale Kombination ASSET_KEY(1)_(cAsset)
        return nil;
    }

    // Es kann maximal für amountMax gekauft werden...
    if (amount > amountMax) {
        NSString *mText = NSLocalizedString(@"not_enough_btc", @"Zu wenig BTC");
        NSString *iText = NSLocalizedString(@"not_enough_btc_long", @"Sie haben zu wenig BTC zum Kauf");
        [Helper notificationText:mText info:iText];
        return nil;
    }

    // Sollte einer dieser Beträge negativ sein, wird die Transaktion verhindert
    if (amount <= 0 || btcPrice <= 0 || assetPrice <= 0 || cRate <= 0) {
        NSString *mText = NSLocalizedString(@"not_enough_btc", @"Zu wenig BTC");
        NSString *iText = NSLocalizedString(@"not_enough_btc_long", @"Sie haben zu wenig BTC zum Kauf");
        [Helper notificationText:mText info:iText];
        return nil;
    }

    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"buy_with_amount_asset_and_rate", @"Kaufe %.4f %@ für %.8f das Stück"), amount, cAsset, cRate];

    // Bei 0 gibts eine Kaufbestätigung, bei < 0 wird instant gekauft
    if (wantedAmount >= 0) {
        if ([Helper messageText:NSLocalizedString(@"buy_confirmation", "Kaufbestätigung") info:text] != NSAlertFirstButtonReturn) {
            // Abort Buy
            return nil;
        }
    }

    NSString *cPair = [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), cAsset];
    NSDictionary *order = [Brokerage buy:ak withSecret:sk currencyPair:cPair rate:cRate amount:amount onExchange:defaultExchange];

    if (order[POLONIEX_ERROR]) {
        [Helper notificationText:NSLocalizedString(@"error", "Fehler") info:order[POLONIEX_ERROR]];
        return nil;
    }

    if (order[POLONIEX_ORDER_NUMBER]) {
        [self updateCheckpointForAsset:cAsset withBTCUpdate:YES andRate:cRate];

        return order[POLONIEX_ORDER_NUMBER];
    }

    return nil;
}

/**
 * Automatisches Verkaufen von Assets
 *
 * @param cAsset
 * @param wantedAmount
 * @return NSString*
 */
- (NSString *)autoSell:(NSString *)cAsset amount:(double)wantedAmount {
    NSDebug(@"Calculator::autoSell:%@ amount:%8f", cAsset, wantedAmount);

    return [self autoSell:cAsset amount:wantedAmount withRate:0.0];
}

/**
 * Automatisches Verkaufen von Assets
 *
 * @param cAsset
 * @param wantedAmount
 * @param wantedRate
 * @return NSString*
 */
- (NSString *)autoSell:(NSString *)cAsset amount:(double)wantedAmount withRate:(double)wantedRate {
    NSDebug(@"Calculator::autoSell:%@ amount:%8f withRate:%.8f", cAsset, wantedAmount, wantedRate);

    NSDictionary *apiKey = [self apiKey];
    NSDictionary *ak = apiKey[@"apiKey"];
    NSString *sk = apiKey[@"secret"];

    double feeAsFactor = 1.0;

    if ([defaultExchange isEqualToString:EXCHANGE_BITTREX]) {
        //feeAsFactor = 0.9975;
    }

    if (ak == nil || sk == nil) {
        return nil;
    }

    // Bestimme die maximale Anzahl an Assets, die verkauft werden können...
    double amountMax = feeAsFactor * [self currentSaldo:cAsset];
    double amount = amountMax;

    double btcPrice = [currentRatings[ASSET_KEY(1)] doubleValue];
    double assetPrice = [currentRatings[cAsset] doubleValue];

    if (wantedAmount > 0) {
        amount = wantedAmount;
    }

    if ([cAsset isEqualToString:ASSET_KEY(1)] || [cAsset isEqualToString:fiatCurrencies[0]] || [cAsset isEqualToString:fiatCurrencies[1]]) {
        // Illegale Kombination ASSET_KEY(1)_(cAsset)
        return nil;
    }

    double cRate = wantedRate;

    if (cRate == 0.0) {
        cRate = btcPrice / assetPrice;
    }

    // Sollte einer dieser Beträge negativ sein, wird die Transaktion verhindert
    if (amount > amountMax || amount <= 0 || btcPrice <= 0 || assetPrice <= 0 || cRate <= 0) {
        NSString *mText = [NSString stringWithFormat:NSLocalizedString(@"not_enough_asset_param", @"Zu wenig %@"), cAsset];
        NSString *iText = [NSString stringWithFormat:NSLocalizedString(@"not_enough_asset_long_param", @"Zu wenig %@ zum Verkaufen"), cAsset];
        [Helper notificationText:mText info:iText];
        return nil;
    }

    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"sell_with_amount_asset_and_rate", @"Verkaufe %.4f %@ für %.8f das Stück"), amount, cAsset, cRate];

    // Bei 0 gibts eine Verkaufsbestätigung, bei < 0 wird instant gekauft
    if (wantedAmount >= 0) {
        if ([Helper messageText:NSLocalizedString(@"sell_confirmation", @"Verkaufsbestätigung") info:text] != NSAlertFirstButtonReturn) {
            // Abort Sell
            return nil;
        }
    }

    NSString *cPair = [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), cAsset];
    NSDictionary *order = [Brokerage sell:ak withSecret:sk currencyPair:cPair rate:cRate amount:amount onExchange:defaultExchange];

    if (order[POLONIEX_ERROR]) {
        [Helper notificationText:NSLocalizedString(@"error", "Fehler") info:order[POLONIEX_ERROR]];
        return nil;
    }

    if (order[POLONIEX_ORDER_NUMBER]) {
        [self updateCheckpointForAsset:cAsset withBTCUpdate:NO andRate:cRate];

        return order[POLONIEX_ORDER_NUMBER];
    }

    return nil;
}

/**
 * Automatisches Kaufen...
 *
 * @param cAsset
 */
- (void)autoBuyAll:(NSString *)cAsset {
    NSDebug(@"Calculator::autoBuyAll:%@", cAsset);

    static NSString *lastBoughtAsset = @"";

    double ask = ([tradingWithConfirmation boolValue]) ? 0 : -1;
    if ([cAsset isEqualToString:lastBoughtAsset]) {
        // ask = 0;
    }

    if ([self autoBuy:cAsset amount:ask] != nil) {
        lastBoughtAsset = cAsset;

        // Aktualisiere alle Checkpoints
        [self updateCheckpointForAsset:DASHBOARD withBTCUpdate:YES];
    }
}

/**
 * Automatisches Verkaufen...
 *
 * @param cAsset
 */
- (void)autoSellAll:(NSString *)cAsset {
    NSDebug(@"Calculator::autoSellAll:%@", cAsset);

    double ask = ([tradingWithConfirmation boolValue]) ? 0 : -1;
    if ([self autoSell:cAsset amount:ask] != nil) {
        // Aktualisiere alle Checkpoints
        [self updateCheckpointForAsset:DASHBOARD withBTCUpdate:YES];
    }
}

/**
 * Verkaufe Altcoins, die im Wert um "wantedEuros" gestiegen ist
 *
 * @param wantedEuros
 */
- (void)sellWithProfitInEuro:(double)wantedEuros {
    NSDebug(@"Calculator::sellWithProfitInEuro:%.4f", wantedEuros);

    for (id key in currentSaldo) {
        if ([key isEqualToString:ASSET_KEY(1)]) { continue; }
        if ([key isEqualToString:fiatCurrencies[0]]) { continue; }
        if ([key isEqualToString:fiatCurrencies[1]]) { continue; }

        NSDictionary *checkpoint = [self checkpointForAsset:key];

        double initialPrice = [checkpoint[CP_INITIAL_PRICE] doubleValue];
        double currentPrice = [checkpoint[CP_CURRENT_PRICE] doubleValue];

        double initialBalanceInEUR = initialPrice * [self currentSaldo:key];
        double currentBalanceInEUR = currentPrice * [self currentSaldo:key];

        double gain = currentBalanceInEUR - initialBalanceInEUR;

        if (gain > wantedEuros) {
            [self autoSellAll:key];
        }
    }
}

/**
 * Verkaufe Altcoins mit mindestens 1 Euro im Bestand, deren Exchange-Rate um "wantedPercent" Prozent gestiegen ist...
 *
 * @param wantedPercent
 */
- (void)sellWithProfitInPercent:(double)wantedPercent {
    NSDebug(@"Calculator::sellWithProfitInPercent:%.4f %%", wantedPercent);

    for (id key in currentSaldo) {
        if ([key isEqualToString:ASSET_KEY(1)]) { continue; }
        if ([key isEqualToString:fiatCurrencies[0]]) { continue; }
        if ([key isEqualToString:fiatCurrencies[1]]) { continue; }

        NSDictionary *checkpoint = [self checkpointForAsset:key];
        NSDictionary *btcCheckpoint = [self checkpointForAsset:ASSET_KEY(1)];

        double currentPrice = [checkpoint[CP_CURRENT_PRICE] doubleValue];
        double btcPercent = [btcCheckpoint[CP_PERCENT] doubleValue];
        double percent = [checkpoint[CP_PERCENT] doubleValue];

        double effectiveBTCPercent = percent - btcPercent;
        double balance = currentPrice * [self currentSaldo:key];

        // Security Feature: We want more, not less
        if (effectiveBTCPercent < 0) {
            continue;
        }

        if ((effectiveBTCPercent > wantedPercent) && (balance > 1.0)) {
            [self autoSellAll:key];
        }
    }
}

/**
 * Verkaufe Assets mit einer Investor-Rate von "wantedPercent"% oder mehr...
 *
 * @param wantedPercent
 */
- (void)sellByInvestors:(double)wantedPercent {
    NSDebug(@"Calculator::sellByInvestors:%.4f %%", wantedPercent);

    NSDictionary *currencyUnits = [self realChanges];

    NSNumber *lowest = [[currencyUnits allValues] valueForKeyPath:@"@min.self"];

    if (lowest != nil) {
        NSString *lowestKey = [currencyUnits allKeysForObject:lowest][0];
        double investorsRate = [currencyUnits[lowestKey] doubleValue];

        double amount = [currentSaldo[lowestKey] doubleValue] * [self ethPriceForAsset:lowestKey];

        // Wir verkaufen keinen Sternenstaub...
        if (amount < 0.0001) { return; }

        // Verkaufe auf Grundlage der aktuellen Investoren-Rate
        if (investorsRate < wantedPercent) {
            [self autoSellAll:lowestKey];
        }
    }
}

/**
 * Verkaufe zum täglichen Höchstpreis
 */
- (void)sellHigh {
    NSDebug(@"Calculator::sellHigh");

    for (id key in tickerKeys) {
        if ([key isEqualToString:ASSET_KEY(1)]) continue;

        double high = [ticker[tickerKeys[key]][POLONIEX_HIGH24] doubleValue] * 0.99;

        double price = [self ethPriceForAsset:key];
        double amount = [currentSaldo[key] doubleValue] * price;

        // Wir verkaufen keinen Sternenstaub...
        if (amount < 0.0001) { continue; }

        if (price >= high) {
          [self autoSellAll:key];
        }
    }
}

/**
 * Kaufe Altcoins, deren Exchange-Rate um "wantedPercent" Prozent gestiegen ist...
 *
 * @param wantedPercent
 * @param wantedRate
 */
- (void)buyWithProfitInPercent:(double)wantedPercent andInvestmentRate:(double)wantedRate {
    NSDebug(@"Calculator::buyWithProfitInPercent:%.4f %% andInvestmentRate:%.8f", wantedPercent, wantedRate);

    double balance = [self currentSaldo:ASSET_KEY(1)];
    NSDictionary *realChanges = [self realChanges];

    if (balance < 0.0001) { return; }

    for (id key in currentSaldo) {
        if ([key isEqualToString:ASSET_KEY(1)]) { continue; }
        if ([key isEqualToString:fiatCurrencies[0]]) { continue; }
        if ([key isEqualToString:fiatCurrencies[1]]) { continue; }

        NSDictionary *checkpoint = [self checkpointForAsset:key];
        NSDictionary *btcCheckpoint = [self checkpointForAsset:ASSET_KEY(1)];

        double btcPercent = [btcCheckpoint[CP_PERCENT] doubleValue];
        double percent = [checkpoint[CP_PERCENT] doubleValue];

        double effectivePercent = btcPercent - percent;
        double realChange = [realChanges[key] doubleValue];

        // Security Feature: We want more, not less
        if (effectivePercent < 0) {
            continue;
        }

        // Trade only with a higher Price/Volume Ratio
        if (wantedRate > realChange) {
            continue;
        }

        if (effectivePercent > wantedPercent) {
            [self autoBuyAll:key];
        }
    }
}

/**
 * Kaufe Assets mit einer Investor-Rate von "rate"% oder mehr...
 *
 * @param wantedRate
 */
- (void)buyByInvestors:(double)wantedRate {
    NSDebug(@"Calculator::buyByInvestors:%.4f %%", wantedRate);

    NSDictionary *currencyUnits = [self realChanges];

    NSNumber *highest = [[currencyUnits allValues] valueForKeyPath:@"@max.self"];

    if (highest != nil) {
        NSString *highestKey = [currencyUnits allKeysForObject:highest][0];
        double investorsRate = [currencyUnits[highestKey] doubleValue];

        // Kaufe auf Grundlage der aktuellen Investoren-Rate
        if (investorsRate > wantedRate) {
            [self autoBuyAll:highestKey];
        }
    }
}

/**
 * buyTheBest: Kaufe blind die am höchsten bewertete Asset
 *
 */
- (void)buyTheBest {
    NSDebug(@"Calculator::buyTheBest");

    NSDictionary *currencyUnits = [self checkpointChanges];

    NSNumber *highest = [[currencyUnits allValues] valueForKeyPath:@"@max.self"];

    if (highest != nil) {
        NSString *highestKey = [currencyUnits allKeysForObject:highest][0];
        [self autoBuyAll:highestKey];
    }
}

/**
 * buyTheWorst: Kaufe blind die am niedrigsten bewertete Asset
 *
 */
- (void)buyTheWorst {
    NSDebug(@"Calculator::buyTheWorst");

    NSMutableDictionary *currencyUnits = [[self checkpointChanges] mutableCopy];

    NSNumber *lowest = [[currencyUnits allValues] valueForKeyPath:@"@min.self"];

    if (lowest != nil) {
        NSString *lowestKey = [currencyUnits allKeysForObject:lowest][0];
        [self autoBuyAll:lowestKey];
    }
}

/**
 * buyLow: Kaufe zum täglichen Tiefstpreis
 */
- (void)buyLow {
    NSDebug(@"Calculator::buyLow");

    double btcAmount = [currentSaldo[ASSET_KEY(1)] doubleValue];

    // Currently we have no BTC
    if (btcAmount < 0.0001) { return; }

    for (id key in tickerKeys) {
        if ([key isEqualToString:ASSET_KEY(1)]) continue;

        double low = [ticker[tickerKeys[key]][POLONIEX_LOW24] doubleValue] * 1.01;
        double price = [self ethPriceForAsset:key];

        if (price <= low) {
            [self autoBuyAll:key];
        }
    }
}

/**
 * Aktualsiert den Bestand (synchronisiert und thread-safe)
 *
 * falls automatedTrading an ist, wird nur der handelbare Bestand angezeigt.
 * falls automatedTrading aus ist, wird der handelbare(available) und der investierte(onOrders) Bestand angezeigt.
 *
 * @param synchronized
 */
- (void)updateBalances:(BOOL)synchronized {
    NSDebug(@"Calculator::updateBalances:%d", synchronized);

    dispatch_queue_t queue = dispatch_queue_create("de.4customers.PennyStocks.updateBalances", NULL);

    if (synchronized) {
        dispatch_sync(queue, ^{
            [self unsynchronizedUpdateBalances];
        });
    } else {
        dispatch_async(queue, ^{
            [self unsynchronizedUpdateBalances];
        });
    }

}

/**
 * Aktualsiert den Bestand mit dem API-KEY
 *
 * falls automatedTrading an ist, wird nur der handelbare Bestand angezeigt.
 * falls automatedTrading aus ist, wird der handelbare(available) und der investierte(onOrders) Bestand angezeigt.
 */
- (void)unsynchronizedUpdateBalances {
    NSDebug(@"Calculator::unsynchronizedUpdateBalances");

    NSDictionary *apiKey = [self apiKey];
    NSDictionary *ak = apiKey[@"apiKey"];
    NSString *sk = apiKey[@"secret"];

    if (ak == nil || sk == nil) {
        return;
    }

    NSDictionary *currentBalance = [Brokerage balance:ak withSecret:sk forExchange:defaultExchange];

    if (currentBalance[POLONIEX_ERROR]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Helper notificationText:currentBalance[POLONIEX_ERROR] info:@"CHECK API-KEY RESTRICTIONS"];
        });

        return;
    }

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for (id key in currentSaldo) {
        double sum = [[currentBalance[key] objectForKey:POLONIEX_AVAILABLE] doubleValue];
        //if (!self.automatedTrading) { sum += [[currentBalance[key] objectForKey:POLONIEX_ONORDERS] doubleValue]; }

        dictionary[key] = @(sum);
    }

    [self currentSaldoForDictionary:dictionary];
}

/**
 * synchronisierter Block, der garantiert, dass es nur ein Update gibt
 *
 * @param synchronized
 */
- (void)updateRatings:(BOOL)synchronized {
    NSDebug(@"Calculator::updateRatings");

    dispatch_queue_t queue = dispatch_queue_create("de.4customers.PennyStocks.updateRatings", NULL);

    if (synchronized) {
        dispatch_sync(queue, ^{
            [self unsynchronizedUpdateRatings];
        });
    } else {
        dispatch_async(queue, ^{
            [self unsynchronizedUpdateRatings];
        });
    }

}

/**
 * Besorge die Kurse von der Börse per JSON-Request und speichere Sie in den App-Einstellungen
 */
- (void)unsynchronizedUpdateRatings {
    NSDebug(@"Calculator::unsynchronizedUpdateRatings");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tickerDictionary;

    if ([defaultExchange isEqualToString:EXCHANGE_POLONIEX]) { tickerDictionary = [Brokerage poloniexTicker:fiatCurrencies]; }
    if ([defaultExchange isEqualToString:EXCHANGE_BITTREX]) { tickerDictionary = [Brokerage bittrexTicker:fiatCurrencies forAssets:[currentSaldo allKeys]]; }

    if (tickerDictionary == nil) {

        // Kein Netzwerk, liefere gespeicherte Werte...
        initialRatings = [defaults objectForKey:KEY_INITIAL_RATINGS];

        if (initialRatings == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDebug(@"SERVICE UNAVAILABLE DURING INITIAL START");

                [Helper notificationText:NSLocalizedString(@"no_internet_connection", @"NO INTERNET CONNECTION")
                    info:NSLocalizedString(@"internet_connection_required", @"Internet Connection required")
                ];
            });

            return;
        }

        // falls es noch keine aktuellen Ratings gibt, liefere Initiale...
        if (currentRatings == nil) {
            currentRatings = initialRatings;
        }

        return;
    }

    ticker = [tickerDictionary mutableCopy];

    NSString *btcFiat = [NSString stringWithFormat:@"%@_%@", ASSET_KEY(1), fiatCurrencies[0]];
    double btcValue = 1.0 / [tickerDictionary[btcFiat][POLONIEX_LAST] doubleValue];

    currentRatings = [[NSMutableDictionary alloc] init];

    currentRatings[ASSET_KEY(1)] = @(btcValue);
    currentRatings[fiatCurrencies[1]] = tickerDictionary[fiatCurrencies[1]];

    for (id key in tickerKeys) {
        double assetValue = btcValue;

        if (![key isEqualToString:ASSET_KEY(1)]) {
            assetValue /= [tickerDictionary[tickerKeys[key]][POLONIEX_LAST] doubleValue];
        }

        currentRatings[key] = @(assetValue);
    }

    initialRatings = [[defaults objectForKey:KEY_INITIAL_RATINGS] mutableCopy];

    if (initialRatings == nil) {
        [self initialRatingsWithDictionary:currentRatings];
    }

    [defaults synchronize];
}

/**
 * Liefert den aktuellen Saldo der jeweiligen Crypto-Währung
 *
 * @param asset
 * @return double
 */
- (double)currentSaldo:(NSString *)asset {
    NSDebug(@"Calculator::currentSaldo:%@", asset);

    return [currentSaldo[asset] doubleValue];
}

/**
 * Liefert die aktuelle URL für das angegebene Label/Tab
 *
 * @param label
 * @return NSString*
 */
- (NSString *)saldoUrlForLabel:(NSString *)label {
    NSDebug(@"Calculator::saldoUrlForLabel:%@", label);

    return saldoUrls[label];
}

/**
 * Aktualisiert den aktuellen Saldo für die CryptoWährung "asset" mit dem Wert "saldo"
 *
 * @param asset
 * @param saldo
 */
- (void)currentSaldo:(NSString *)asset withDouble:(double)saldo {
    NSDebug(@"Calculator::currentSaldo:%@ withDouble:%8f", asset, saldo);

    currentSaldo[asset] = [[NSNumber alloc] initWithDouble:saldo];

    [self currentSaldoForDictionary:currentSaldo];
}

/**
 * Ersetzt die aktuellen Saldi mit den Werten aus dem Dictionary
 *
 * @param dictionary
 */
- (void)currentSaldoForDictionary:(NSMutableDictionary *)dictionary {
    NSDebug(@"Calculator::currentSaldoForDictionary:%@", dictionary);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (dictionary == nil) { return; }
    if ([dictionary count] == 0) {
        NSDebug(@"EMPTY ARRAY - NOT INSERTING");

        return;
    }

    [defaults setObject:dictionary forKey:KEY_CURRENT_SALDO];
    [defaults synchronize];

    currentSaldo = [dictionary mutableCopy];
}

/**
 * Ersetzt die aktuellen saldoUrls mit den Werten aus dem Dictionary
 *
 * @param dictionary
 */
- (void)saldoUrlsForDictionary:(NSMutableDictionary *)dictionary {
    NSDebug(@"Calculator::saldoUrlsForDictionary:%@", dictionary);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (dictionary == nil) { return; }
    if ([dictionary count] == 0) {
        NSDebug(@"EMPTY ARRAY - NOT INSERTING");

        return;
    }

    [defaults setObject:dictionary forKey:KEY_SALDO_URLS];
    [defaults synchronize];

    saldoUrls = [dictionary mutableCopy];
}

/**
 * Ersetzt die aktuellen initialRatings mit den Werten aus dem Dictionary
 *
 * @param dictionary
 */
- (void)initialRatingsWithDictionary:(NSMutableDictionary *)dictionary {
    NSDebug(@"Calculator::initialRatingsWithDictionary:%@", dictionary);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (dictionary == nil) { return; }
    if ([dictionary count] == 0) {
        NSDebug(@"EMPTY ARRAY - NOT INSERTING");

        return;
    }

    [defaults setObject:dictionary forKey:KEY_INITIAL_RATINGS];
    [defaults synchronize];

    initialRatings = [dictionary mutableCopy];
}

/**
 * Aktualisieren der Standardbörse ermöglichen
 *
 * @param exchange
 */
- (void)defaultExchange:(NSString *)exchange {
    NSDebug(@"Calculator::defaultExchange:%@", exchange);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Instanzvariable zurück setzen
    keyAndSecret = nil;

    saldoUrls = [[NSMutableDictionary alloc] init];
    [Calculator migrateSaldoAndRatings];

    [defaults setObject:exchange forKey:KEY_DEFAULT_EXCHANGE];
    [defaults synchronize];

    defaultExchange = exchange;

    [defaults setObject:[[NSMutableDictionary alloc] init] forKey:KEY_SALDO_URLS];
    [defaults synchronize];

    [Calculator migrateSaldoAndRatings];
    saldoUrls = [[defaults objectForKey:KEY_SALDO_URLS] mutableCopy];
}

/**
 * Getter für die DefaultExchange
 *
 * @return NSString*
 */
- (NSString *)defaultExchange {
    NSDebug(@"Calculator::defaultExchange");

    return defaultExchange;
}

/**
 * Liefert die aktuellen Fiat-Währungen
 *
 * @return NSArray*
 */
- (NSArray *)fiatCurrencies {
    NSDebug(@"Calculator::fiatCurrencies");

    return fiatCurrencies;
}

/**
 * Getter für currentSaldo
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)currentSaldo {
    NSDebug(@"Calculator::currentSaldo");

    return [currentSaldo mutableCopy];
}

/**
 * Getter für das saldoUrls
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)saldoUrls {
    NSDebug(@"Calculator::saldoUrls");

    return [saldoUrls mutableCopy];
}

/**
 * Getter für initialRatings
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)initialRatings {
    NSDebug(@"Calculator::initialRatings");

    return [initialRatings mutableCopy];
}

/**
 * Getter für currentRatings
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)currentRatings {
    NSDebug(@"Calculator::currentRatings");

    return [currentRatings mutableCopy];
}

/**
 * Getter für den Ticker
 *
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary *)ticker {
    NSDebug(@"Calculator::ticker");

    return [ticker mutableCopy];
}

/**
 * Getter für die tickerKeys
 *
 * @return NSDictionary*
 */
- (NSDictionary *)tickerKeys {
    NSDebug(@"Calculator::tickerKeys");

    return tickerKeys;
}

/**
 * Getter für die tickerKeysDescription
 *
 * @return NSDictionary*
 */
- (NSDictionary *)tickerKeysDescription {
    NSDebug(@"Calculator::tickerKeysDescription");

    return tickerKeysDescription;
}

/**
 * Minimieren des Zugriffs auf den Schlüsselbund
 */
- (NSDictionary *)apiKey {
    NSDebug(@"Calculator::apiKey");

    if (keyAndSecret == nil) {
        if ([defaultExchange isEqualToString:EXCHANGE_POLONIEX]) {
            keyAndSecret = [KeychainWrapper keychain2ApiKeyAndSecret:@"POLONIEX"];
        }

        if ([defaultExchange isEqualToString:EXCHANGE_BITTREX]) {
            keyAndSecret = [KeychainWrapper keychain2ApiKeyAndSecret:@"BITTREX"];
        }
    }

    return keyAndSecret;
}
@end
