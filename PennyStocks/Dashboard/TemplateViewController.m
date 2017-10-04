//
//  TemplateViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//
#import "TemplateViewController.h"
#import "Helper.h"
#import "Calculator.h"

const double CHECKPOINT_PERCENTAGE = 5.0;

typedef struct COINCHANGE {
    double effectivePercent;
    double diffsInPercent;
    double diffsInEuro;
} COINCHANGE;

typedef struct DASHBOARD_VARS {
    COINCHANGE coinchange;

    double initialBalancesInEUR;
    double totalBalancesInEUR;
    double balancesInEUR;
    double balancesInBTC;
    double shares;
} DASHBOARD_VARS;

@implementation TemplateViewController {
@private
    Calculator *calculator;

    NSMutableDictionary *applications;
    NSMutableDictionary *traders;

    // Die Tabs
    NSDictionary *tabs;
    NSDictionary *labels;

    // Bilder und URLs
    NSDictionary *images;
    NSString *homeURL;

    // EURO UND USD derzeit
    NSArray *fiatCurrencies;
    NSString *fiatCurrencySymbol;

    // meine nettes Rot
    NSColor *defaultDangerColor;

    NSColor *defaultGainColor;
    NSColor *defaultLooseColor;

    // Low / High
    NSColor *defaultLowerColor;
    NSColor *defaultHigherColor;

    // Low / High
    NSColor *defaultLowestColor;
    NSColor *defaultHighestColor;

    double coinchangePercentage;
}

/**
 * Aktualisierung der Nutzdaten(Kurse und Kontostände)
 */
- (void)updateBalanceAndRatings {
    [calculator updateRatings:true];
    [calculator updateBalances:true];
}

/**
 * Aktualisiert das aktive Tab
 *
 * @param withTrading
 */
- (void)updateCurrentView:(BOOL)withTrading {
    if (withTrading) {
        if (calculator.automatedTrading) {

            // Aktualisiere coinchangePercentage, da es jetzt einstellbar ist
            coinchangePercentage = [[[NSUserDefaults standardUserDefaults] objectForKey:COINCHANGE_PERCENTAGE] doubleValue];

            // Gewinn: Automatisches Verkaufen von Assets mit einer Exchange-Rate von coinchangePercentage oder mehr
            [calculator sellWithProfitInPercent:coinchangePercentage];

            // Gewinn: Automatisches Kaufen von Assets mit einer Exchange-Rate von coinchangePercentage oder mehr
            [calculator buyWithProfitInPercent:coinchangePercentage andInvestmentRate:-3.5];

        }
    }

    // View aktualisieren
    NSString *label = self.headlineLabel.stringValue;
    [self updateTemplateView:labels[label]];
}

/**
 * Einfärben der Textfelder vereinheitlichen
 *
 * @param field
 * @param color
 */
- (void)alterFieldColors:(NSTextField *)field withBackgroundColor:(NSColor *)color {
    field.backgroundColor = color;
}

/**
 * Zurücksetzen der Farben
 */
- (void)resetColors {
    NSColor *chartBGColor = [NSColor whiteColor];
    NSColor *infoBarFGColor = [NSColor colorWithCalibratedRed:178.0f / 255.0f green:178.0f / 255.0f blue:178.0f / 255.0f alpha:1.0f];

    // Poloniex Leiste
    [self alterFieldColors:self.lastField withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.highField withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.changeField withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.high24Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.low24Field withBackgroundColor:chartBGColor];

    // Chart Leiste 1
    [self alterFieldColors:self.currency1Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.currency2Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.currency3Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.currency4Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.currency5Field withBackgroundColor:chartBGColor];

    // Chart Leiste 2
    [self alterFieldColors:self.currency6Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.currency7Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.currency8Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.currency9Field withBackgroundColor:chartBGColor];
    [self alterFieldColors:self.currency10Field withBackgroundColor:chartBGColor];

    self.percentLabel.textColor = [NSColor whiteColor];

    self.iBrokerLabel.textColor = infoBarFGColor;
    self.statusLabel.textColor = infoBarFGColor;
    self.infoLabel.textColor = infoBarFGColor;
}

/**
 * Initialisiere alle Datenstrukturen
 */
- (void)initializeWithDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Liste der Fiat-Währungen
    fiatCurrencies = [defaults objectForKey:@"fiatCurrencies"];

    if (fiatCurrencies == nil) {
        fiatCurrencies = @[EUR, USD];

        [defaults setObject:fiatCurrencies forKey:@"fiatCurrencies"];
    }

    calculator = [Calculator instance:fiatCurrencies];

    if ([fiatCurrencies[0] isEqualToString:EUR]) {
        fiatCurrencySymbol = @"€";
    }

    if ([fiatCurrencies[0] isEqualToString:USD]) {
        fiatCurrencySymbol = @"$";
    }

    tabs = @{
        DASHBOARD: @[DASHBOARD, @1],
        ASSET_KEY(1): @[ASSET_DESC(1), @1],
        ASSET_KEY(2): @[ASSET_DESC(2), @1],
        ASSET_KEY(3): @[ASSET_DESC(3), @1],
        ASSET_KEY(4): @[ASSET_DESC(4), @1],
        ASSET_KEY(5): @[ASSET_DESC(5), @1],
        ASSET_KEY(6): @[ASSET_DESC(6), @1],
        ASSET_KEY(7): @[ASSET_DESC(7), @1],
        ASSET_KEY(8): @[ASSET_DESC(8), @1],
        ASSET_KEY(9): @[ASSET_DESC(9), @1],
        ASSET_KEY(10): @[ASSET_DESC(10), @1],
    };

    labels = @{
        DASHBOARD: DASHBOARD,
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

    images = @{
        EUR: [NSImage imageNamed:EUR],
        USD: [NSImage imageNamed:USD],
        GBP: [NSImage imageNamed:GBP],
        CNY: [NSImage imageNamed:CNY],
        JPY: [NSImage imageNamed:JPY],
        ASSET_KEY(1): [NSImage imageNamed:ASSET_KEY(1)],
        ASSET_KEY(2): [NSImage imageNamed:ASSET_KEY(2)],
        ASSET_KEY(3): [NSImage imageNamed:ASSET_KEY(3)],
        ASSET_KEY(4): [NSImage imageNamed:ASSET_KEY(4)],
        ASSET_KEY(5): [NSImage imageNamed:ASSET_KEY(5)],
        ASSET_KEY(6): [NSImage imageNamed:ASSET_KEY(6)],
        ASSET_KEY(7): [NSImage imageNamed:ASSET_KEY(7)],
        ASSET_KEY(8): [NSImage imageNamed:ASSET_KEY(8)],
        ASSET_KEY(9): [NSImage imageNamed:ASSET_KEY(9)],
        ASSET_KEY(10): [NSImage imageNamed:ASSET_KEY(10)],
    };

    applications = [[defaults objectForKey:TV_APPLICATIONS] mutableCopy];

    if (applications == nil) {
        applications = [@{
            ASSET_DESC(1): @"/Applications/Ethereum Wallet.app",
            ASSET_DESC(2): @"",
            ASSET_DESC(3): @"/Applications/monero-wallet-gui.App",
            ASSET_DESC(4): @"/Applications/Electrum-LTC.App",
            ASSET_DESC(5): @"",
            ASSET_DESC(6): @"",
            ASSET_DESC(7): @"",
            ASSET_DESC(8): @"",
            ASSET_DESC(9): @"",
            ASSET_DESC(10): @"",
        } mutableCopy];

        [defaults setObject:applications forKey:TV_APPLICATIONS];
    }

    traders = [defaults objectForKey:TV_TRADERS];

    if (traders == nil) {
        traders = [@{
            TV_HOMEPAGE: @"https://www.4customers.de/pennystocks/",
            TV_TRADER1: @"https://www.shapeshift.io",
            TV_TRADER2: @"https://www.blocktrades.us",
        } mutableCopy];

        [defaults setObject:traders forKey:TV_TRADERS];
    }

    // Ich brauche den Placeholder Text eigentlich nur in Xcode zum Finden des Labels
    self.statusLabel.placeholderString = @"+/- 0";
    self.infoLabel.placeholderString = @"Penny Stocks";

    // mein patentgeschützer Rotton
    defaultDangerColor = [NSColor colorWithCalibratedRed:200.0f / 255.0f green:79.0f / 255.0f blue:35.0f / 255.0f alpha:1.0f];

    defaultHigherColor = [NSColor greenColor];
    defaultHighestColor = [NSColor magentaColor];
    defaultGainColor = [NSColor blueColor];

    defaultLowerColor = [NSColor yellowColor];
    defaultLowestColor = [NSColor orangeColor];
    defaultLooseColor = [NSColor redColor];

    // deaktiviere das Instant Trading
    self.instantTrading.enabled = false;

    NSNumber *ccp = [defaults objectForKey:COINCHANGE_PERCENTAGE];

    if (ccp == nil) {
        ccp = [NSNumber numberWithDouble:3.0];
        [defaults setObject:ccp forKey:COINCHANGE_PERCENTAGE];
    }

    coinchangePercentage = [ccp doubleValue];

    // Synchronisiere alle Werte zum Schluss
    [defaults synchronize];
}

/**
 * simpler Upgrade Assistent
 */
- (void)updateAssistant {
    [Calculator migrateSaldoAndRatings];
    applications = [Calculator migrateApplications];
}

/**
 * Setzen der Formatierungsregeln für die Eingabefelder
 *
 * @param fractions
 * @param assetFractions
 */
- (void)stdNumberFormatter:(NSUInteger)fractions forAsset:(NSUInteger)assetFractions {
    // Währungsformat mit 2 Nachkommastellen
    NSNumberFormatter *currencyFormatter = [self.currencyUnits formatter];
    [currencyFormatter setMinimumFractionDigits:fractions];
    [currencyFormatter setMaximumFractionDigits:fractions];

    // Crypto-Währungsformat mit 4-8 Nachkommastellen
    NSNumberFormatter *cryptoFormatter = [self.cryptoUnits formatter];
    [cryptoFormatter setMinimumFractionDigits:assetFractions];
    [cryptoFormatter setMaximumFractionDigits:assetFractions];

    // Rate-Währungsformat mit 4-8 Nachkommastellen
    NSNumberFormatter *rateFormatter = [self.rateInputLabel formatter];
    [rateFormatter setMinimumFractionDigits:0];
    [rateFormatter setMaximumFractionDigits:assetFractions];
}

/**
 * Setzen des Action Buttons per Code, da es keinen Sinn macht, dass pro Tab in XCode einzurichten...
 */
- (void)viewWillAppear {
    [_cryptoUnits setTarget:self];
    [_cryptoUnits setAction:@selector(cryptoAction:)];
}

/**
 * Informiere den Nutzer über die aktuell genutzte Börse
 */
- (void)pennyStocksOnExchange {
    NSWindow *parentWindow = [[NSApplication sharedApplication] windows][0];
    NSString *onExchangeText = [calculator.defaultExchange isEqualToString:EXCHANGE_BITTREX] ? @"Bittrex" : @"Poloniex";
    parentWindow.title = [NSString stringWithFormat:@"PennyStocks on %@", onExchangeText];
}

/**
 * Initialisierung der Sicht / des View
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialisieren der Bezeichner
    self.currency1Label.stringValue = ASSET_KEY(1);
    self.currency2Label.stringValue = ASSET_KEY(2);
    self.currency3Label.stringValue = ASSET_KEY(3);
    self.currency4Label.stringValue = ASSET_KEY(4);
    self.currency5Label.stringValue = ASSET_KEY(5);
    self.currency6Label.stringValue = ASSET_KEY(6);
    self.currency7Label.stringValue = ASSET_KEY(7);
    self.currency8Label.stringValue = ASSET_KEY(8);
    self.currency9Label.stringValue = ASSET_KEY(9);
    self.currency10Label.stringValue = ASSET_KEY(10);

    // Exchange Rate Currencies
    self.asset1MenuItem.title = ASSET_KEY(1);
    self.asset2MenuItem.title = ASSET_KEY(2);
    self.asset3MenuItem.title = ASSET_KEY(3);
    self.asset4MenuItem.title = ASSET_KEY(4);
    self.asset5MenuItem.title = ASSET_KEY(5);
    self.asset6MenuItem.title = ASSET_KEY(6);
    self.asset7MenuItem.title = ASSET_KEY(7);
    self.asset8MenuItem.title = ASSET_KEY(8);
    self.asset9MenuItem.title = ASSET_KEY(9);
    self.asset10MenuItem.title = ASSET_KEY(10);

    // Initialisieren der Anwendung und der Datenstrukturen
    [self initializeWithDefaults];

    // Exchange Rate FiatCurrencies
    self.fiatAsset1MenuItem.title = fiatCurrencies[0];
    self.fiatAsset2MenuItem.title = fiatCurrencies[1];

    // Setze das Label des Eingabefeldes für den Taschenrechner auf Fiat-Währung 2 = USD
    self.rateInputCurrencyLabel.stringValue = fiatCurrencies[1];

    // Setze das selektierte Element des Taschenrechners auf Fiat Währung 1 = EUR
    [self.exchangeSelection selectItemWithTitle:fiatCurrencies[0]];
}

/**
 * Markieren der Gewinner der obersten Leiste
 */
- (void)markGainers {
    // Hole die aktualisierten Dictionaries
    NSDictionary *btcCheckpoint = [calculator checkpointForAsset:ASSET_KEY(1)];
    NSMutableDictionary *currentRatings = [calculator currentRatings];

    double btcPercent = [btcCheckpoint[ASSET_KEY(1)] doubleValue];

    NSMutableDictionary *currencyUnits = [[NSMutableDictionary alloc] init];
    for (id cAsset in currentRatings) {
        NSDictionary *aCheckpoint = [calculator checkpointForAsset:cAsset];

        double cPercent = [aCheckpoint[CP_PERCENT] doubleValue];

        /* Higher Checkpoint Block */

        // Chart Leiste 1
        if ([cAsset isEqualToString:ASSET_KEY(1)] && cPercent > 0) { [self alterFieldColors:self.currency1Field withBackgroundColor:defaultHigherColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(2)] && cPercent > 0) { [self alterFieldColors:self.currency2Field withBackgroundColor:defaultHigherColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(3)] && cPercent > 0) { [self alterFieldColors:self.currency3Field withBackgroundColor:defaultHigherColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(4)] && cPercent > 0) { [self alterFieldColors:self.currency4Field withBackgroundColor:defaultHigherColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(5)] && cPercent > 0) { [self alterFieldColors:self.currency5Field withBackgroundColor:defaultHigherColor]; }

        // Chart Leiste 2
        if ([cAsset isEqualToString:ASSET_KEY(6)] && cPercent > 0) { [self alterFieldColors:self.currency6Field withBackgroundColor:defaultHigherColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(7)] && cPercent > 0) { [self alterFieldColors:self.currency7Field withBackgroundColor:defaultHigherColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(8)] && cPercent > 0) { [self alterFieldColors:self.currency8Field withBackgroundColor:defaultHigherColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(9)] && cPercent > 0) { [self alterFieldColors:self.currency9Field withBackgroundColor:defaultHigherColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(10)] && cPercent > 0) { [self alterFieldColors:self.currency10Field withBackgroundColor:defaultHigherColor]; }

        /* Highest Checkpoint Block */

        // Chart Leiste 1
        if ([cAsset isEqualToString:ASSET_KEY(1)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency1Field withBackgroundColor:defaultHighestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(2)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency2Field withBackgroundColor:defaultHighestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(3)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency3Field withBackgroundColor:defaultHighestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(4)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency4Field withBackgroundColor:defaultHighestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(5)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency5Field withBackgroundColor:defaultHighestColor]; }

        // Chart Leiste 2
        if ([cAsset isEqualToString:ASSET_KEY(6)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency6Field withBackgroundColor:defaultHighestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(7)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency7Field withBackgroundColor:defaultHighestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(8)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency8Field withBackgroundColor:defaultHighestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(9)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency9Field withBackgroundColor:defaultHighestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(10)] && cPercent > CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency10Field withBackgroundColor:defaultHighestColor]; }

        // Bilde die Differenz aus BTC und der jeweiligen Cryptowährung, falls es sich nicht um BTC handelt.
        if (![cAsset isEqualToString:ASSET_KEY(1)]) {
            cPercent -= btcPercent;
        }

        currencyUnits[cAsset] = @(cPercent);
    }

    NSNumber *highest = [[currencyUnits allValues] valueForKeyPath:@"@max.self"];

    if (highest != nil) {
        NSString *highestKey = [currencyUnits allKeysForObject:highest][0];

        /* Gainers Checkpoint Block */

        // Chart Leiste 1
        if ([highestKey isEqualToString:ASSET_KEY(1)]) { [self alterFieldColors:self.currency1Field withBackgroundColor:defaultGainColor]; }
        if ([highestKey isEqualToString:ASSET_KEY(2)]) { [self alterFieldColors:self.currency2Field withBackgroundColor:defaultGainColor]; }
        if ([highestKey isEqualToString:ASSET_KEY(3)]) { [self alterFieldColors:self.currency3Field withBackgroundColor:defaultGainColor]; }
        if ([highestKey isEqualToString:ASSET_KEY(4)]) { [self alterFieldColors:self.currency4Field withBackgroundColor:defaultGainColor]; }
        if ([highestKey isEqualToString:ASSET_KEY(5)]) { [self alterFieldColors:self.currency5Field withBackgroundColor:defaultGainColor]; }

        // Chart Leiste 2
        if ([highestKey isEqualToString:ASSET_KEY(6)]) { [self alterFieldColors:self.currency6Field withBackgroundColor:defaultGainColor]; }
        if ([highestKey isEqualToString:ASSET_KEY(7)]) { [self alterFieldColors:self.currency7Field withBackgroundColor:defaultGainColor]; }
        if ([highestKey isEqualToString:ASSET_KEY(8)]) { [self alterFieldColors:self.currency8Field withBackgroundColor:defaultGainColor]; }
        if ([highestKey isEqualToString:ASSET_KEY(9)]) { [self alterFieldColors:self.currency9Field withBackgroundColor:defaultGainColor]; }
        if ([highestKey isEqualToString:ASSET_KEY(10)]) { [self alterFieldColors:self.currency10Field withBackgroundColor:defaultGainColor]; }
    }
}

/**
 * Markieren der Verlierer der obersten Leiste
 */
- (void)markLoosers {
    NSMutableDictionary *currentRatings = [calculator currentRatings];

    NSDictionary *btcCheckpoint = [calculator checkpointForAsset:ASSET_KEY(1)];
    double btcPercent = [btcCheckpoint[ASSET_KEY(1)] doubleValue];

    NSMutableDictionary *currencyUnits = [[NSMutableDictionary alloc] init];
    for (id cAsset in currentRatings) {
        NSDictionary *aCheckpoint = [calculator checkpointForAsset:cAsset];

        double cPercent = [aCheckpoint[CP_PERCENT] doubleValue];

        /* Lower Checkpoint Block */

        // Chart Leiste 1
        if ([cAsset isEqualToString:ASSET_KEY(1)] && cPercent < 0) { [self alterFieldColors:self.currency1Field withBackgroundColor:defaultLowerColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(2)] && cPercent < 0) { [self alterFieldColors:self.currency2Field withBackgroundColor:defaultLowerColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(3)] && cPercent < 0) { [self alterFieldColors:self.currency3Field withBackgroundColor:defaultLowerColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(4)] && cPercent < 0) { [self alterFieldColors:self.currency4Field withBackgroundColor:defaultLowerColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(5)] && cPercent < 0) { [self alterFieldColors:self.currency5Field withBackgroundColor:defaultLowerColor]; }

        // Chart Leiste 2
        if ([cAsset isEqualToString:ASSET_KEY(6)] && cPercent < 0) { [self alterFieldColors:self.currency6Field withBackgroundColor:defaultLowerColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(7)] && cPercent < 0) { [self alterFieldColors:self.currency7Field withBackgroundColor:defaultLowerColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(8)] && cPercent < 0) { [self alterFieldColors:self.currency8Field withBackgroundColor:defaultLowerColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(9)] && cPercent < 0) { [self alterFieldColors:self.currency9Field withBackgroundColor:defaultLowerColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(10)] && cPercent < 0) { [self alterFieldColors:self.currency10Field withBackgroundColor:defaultLowerColor]; }

        /* Lowest Checkpoint Block */

        // Chart Leiste 1
        if ([cAsset isEqualToString:ASSET_KEY(1)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency1Field withBackgroundColor:defaultLowestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(2)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency2Field withBackgroundColor:defaultLowestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(3)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency3Field withBackgroundColor:defaultLowestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(4)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency4Field withBackgroundColor:defaultLowestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(5)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency5Field withBackgroundColor:defaultLowestColor]; }

        // Chart Leiste 2
        if ([cAsset isEqualToString:ASSET_KEY(6)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency6Field withBackgroundColor:defaultLowestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(7)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency7Field withBackgroundColor:defaultLowestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(8)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency8Field withBackgroundColor:defaultLowestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(9)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency9Field withBackgroundColor:defaultLowestColor]; }
        if ([cAsset isEqualToString:ASSET_KEY(10)] && cPercent < -CHECKPOINT_PERCENTAGE) { [self alterFieldColors:self.currency10Field withBackgroundColor:defaultLowestColor]; }

        // Bilde die Differenz aus BTC und der jeweiligen Cryptowährung, falls es sich nicht um BTC handelt.
        if (![cAsset isEqualToString:ASSET_KEY(1)]) {
            cPercent -= btcPercent;
        }

        currencyUnits[cAsset] = @(cPercent);
    }

    NSNumber *lowest = [[currencyUnits allValues] valueForKeyPath:@"@min.self"];

    if (lowest != nil) {
        NSString *lowestKey = [currencyUnits allKeysForObject:lowest][0];

        /* Loose Checkpoint Block */

        // Chart Leiste 1
        if ([lowestKey isEqualToString:ASSET_KEY(1)]) { [self alterFieldColors:self.currency1Field withBackgroundColor:defaultLooseColor]; }
        if ([lowestKey isEqualToString:ASSET_KEY(2)]) { [self alterFieldColors:self.currency2Field withBackgroundColor:defaultLooseColor]; }
        if ([lowestKey isEqualToString:ASSET_KEY(3)]) { [self alterFieldColors:self.currency3Field withBackgroundColor:defaultLooseColor]; }
        if ([lowestKey isEqualToString:ASSET_KEY(4)]) { [self alterFieldColors:self.currency4Field withBackgroundColor:defaultLooseColor]; }
        if ([lowestKey isEqualToString:ASSET_KEY(5)]) { [self alterFieldColors:self.currency5Field withBackgroundColor:defaultLooseColor]; }

        // Chart Leiste 2
        if ([lowestKey isEqualToString:ASSET_KEY(6)]) { [self alterFieldColors:self.currency6Field withBackgroundColor:defaultLooseColor]; }
        if ([lowestKey isEqualToString:ASSET_KEY(7)]) { [self alterFieldColors:self.currency7Field withBackgroundColor:defaultLooseColor]; }
        if ([lowestKey isEqualToString:ASSET_KEY(8)]) { [self alterFieldColors:self.currency8Field withBackgroundColor:defaultLooseColor]; }
        if ([lowestKey isEqualToString:ASSET_KEY(9)]) { [self alterFieldColors:self.currency9Field withBackgroundColor:defaultLooseColor]; }
        if ([lowestKey isEqualToString:ASSET_KEY(10)]) { [self alterFieldColors:self.currency10Field withBackgroundColor:defaultLooseColor]; }
    }
}

/**
 * Einfärben der Labels
 */
- (void)markDockLabels:(COINCHANGE)loop_vars {
    if (loop_vars.effectivePercent < 0.0) {
        self.percentLabel.textColor = defaultLooseColor;
    }

    if (loop_vars.diffsInPercent < 0.0) {
        self.infoLabel.textColor = defaultDangerColor;
    }

    if (loop_vars.diffsInEuro < 0.0) {
        self.statusLabel.textColor = defaultDangerColor;
    }

    if (loop_vars.diffsInEuro < 0.0 && loop_vars.diffsInPercent < 0.0) {
        self.iBrokerLabel.textColor = defaultDangerColor;
    }
}

// Simpler Fetch der Poloniex Daten
- (void)updateTicker:(NSString *)label {

    if ([label isEqualToString:DASHBOARD] || [label isEqualToString:ASSET_KEY(1)]) {
        label = ASSET_KEY(1);

        self.changeLabel.stringValue = @"24h CHANGE";
    }

    NSDictionary *keys = [calculator tickerKeys];

    NSDictionary *ticker = [calculator ticker];

    if (ticker == nil) {
        self.lastField.stringValue = TV_TICKER_PLACEHOLDER;
        self.highField.stringValue = TV_TICKER_PLACEHOLDER;
        self.changeField.stringValue = TV_TICKER_PLACEHOLDER;
        self.high24Field.stringValue = TV_TICKER_PLACEHOLDER;
        self.low24Field.stringValue = TV_TICKER_PLACEHOLDER;

        return;
    }

    NSDictionary *tickerData = ticker[keys[label]];

    double factor = [tabs[label][1] doubleValue];

    NSUInteger fractions = 8;

    if ([label isEqualToString:ASSET_KEY(1)]) {
        fractions = 2;
    }

    NSString *sign = @"";
    if ([label isEqualToString:DASHBOARD] || [label isEqualToString:ASSET_KEY(1)]) {
        sign = fiatCurrencySymbol;
    }

    NSDictionary *checkpoint = [calculator checkpointForAsset:label];
    double lastCheckpoint = [checkpoint[CP_INITIAL_PRICE] doubleValue];

    double changeInPercent = 100 * [tickerData[POLONIEX_PERCENT] doubleValue];
    self.lastField.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:factor * [tickerData[POLONIEX_LAST] doubleValue] min:fractions max:fractions], sign];
    self.highField.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:lastCheckpoint min:fractions max:4], fiatCurrencySymbol];
    self.changeField.stringValue = [Helper double2GermanPercent:changeInPercent fractions:2];
    self.high24Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:factor * [tickerData[POLONIEX_HIGH24] doubleValue] min:fractions max:fractions], sign];
    self.low24Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:factor * [tickerData[POLONIEX_LOW24] doubleValue] min:fractions max:fractions], sign];

    if (changeInPercent < 0) {
        self.changeField.backgroundColor = defaultLowerColor;
    }

    if (changeInPercent > 0) {
        self.changeField.backgroundColor = defaultHigherColor;
    }

    if (changeInPercent < -CHECKPOINT_PERCENTAGE) {
        self.changeField.backgroundColor = defaultLowestColor;
    }

    if (changeInPercent > CHECKPOINT_PERCENTAGE) {
        self.changeField.backgroundColor = defaultHighestColor;
    }
}

/**
 * Zeige Differenzen zwischen dem gehandelten und dem berechneten Preis
 *
 * @param asset
 */
- (void)highlightVolumeMismatch:(NSString *)asset {
    // Differenzen größer oder kleiner als -2 Prozent sind relevant
    double RANGE = 0.0;

    NSDictionary *realPrices = [calculator realPrices];
    double estimatedPercentChange = [realPrices[asset][RP_CHANGE] doubleValue];

    if (estimatedPercentChange > RANGE) {
        self.iBrokerLabel.stringValue = [NSString stringWithFormat:@"IR: %@", [Helper double2GermanPercent:estimatedPercentChange fractions:2]];
        self.iBrokerLabel.textColor = defaultGainColor;
    }

    if (estimatedPercentChange < -RANGE) {
        self.iBrokerLabel.stringValue = [NSString stringWithFormat:@"IR: %@", [Helper double2GermanPercent:estimatedPercentChange fractions:2]];
        self.iBrokerLabel.textColor = defaultLooseColor;
    }
}

/**
 * Übersicht mit richtigen Live-Werten
 */
- (void)updateOverview {

    // Dynamisches Setzen der Programmüberschrift
    [self pennyStocksOnExchange];

    // Aktualisiere die URL für den HOME-Button
    homeURL = [calculator saldoUrlForLabel:DASHBOARD];

    // Farben zurück setzen
    [self resetColors];

#ifdef DEBUG
    NSLog(@"%5s %20s | %20s | %14s | %14s | %14s | %12s | %20s | %12s |\n",
        [@"####" UTF8String],
        [@"BALANCE" UTF8String],
        [[NSString stringWithFormat:@"BALANCE IN %@", fiatCurrencies[0]] UTF8String],
        [[NSString stringWithFormat:@"BALANCE IN %@", ASSET_KEY(1)] UTF8String],
        [[NSString stringWithFormat:@"INITIAL IN %@", fiatCurrencies[0]] UTF8String],
        [[NSString stringWithFormat:@"CURRENT IN %@", fiatCurrencies[0]] UTF8String],
        [@"SHARE IN %" UTF8String],
        [[NSString stringWithFormat:@"DIFF IN %@", fiatCurrencies[0]] UTF8String],
        [@"DIFF IN %" UTF8String]
    );
#endif

    NSMutableDictionary *currentSaldo = [calculator currentSaldo];
    NSMutableDictionary *initialRatings = [calculator initialRatings];
    NSMutableDictionary *currentRatings = [calculator currentRatings];

    // Standardmäßig sind die Werte zwar genullt, aber schaden tuts nicht.
    DASHBOARD_VARS loop_vars = {{0, 0, 0}, 0, 0, 0, 0, 0};

    loop_vars.totalBalancesInEUR = [calculator calculate:fiatCurrencies[0]];
    loop_vars.initialBalancesInEUR = [calculator calculateWithRatings:initialRatings currency:fiatCurrencies[0]];
    if (loop_vars.initialBalancesInEUR != 0) { loop_vars.coinchange.effectivePercent = 100.0 * (1 - (loop_vars.initialBalancesInEUR / loop_vars.totalBalancesInEUR)); }

    for (id asset in [[calculator.tickerKeys allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
        NSDictionary *checkpoint = [calculator checkpointForAsset:asset];

        double currentPrice = [checkpoint[CP_CURRENT_PRICE] doubleValue];
        double percent = [checkpoint[CP_PERCENT] doubleValue];
        double btcPrice = [asset isEqualToString:ASSET_KEY(1)] ? 1 : [currentRatings[ASSET_KEY(1)] doubleValue] / [currentRatings[asset] doubleValue];

        double amount = [currentSaldo[asset] doubleValue];

        double balanceInEUR = amount * currentPrice;
        double balanceInBTC = amount * btcPrice;

        double share = 0;
        if (loop_vars.totalBalancesInEUR != 0) { share = (balanceInEUR / loop_vars.totalBalancesInEUR) * 100.0; }

        double diffInEuro = balanceInEUR * percent / 100.0;
        double diffInPercent = (amount >= 0) ? percent : 0;

#ifdef DEBUG
        double initialPrice = [checkpoint[CP_INITIAL_PRICE] doubleValue];
        NSLog(@"%5s %20s | %20s | %14s | %14s | %14s | %12s | %20s | %12s |\n",
            [asset UTF8String],
            [[Helper double2German:amount min:8 max:8] UTF8String],
            [[Helper double2German:balanceInEUR min:2 max:2] UTF8String],
            [[Helper double2German:balanceInBTC min:8 max:8] UTF8String],
            [[Helper double2German:initialPrice min:2 max:2] UTF8String],
            [[Helper double2German:currentPrice min:2 max:2] UTF8String],
            [[Helper double2GermanPercent:share fractions:2] UTF8String],
            [[Helper double2German:diffInEuro min:2 max:2] UTF8String],
            [[Helper double2GermanPercent:diffInPercent fractions:2] UTF8String]
        );
#endif

        loop_vars.shares += share;
        loop_vars.coinchange.diffsInEuro += diffInEuro;
        loop_vars.coinchange.diffsInPercent += diffInPercent;
        loop_vars.balancesInEUR += balanceInEUR;
        loop_vars.balancesInBTC += balanceInBTC;
    }

#ifdef DEBUG
    NSLog(@"%5s %20s | %20s | %14s | %14s | %14s | %12s | %20s | %12s |\n",
        [@"ALL" UTF8String],
        [@"   ---   " UTF8String],
        [[Helper double2German:loop_vars.balancesInEUR min:2 max:2] UTF8String],
        [[Helper double2German:loop_vars.balancesInBTC min:8 max:8] UTF8String],
        [[Helper double2German:loop_vars.initialBalancesInEUR min:2 max:2] UTF8String],
        [[Helper double2German:loop_vars.totalBalancesInEUR min:2 max:2] UTF8String],
        [[Helper double2GermanPercent:loop_vars.shares fractions:0] UTF8String],
        [[Helper double2German:loop_vars.coinchange.diffsInEuro min:2 max:2] UTF8String],
        [[Helper double2GermanPercent:loop_vars.coinchange.effectivePercent fractions:2] UTF8String]
    );
#endif

    self.percentLabel.stringValue = [Helper double2GermanPercent:loop_vars.coinchange.effectivePercent fractions:2];
    if (loop_vars.coinchange.diffsInEuro != 0) {
        self.statusLabel.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:loop_vars.coinchange.diffsInEuro min:2 max:2], fiatCurrencySymbol];
    }

    [self markDockLabels:loop_vars.coinchange];

    // Übersicht mit 2/4 Nachkommastellen für EUR/USD
    [self stdNumberFormatter:2 forAsset:4];

    [self.currencyButton setImage:images[fiatCurrencies[0]]];
    self.currencyUnits.doubleValue = [calculator calculate:fiatCurrencies[0]];

    [self.cryptoButton setImage:images[fiatCurrencies[1]]];
    self.cryptoUnits.doubleValue = [calculator calculate:fiatCurrencies[1]];

    self.rateInputLabel.placeholderString = @"1";
    self.rateOutputLabel.placeholderString = [Helper double2German:1.0f / [currentRatings[fiatCurrencies[1]] doubleValue] min:2 max:4];

    // Chart Leiste 1
    self.currency1Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(1)] doubleValue] min:2 max:4], fiatCurrencySymbol];
    self.currency2Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(2)] doubleValue] min:2 max:4], fiatCurrencySymbol];
    self.currency3Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(3)] doubleValue] min:2 max:4], fiatCurrencySymbol];
    self.currency4Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(4)] doubleValue] min:2 max:4], fiatCurrencySymbol];
    self.currency5Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(5)] doubleValue] min:2 max:4], fiatCurrencySymbol];

    // Chart Leiste 2
    self.currency6Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(6)] doubleValue] min:2 max:4], fiatCurrencySymbol];
    self.currency7Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(7)] doubleValue] min:2 max:4], fiatCurrencySymbol];
    self.currency8Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(8)] doubleValue] min:2 max:4], fiatCurrencySymbol];
    self.currency9Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(9)] doubleValue] min:2 max:4], fiatCurrencySymbol];
    self.currency10Field.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:1 / [currentRatings[ASSET_KEY(10)] doubleValue] min:2 max:4], fiatCurrencySymbol];

    [self markGainers];
    [self markLoosers];

    [self updateTicker:DASHBOARD];
}

/**
 * Aktualisiere den jeweiligen Tab
 *
 * @param label
 */
- (void)updateTemplateView:(NSString *)label {

    // Dynamisches Setzen der Programmüberschrift
    [self pennyStocksOnExchange];

    // Es sind mehrere Buttons, die so synchronisiert gehalten werden...
    self.automatedTradingButton.state = (calculator.automatedTrading) ? NSOnState : NSOffState;

    // Farben zurück setzen
    [self resetColors];

    // Aktualisieren der Headline
    self.headlineLabel.stringValue = tabs[label][0];

    NSString *asset = label;
    double assets = [(NSNumber *) tabs[label][1] doubleValue];

    // Standards
    homeURL = [calculator saldoUrlForLabel:tabs[label][0]];

    // Aktualisiere den Kurs des Tabs - falls einer gesetzt ist
    [self rateInputAction:self];

    if ([label isEqualToString:DASHBOARD]) {
        [self updateOverview];

        return;
    }

    // Aktiviere InstantTrading für alle Assets
    self.instantTrading.enabled = true;

    // Aktiviere die Eingabe für die Crypto-Einheiten
    self.cryptoUnits.editable = true;

    // Setze das Bild für die FiatWährung
    [self.currencyButton setImage:self.images[fiatCurrencies[0]]];

    // Setze das Bild für die Einheit
    [self.cryptoButton setImage:self.images[asset]];

    if ([self.rateInputLabel.stringValue isEqualToString:@""]) {
        // Setze den Taschenrechner auf EUR
        self.exchangeSelection.title = fiatCurrencies[0];
    }

    // Hole die aktualisierten Dictionaries
    NSDictionary *checkpoint = [calculator checkpointForAsset:asset];
    NSDictionary *btcCheckpoint = [calculator checkpointForAsset:ASSET_KEY(1)];
    NSMutableDictionary *currentRatings = [calculator currentRatings];

    double percent = [checkpoint[CP_PERCENT] doubleValue];
    double btcPercent = [btcCheckpoint[CP_PERCENT] doubleValue];

    double assetRating = [currentRatings[asset] doubleValue];
    double saldo = [calculator currentSaldo:asset];
    double priceInEuro = saldo / assetRating;
    double diffInEuro = priceInEuro * percent / 100.0;

    double diffPercent = percent;

    if (![asset isEqualToString:ASSET_KEY(1)]) {
        diffPercent -= btcPercent;
    }

    // Die obligatorische Exchange-Rate
    NSString *infoPercentString = [NSString stringWithFormat:@"ER: %@", [Helper double2GermanPercent:diffPercent fractions:2]];

    self.percentLabel.stringValue = [Helper double2GermanPercent:percent fractions:2];
    self.infoLabel.stringValue = infoPercentString;

    // Übersicht mit 2/8 Nachkommastellen für EUR/ASSET
    [self stdNumberFormatter:2 forAsset:8];

    self.currencyUnits.doubleValue = priceInEuro;
    self.cryptoUnits.doubleValue = saldo;

    if (diffInEuro != 0) {
        self.statusLabel.stringValue = [NSString stringWithFormat:@"%@ %@", [Helper double2German:diffInEuro min:2 max:2], fiatCurrencySymbol];
    } else {
        // Placeholder reaktivieren
        self.statusLabel.stringValue = @"";
    }

    double rate = assets / assetRating;
    self.rateInputLabel.placeholderString = [Helper double2German:assets min:0 max:0];
    self.rateInputCurrencyLabel.stringValue = asset;
    self.rateOutputLabel.placeholderString = [Helper double2German:rate min:2 max:4];

    if (percent < 0.0) {
        self.percentLabel.textColor = defaultLooseColor;
    }

    COINCHANGE coinchange = {0, diffPercent, diffInEuro};
    [self markDockLabels:coinchange];

    NSDictionary *currentPriceInUnits = @{
        ASSET_KEY(1): @([calculator factorForAsset:ASSET_KEY(1) inRelationTo:asset]),
        ASSET_KEY(2): @([calculator factorForAsset:ASSET_KEY(2) inRelationTo:asset]),
        ASSET_KEY(3): @([calculator factorForAsset:ASSET_KEY(3) inRelationTo:asset]),
        ASSET_KEY(4): @([calculator factorForAsset:ASSET_KEY(4) inRelationTo:asset]),
        ASSET_KEY(5): @([calculator factorForAsset:ASSET_KEY(5) inRelationTo:asset]),
        ASSET_KEY(6): @([calculator factorForAsset:ASSET_KEY(6) inRelationTo:asset]),
        ASSET_KEY(7): @([calculator factorForAsset:ASSET_KEY(7) inRelationTo:asset]),
        ASSET_KEY(8): @([calculator factorForAsset:ASSET_KEY(8) inRelationTo:asset]),
        ASSET_KEY(9): @([calculator factorForAsset:ASSET_KEY(9) inRelationTo:asset]),
        ASSET_KEY(10): @([calculator factorForAsset:ASSET_KEY(10) inRelationTo:asset]),
    };

    NSUInteger fractions = ([label isEqualToString:ASSET_KEY(1)]) ? 4 : 8;

    self.currency1Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(1)] doubleValue] min:fractions max:fractions];
    self.currency2Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(2)] doubleValue] min:fractions max:fractions];
    self.currency3Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(3)] doubleValue] min:fractions max:fractions];
    self.currency4Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(4)] doubleValue] min:fractions max:fractions];
    self.currency5Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(5)] doubleValue] min:fractions max:fractions];

    fractions = ([label isEqualToString:ASSET_KEY(1)]) ? 4 : 6;

    self.currency6Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(6)] doubleValue] min:fractions max:fractions];
    self.currency7Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(7)] doubleValue] min:fractions max:fractions];
    self.currency8Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(8)] doubleValue] min:fractions max:fractions];
    self.currency9Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(9)] doubleValue] min:fractions max:fractions];
    self.currency10Field.stringValue = [Helper double2German:[currentPriceInUnits[ASSET_KEY(10)] doubleValue] min:fractions max:fractions];

    // Chart Leiste 1
    if ([asset isEqualToString:ASSET_KEY(1)]) { self.currency1Field.stringValue = @"1"; }
    if ([asset isEqualToString:ASSET_KEY(2)]) { self.currency2Field.stringValue = @"1"; }
    if ([asset isEqualToString:ASSET_KEY(3)]) { self.currency3Field.stringValue = @"1"; }
    if ([asset isEqualToString:ASSET_KEY(4)]) { self.currency4Field.stringValue = @"1"; }
    if ([asset isEqualToString:ASSET_KEY(5)]) { self.currency5Field.stringValue = @"1"; }

    // Chart Leiste 2
    if ([asset isEqualToString:ASSET_KEY(6)]) { self.currency6Field.stringValue = @"1"; }
    if ([asset isEqualToString:ASSET_KEY(7)]) { self.currency7Field.stringValue = @"1"; }
    if ([asset isEqualToString:ASSET_KEY(8)]) { self.currency8Field.stringValue = @"1"; }
    if ([asset isEqualToString:ASSET_KEY(9)]) { self.currency9Field.stringValue = @"1"; }
    if ([asset isEqualToString:ASSET_KEY(10)]) { self.currency10Field.stringValue = @"1"; }

    [self markGainers];
    [self markLoosers];

    [self updateTicker:label];

    // Der streng geheime BR-Faktor
    [self highlightVolumeMismatch:asset];
}

/**
 * Action-Handler für den homepageButton
 *
 * @param sender
 */
- (IBAction)homepageAction:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:traders[TV_HOMEPAGE]]];
}

/**
 * Action-Handler zum Starten der jeweiligen Wallet-App
 *
 * @param sender
 */
- (IBAction)walletAction:(id)sender {
    NSString *title = self.headlineLabel.stringValue;

    if ([title isEqualToString:DASHBOARD]) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.vendorURL]];
        return;
    }

    // Synchronisiere zur Sicherheit die Applications
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    applications = [[defaults objectForKey:TV_APPLICATIONS] mutableCopy];

    if ([applications[title] isEqualToString:@""]) {
        [Helper messageText:NSLocalizedString(@"std_app_not_configured", @"Standard App nicht konfiguriert") info:NSLocalizedString(@"check_preferences", @"Überprüfen Sie die Einstellungen.")];

        return;
    }

    if (![[NSWorkspace sharedWorkspace] launchApplication:applications[title]]) {
        NSAlert *msg = [[NSAlert alloc] init];
        [msg setAlertStyle:NSWarningAlertStyle];

        [msg addButtonWithTitle:NSLocalizedString(@"ok", @"OK"])];
        msg.messageText = [NSString stringWithFormat:NSLocalizedString(@"error_starting_app_with_param", @"Fehler beim Starten der %@ Wallet"), title];
        msg.informativeText = [NSString stringWithFormat:NSLocalizedString(@"install_app_with_param", @"Installieren Sie %@."), applications[title]];

        [msg runModal];
    }
}

/**
 * Action-Handler zum Aktivieren des automatisierten Handelns
 *
 * @param sender
 */
- (IBAction)automatedTradingAction:(id)sender {
    NSString *infoText = (!calculator.automatedTrading) ? NSLocalizedString(@"automated_trading_on", @"activated") : NSLocalizedString(@"automated_trading_off", @"deactivated");
    if ([Helper messageText:@"AUTOMATED TRADING" info:infoText] == NSAlertFirstButtonReturn) {
        calculator.automatedTrading = !calculator.automatedTrading;
    }

    self.automatedTradingButton.state = (calculator.automatedTrading) ? NSOnState : NSOffState;
}

/**
 * Action-Handler zum Starten der Crypto-Page des Vertrauens
 *
 * @param sender
 */
- (IBAction)homeAction:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:homeURL]];
}

/**
 * Action-Handler zum Aufruf des Crypto-Shifters
 *
 * @param sender
 */
- (IBAction)leftAction:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:traders[TV_TRADER1]]];
}

/**
 * Action-Handler zum Aufruf des Crypto-Shifters
 *
 * @param sender
 */
- (IBAction)rightAction:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:traders[TV_TRADER2]]];
}

/**
 * Action-Handler zum Aktualisieren des initialen Kurses der gewählten Währung (blaues Info-Icon)
 *
 * @param sender
 */
- (IBAction)infoAction:(id)sender {
    NSString *tabTitle = labels[self.headlineLabel.stringValue];
    NSString *withAsset = tabs[tabTitle][0];

    if ([withAsset isEqualToString:DASHBOARD]) {
        withAsset = NSLocalizedString(@"all_charts", @"alle Kurse");
    }

    NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"wanna_update_with_asset", @"Möchten Sie %@ aktualisieren?"), withAsset];
    NSString *info = NSLocalizedString(@"comparison_belongs_to_checkpoint", @"Der Vergleich (+/-) bezieht sich auf den zuletzt gespeicherten Checkpoint!");

    if ([Helper messageText:msg info:info] == NSAlertFirstButtonReturn) {
        [calculator updateCheckpointForAsset:tabTitle withBTCUpdate:FALSE];
    }

    [self updateCurrentView:false];
}

/**
 * Aktualisieren des eingegeben Bestands per Klick
 *
 * @param sender
 */
- (IBAction)cryptoAction:(id)sender {
    NSString *tabTitle = self.headlineLabel.stringValue;
    if ([tabTitle isEqualToString:DASHBOARD]) {
        return;
    }

    // Aktualisierte Ratings besorgen
    NSMutableDictionary *currentRatings = [calculator currentRatings];

    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"update_saldo_with_asset", @"%@ Bestand aktualisieren"), tabTitle];

    if ([Helper messageText:text info:NSLocalizedString(@"wanna_update_current_saldo", @"Möchten Sie Ihren aktuellen Bestand aktualisieren?")] == NSAlertFirstButtonReturn) {
        NSString *asset = labels[tabTitle];

        BOOL mustUpdateBecauseIHaveBought = (self.cryptoUnits.doubleValue > [calculator currentSaldo:asset]);

        [calculator currentSaldo:asset withDouble:self.cryptoUnits.doubleValue];
        self.currencyUnits.doubleValue = self.cryptoUnits.doubleValue / [currentRatings[asset] doubleValue];

        if (mustUpdateBecauseIHaveBought) {
            // Checkpoint aktualisieren
            [calculator updateCheckpointForAsset:asset withBTCUpdate:TRUE];
        }

        // nach dem Aktualisieren des Bestands muss die Statusleiste aktualisisiert werden...
        [self updateCurrentView:false];
    }
}

/**
 * Einfacher Währungsumrechner
 *
 * @param sender
 */
- (IBAction)rateInputAction:(id)sender {
    NSString *tabTitle = self.headlineLabel.stringValue;

    NSString *cAsset = ([tabTitle isEqualToString:DASHBOARD] ? fiatCurrencies[1] : labels[tabTitle]);
    NSString *exchangeUnit = self.exchangeSelection.selectedItem.title;

    // Aktualisierte Ratings besorgen
    NSMutableDictionary *currentRatings = [calculator currentRatings];

    double exchangeFactor = ([exchangeUnit isEqualToString:fiatCurrencies[0]]) ? 1 : [currentRatings[exchangeUnit] doubleValue];
    double amount = self.rateInputLabel.doubleValue;

    if ([self.rateInputLabel.stringValue isEqualToString:@""]) {
        amount = 1;
    }

    double result = amount / [currentRatings[cAsset] doubleValue] * exchangeFactor;

    if ([self.rateInputLabel.stringValue isEqualToString:@""]) {

        // Lösche den Text
        self.rateOutputLabel.stringValue = @"";

        // Aktualisiere den Placeholder
        self.rateOutputLabel.placeholderString = [Helper double2German:result min:4 max:8];

        // und fertig
        return;

    } else {
        self.rateOutputLabel.stringValue = [Helper double2German:result min:4 max:8];
    }

    // EUR / USD - das kann nicht direkt gehandelt werden
    if ([exchangeUnit isEqualToString:fiatCurrencies[0]] || [exchangeUnit isEqualToString:fiatCurrencies[1]]) {
        return;
    }

    // Dashboard Tab: USD kann nicht direkt gehandelt werden...
    if ([cAsset isEqualToString:fiatCurrencies[1]]) {
        return;
    }

    if ([cAsset isEqualToString:ASSET_KEY(1)]) {
        // Die Leute können mit (BTC) (exchangeUnit) kaufen
        if (self.instantTrading.state == NSOnState) {
            [calculator autoBuy:exchangeUnit amount:result];
            self.exchangeSelection.title = fiatCurrencies[0];
        }
    } else {
        // Die Leute können Ihre (cAsset)s nach (BTC) verkaufen
        if ([exchangeUnit isEqualToString:ASSET_KEY(1)]) {
            if (self.instantTrading.state == NSOnState) {
                [calculator autoSell:cAsset amount:amount];
                self.exchangeSelection.title = fiatCurrencies[0];
            }
        }
    }
}

/**
 * Getter für das applications Dictionary
 *
 * @return NSDictionary*
 */
- (NSDictionary *)applications {
    return applications;
}

/**
 * Getter für das traders Dictionary
 *
 * @return NSDictionary*
 */
- (NSDictionary *)traders {
    return traders;
}

/**
 * Getter für das images Dictionary
 *
 * @return NSDictionary*
 */
- (NSDictionary *)images {
    return images;
}

/**
 * Getter für die vendorURL
 *
 * @return NSString*
 */
- (NSString *)vendorURL {
    return @"https://www.4customers.de/pennystocks/";
}

/**
 * Getter für die homeURL
 *
 * @return NSString*
 */
- (NSString *)homeURL {
    return homeURL;
}

@end
