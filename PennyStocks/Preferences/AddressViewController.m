//
//  WalletsViewController.m
//  iBroker
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
    self.asset1Field.placeholderString = ASSET1_DESC;
    self.asset2Field.placeholderString = ASSET2_DESC;
    self.asset3Field.placeholderString = ASSET3_DESC;
    self.asset4Field.placeholderString = ASSET4_DESC;
    self.asset5Field.placeholderString = ASSET5_DESC;

    self.asset6Field.placeholderString = ASSET6_DESC;
    self.asset7Field.placeholderString = ASSET7_DESC;
    self.asset8Field.placeholderString = ASSET8_DESC;
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
 * Aktualisierung des Views vereinheitlicht
 */
- (void)updateView {
    calculator = [Calculator instance];

    // aktualisierten Saldo besorgen
    NSMutableDictionary *saldoUrls = [calculator saldoUrls];
    
    self.asset1Field.stringValue = saldoUrls[ASSET1_DESC];
    self.asset2Field.stringValue = saldoUrls[ASSET2_DESC];
    self.asset3Field.stringValue = saldoUrls[ASSET3_DESC];
    self.asset4Field.stringValue = saldoUrls[ASSET4_DESC];
    self.asset5Field.stringValue = saldoUrls[ASSET5_DESC];
    self.asset6Field.stringValue = saldoUrls[ASSET6_DESC];
    self.asset7Field.stringValue = saldoUrls[ASSET7_DESC];
    self.asset8Field.stringValue = saldoUrls[ASSET8_DESC];
    self.asset9Field.stringValue = saldoUrls[ASSET9_DESC];
    self.asset10Field.stringValue = saldoUrls[ASSET10_DESC];
    
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

    saldoUrls[ASSET1_DESC] = self.asset1Field.stringValue;
    saldoUrls[ASSET2_DESC] = self.asset2Field.stringValue;
    saldoUrls[ASSET3_DESC] = self.asset3Field.stringValue;
    saldoUrls[ASSET4_DESC] = self.asset4Field.stringValue;
    saldoUrls[ASSET5_DESC] = self.asset5Field.stringValue;
    saldoUrls[ASSET6_DESC] = self.asset6Field.stringValue;
    saldoUrls[ASSET7_DESC] = self.asset7Field.stringValue;
    saldoUrls[ASSET8_DESC] = self.asset8Field.stringValue;
    saldoUrls[ASSET9_DESC] = self.asset9Field.stringValue;
    saldoUrls[ASSET10_DESC] = self.asset10Field.stringValue;
    saldoUrls[DASHBOARD] = self.dashboardField.stringValue;
    
    [calculator saldoUrlsForDictionary:saldoUrls];

    // Gespeicherte Daten neu einlesen...
    [self updateView];
}

@end
