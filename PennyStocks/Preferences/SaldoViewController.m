//
//  SaldoViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 26.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "SaldoViewController.h"
#import "Calculator.h"

@implementation SaldoViewController {
    Calculator *calculator;
}

- (void)viewWillAppear {
    NSNumberFormatter *formatter;

    formatter = self.asset1Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset2Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset3Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset4Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset5Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset6Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset7Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset8Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset9Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter = self.asset10Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];
}

/**
 * Aktualisierung des Views vereinheitlicht
 */
- (void)updateView {
    calculator = [Calculator instance];

    // Aktualisierte Ratings besorgen
    NSMutableDictionary *currentSaldo = [calculator currentSaldo];

    self.asset1Field.doubleValue = [currentSaldo[ASSET_KEY(1)] doubleValue];
    self.asset2Field.doubleValue = [currentSaldo[ASSET_KEY(2)] doubleValue];
    self.asset3Field.doubleValue = [currentSaldo[ASSET_KEY(3)] doubleValue];
    self.asset4Field.doubleValue = [currentSaldo[ASSET_KEY(4)] doubleValue];
    self.asset5Field.doubleValue = [currentSaldo[ASSET_KEY(5)] doubleValue];
    self.asset6Field.doubleValue = [currentSaldo[ASSET_KEY(6)] doubleValue];
    self.asset7Field.doubleValue = [currentSaldo[ASSET_KEY(7)] doubleValue];
    self.asset8Field.doubleValue = [currentSaldo[ASSET_KEY(8)] doubleValue];
    self.asset9Field.doubleValue = [currentSaldo[ASSET_KEY(9)] doubleValue];
    self.asset10Field.doubleValue = [currentSaldo[ASSET_KEY(10)] doubleValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Properties List
    self.asset1Field.placeholderString = ASSET_DESC(1);
    self.asset2Field.placeholderString = ASSET_DESC(2);
    self.asset3Field.placeholderString = ASSET_DESC(3);
    self.asset4Field.placeholderString = ASSET_DESC(4);
    self.asset5Field.placeholderString = ASSET_DESC(5);

    self.asset6Field.placeholderString = ASSET_DESC(6);
    self.asset7Field.placeholderString = ASSET_DESC(7);
    self.asset8Field.placeholderString = ASSET_DESC(8);
    self.asset9Field.placeholderString = ASSET_DESC(9);
    self.asset10Field.placeholderString = ASSET_DESC(10);

    // Image List
    self.asset1ImageView.image = [NSImage imageNamed:ASSET_KEY(1)];
    self.asset2ImageView.image = [NSImage imageNamed:ASSET_KEY(2)];
    self.asset3ImageView.image = [NSImage imageNamed:ASSET_KEY(3)];
    self.asset4ImageView.image = [NSImage imageNamed:ASSET_KEY(4)];
    self.asset5ImageView.image = [NSImage imageNamed:ASSET_KEY(5)];

    self.asset6ImageView.image = [NSImage imageNamed:ASSET_KEY(6)];
    self.asset7ImageView.image = [NSImage imageNamed:ASSET_KEY(7)];
    self.asset8ImageView.image = [NSImage imageNamed:ASSET_KEY(8)];
    self.asset9ImageView.image = [NSImage imageNamed:ASSET_KEY(9)];
    self.asset10ImageView.image = [NSImage imageNamed:ASSET_KEY(10)];

    [self updateView];
}

/**
 * Speichern des aktuellen Ratings per Klick
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender {
    // Aktualisierte Ratings besorgen
    NSMutableDictionary *currentSaldo = [calculator currentSaldo];

    double numberAsset1 = self.asset1Field.doubleValue;
    double numberAsset2 = self.asset2Field.doubleValue;
    double numberAsset3 = self.asset3Field.doubleValue;
    double numberAsset4 = self.asset4Field.doubleValue;
    double numberAsset5 = self.asset5Field.doubleValue;
    double numberAsset6 = self.asset6Field.doubleValue;
    double numberAsset7 = self.asset7Field.doubleValue;
    double numberAsset8 = self.asset8Field.doubleValue;
    double numberAsset9 = self.asset9Field.doubleValue;
    double numberAsset10 = self.asset10Field.doubleValue;

    currentSaldo[ASSET_KEY(1)] = @(numberAsset1);
    currentSaldo[ASSET_KEY(2)] = @(numberAsset2);
    currentSaldo[ASSET_KEY(3)] = @(numberAsset3);
    currentSaldo[ASSET_KEY(4)] = @(numberAsset4);
    currentSaldo[ASSET_KEY(5)] = @(numberAsset5);
    currentSaldo[ASSET_KEY(6)] = @(numberAsset6);
    currentSaldo[ASSET_KEY(7)] = @(numberAsset7);
    currentSaldo[ASSET_KEY(8)] = @(numberAsset8);
    currentSaldo[ASSET_KEY(9)] = @(numberAsset9);
    currentSaldo[ASSET_KEY(10)] = @(numberAsset10);

    [calculator currentSaldoForDictionary:currentSaldo];

    // Gespeicherte Daten neu einlesen...
    [self updateView];
}

@end
