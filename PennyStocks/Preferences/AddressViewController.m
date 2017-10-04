//
//  WalletsViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 26.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "AddressViewController.h"
#import "Calculator.h"

@implementation AddressViewController {
    Calculator *calculator;
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
 * Aktualisierung des Views vereinheitlicht
 */
- (void)updateView {
    calculator = [Calculator instance];

    // aktualisierten Saldo besorgen
    NSMutableDictionary *saldoUrls = [calculator saldoUrls];

    self.asset1Field.stringValue = saldoUrls[ASSET_DESC(1)];
    self.asset2Field.stringValue = saldoUrls[ASSET_DESC(2)];
    self.asset3Field.stringValue = saldoUrls[ASSET_DESC(3)];
    self.asset4Field.stringValue = saldoUrls[ASSET_DESC(4)];
    self.asset5Field.stringValue = saldoUrls[ASSET_DESC(5)];
    self.asset6Field.stringValue = saldoUrls[ASSET_DESC(6)];
    self.asset7Field.stringValue = saldoUrls[ASSET_DESC(7)];
    self.asset8Field.stringValue = saldoUrls[ASSET_DESC(8)];
    self.asset9Field.stringValue = saldoUrls[ASSET_DESC(9)];
    self.asset10Field.stringValue = saldoUrls[ASSET_DESC(10)];

    self.dashboardField.stringValue = saldoUrls[DASHBOARD];
}

/**
 * Speichern der Adressen des Nutzers
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender {
    // aktualisierten Saldo besorgen
    NSMutableDictionary *saldoUrls = [calculator saldoUrls];

    saldoUrls[ASSET_DESC(1)] = self.asset1Field.stringValue;
    saldoUrls[ASSET_DESC(2)] = self.asset2Field.stringValue;
    saldoUrls[ASSET_DESC(3)] = self.asset3Field.stringValue;
    saldoUrls[ASSET_DESC(4)] = self.asset4Field.stringValue;
    saldoUrls[ASSET_DESC(5)] = self.asset5Field.stringValue;
    saldoUrls[ASSET_DESC(6)] = self.asset6Field.stringValue;
    saldoUrls[ASSET_DESC(7)] = self.asset7Field.stringValue;
    saldoUrls[ASSET_DESC(8)] = self.asset8Field.stringValue;
    saldoUrls[ASSET_DESC(9)] = self.asset9Field.stringValue;
    saldoUrls[ASSET_DESC(10)] = self.asset10Field.stringValue;
    saldoUrls[DASHBOARD] = self.dashboardField.stringValue;

    [calculator saldoUrlsForDictionary:saldoUrls];

    // Gespeicherte Daten neu einlesen...
    [self updateView];
}

@end
