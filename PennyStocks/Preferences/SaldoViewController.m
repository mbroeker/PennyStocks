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

    double btc = self.asset1Field.doubleValue;
    double zec = self.asset2Field.doubleValue;
    double eth = self.asset3Field.doubleValue;
    double xmr = self.asset4Field.doubleValue;
    double ltc = self.asset5Field.doubleValue;
    double game = self.asset6Field.doubleValue;
    double emc2 = self.asset7Field.doubleValue;
    double maid = self.asset8Field.doubleValue;
    double bts = self.asset9Field.doubleValue;
    double sc = self.asset10Field.doubleValue;

    currentSaldo[ASSET1] = @(btc);
    currentSaldo[ASSET2] = @(zec);
    currentSaldo[ASSET3] = @(eth);
    currentSaldo[ASSET4] = @(xmr);
    currentSaldo[ASSET5] = @(ltc);
    currentSaldo[ASSET6] = @(game);
    currentSaldo[ASSET7] = @(emc2);
    currentSaldo[ASSET8] = @(maid);
    currentSaldo[ASSET9] = @(bts);
    currentSaldo[ASSET10] = @(sc);

    [calculator currentSaldoForDictionary:currentSaldo];

    // Gespeicherte Daten neu einlesen...
    [self updateView];
}

@end
