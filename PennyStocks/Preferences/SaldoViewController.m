//
//  SaldoViewController.m
//  iBroker
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
    
    formatter  = self.asset1Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset2Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset3Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset4Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset5Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset6Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset7Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset8Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset9Field.formatter;
    [formatter setMinimumFractionDigits:8];
    [formatter setMaximumFractionDigits:8];

    formatter  = self.asset10Field.formatter;
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

    self.asset1Field.doubleValue = [currentSaldo[ASSET1] doubleValue];
    self.asset2Field.doubleValue = [currentSaldo[ASSET2] doubleValue];
    self.asset3Field.doubleValue = [currentSaldo[ASSET3] doubleValue];
    self.asset4Field.doubleValue = [currentSaldo[ASSET4] doubleValue];
    self.asset5Field.doubleValue = [currentSaldo[ASSET5] doubleValue];
    self.asset6Field.doubleValue = [currentSaldo[ASSET6] doubleValue];
    self.asset7Field.doubleValue = [currentSaldo[ASSET7] doubleValue];
    self.asset8Field.doubleValue = [currentSaldo[ASSET8] doubleValue];
    self.asset9Field.doubleValue = [currentSaldo[ASSET9] doubleValue];
    self.asset10Field.doubleValue = [currentSaldo[ASSET10] doubleValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Properties List
    self.asset1Field.placeholderString = ASSET1_DESC;
    self.asset2Field.placeholderString = ASSET2_DESC;
    self.asset3Field.placeholderString = ASSET3_DESC;
    self.asset4Field.placeholderString = ASSET4_DESC;
    self.asset5Field.placeholderString = ASSET5_DESC;

    self.asset6Field.placeholderString = ASSET6_DESC;
    self.asset8Field.placeholderString = ASSET7_DESC;
    self.asset7Field.placeholderString = ASSET8_DESC;
    self.asset9Field.placeholderString = ASSET9_DESC;
    self.asset10Field.placeholderString = ASSET10_DESC;

    // Image List
    self.asset1ImageView.image = [NSImage imageNamed:ASSET1];
    self.asset2ImageView.image = [NSImage imageNamed:ASSET2];
    self.asset3ImageView.image = [NSImage imageNamed:ASSET3];
    self.asset4ImageView.image = [NSImage imageNamed:ASSET4];
    self.asset5ImageView.image = [NSImage imageNamed:ASSET5];

    self.asset6ImageView.image = [NSImage imageNamed:ASSET6];
    self.asset7ImageView.image = [NSImage imageNamed:ASSET7];
    self.asset8ImageView.image = [NSImage imageNamed:ASSET8];
    self.asset9ImageView.image = [NSImage imageNamed:ASSET9];
    self.asset10ImageView.image = [NSImage imageNamed:ASSET10];

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

    currentSaldo[ASSET1] = @(numberAsset1);
    currentSaldo[ASSET2] = @(numberAsset2);
    currentSaldo[ASSET3] = @(numberAsset3);
    currentSaldo[ASSET4] = @(numberAsset4);
    currentSaldo[ASSET5] = @(numberAsset5);
    currentSaldo[ASSET6] = @(numberAsset6);
    currentSaldo[ASSET7] = @(numberAsset7);
    currentSaldo[ASSET8] = @(numberAsset8);
    currentSaldo[ASSET9] = @(numberAsset9);
    currentSaldo[ASSET10] = @(numberAsset10);

    [calculator currentSaldoForDictionary:currentSaldo];

    // Gespeicherte Daten neu einlesen...
    [self updateView];
}

@end
