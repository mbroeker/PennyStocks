//
//  ApplicationsViewController.m
//  iBroker
//
//  Created by Markus Bröker on 15.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "ApplicationsViewController.h"
#import "Calculator.h"

@implementation ApplicationsViewController {
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

    // Images List
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // aktualisierten Saldo besorgen
    NSMutableDictionary *applications = [[defaults objectForKey:TV_APPLICATIONS] mutableCopy];

    self.asset1Field.stringValue = applications[ASSET1_DESC];
    self.asset2Field.stringValue = applications[ASSET2_DESC];
    self.asset3Field.stringValue = applications[ASSET3_DESC];
    self.asset4Field.stringValue = applications[ASSET4_DESC];
    self.asset5Field.stringValue = applications[ASSET5_DESC];
    self.asset6Field.stringValue = applications[ASSET6_DESC];
    self.asset7Field.stringValue = applications[ASSET7_DESC];
    self.asset8Field.stringValue = applications[ASSET8_DESC];
    self.asset9Field.stringValue = applications[ASSET9_DESC];
    self.asset10Field.stringValue = applications[ASSET10_DESC];
}

/**
 * Speichern der Adressen des Nutzers
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // aktualisierten Saldo besorgen
    NSMutableDictionary *applications = [[defaults objectForKey:TV_APPLICATIONS] mutableCopy];
    
    applications[ASSET1_DESC] = self.asset1Field.stringValue;
    applications[ASSET2_DESC] = self.asset2Field.stringValue;
    applications[ASSET3_DESC] = self.asset3Field.stringValue;
    applications[ASSET4_DESC] = self.asset4Field.stringValue;
    applications[ASSET5_DESC] = self.asset5Field.stringValue;
    applications[ASSET6_DESC] = self.asset6Field.stringValue;
    applications[ASSET7_DESC] = self.asset7Field.stringValue;
    applications[ASSET8_DESC] = self.asset8Field.stringValue;
    applications[ASSET9_DESC] = self.asset9Field.stringValue;
    applications[ASSET10_DESC] = self.asset10Field.stringValue;

    [defaults setObject:applications forKey:TV_APPLICATIONS];
    [defaults synchronize];

    // Gepeicherte Daten neu einlesen...
    [self updateView];
}

@end
