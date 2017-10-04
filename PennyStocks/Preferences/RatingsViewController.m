//
//  RatingsViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 26.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "RatingsViewController.h"
#import "Calculator.h"

@implementation RatingsViewController {
    Calculator *calculator;
}

- (void)viewWillAppear {
    NSNumberFormatter *formatter;

    formatter = self.asset1Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset2Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset3Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset4Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset5Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset6Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset7Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset8Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset10Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];

    formatter = self.asset9Field.formatter;
    [formatter setMinimumFractionDigits:4];
    [formatter setMaximumFractionDigits:4];
}

/**
 * Aktualisierung des Views vereinheitlicht
 */
- (void)updateView {
    calculator = [Calculator instance];

    // Aktualisierte Ratings besorgen
    NSMutableDictionary *ratings = [calculator initialRatings];

    self.asset1Field.doubleValue = 1 / [ratings[ASSET_KEY(1)] doubleValue];
    self.asset2Field.doubleValue = 1 / [ratings[ASSET_KEY(2)] doubleValue];
    self.asset3Field.doubleValue = 1 / [ratings[ASSET_KEY(3)] doubleValue];
    self.asset4Field.doubleValue = 1 / [ratings[ASSET_KEY(4)] doubleValue];
    self.asset5Field.doubleValue = 1 / [ratings[ASSET_KEY(5)] doubleValue];
    self.asset6Field.doubleValue = 1 / [ratings[ASSET_KEY(6)] doubleValue];
    self.asset7Field.doubleValue = 1 / [ratings[ASSET_KEY(7)] doubleValue];
    self.asset8Field.doubleValue = 1 / [ratings[ASSET_KEY(8)] doubleValue];
    self.asset9Field.doubleValue = 1 / [ratings[ASSET_KEY(9)] doubleValue];
    self.asset10Field.doubleValue = 1 / [ratings[ASSET_KEY(10)] doubleValue];
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
    NSMutableDictionary *initialRatings = [calculator initialRatings];

    double numberAsset1 = 1 / self.asset1Field.doubleValue;
    double numberAsset2 = 1 / self.asset2Field.doubleValue;
    double numberAsset3 = 1 / self.asset3Field.doubleValue;
    double numberAsset4 = 1 / self.asset4Field.doubleValue;
    double numberAsset5 = 1 / self.asset5Field.doubleValue;
    double numberAsset6 = 1 / self.asset6Field.doubleValue;
    double numberAsset7 = 1 / self.asset7Field.doubleValue;
    double numberAsset8 = 1 / self.asset8Field.doubleValue;
    double numberAsset9 = 1 / self.asset9Field.doubleValue;
    double numberAsset10 = 1 / self.asset10Field.doubleValue;

    initialRatings[ASSET_KEY(1)] = @(numberAsset1);
    initialRatings[ASSET_KEY(2)] = @(numberAsset2);
    initialRatings[ASSET_KEY(3)] = @(numberAsset3);
    initialRatings[ASSET_KEY(4)] = @(numberAsset4);
    initialRatings[ASSET_KEY(5)] = @(numberAsset5);
    initialRatings[ASSET_KEY(6)] = @(numberAsset6);
    initialRatings[ASSET_KEY(7)] = @(numberAsset7);
    initialRatings[ASSET_KEY(8)] = @(numberAsset8);
    initialRatings[ASSET_KEY(9)] = @(numberAsset9);
    initialRatings[ASSET_KEY(10)] = @(numberAsset10);

    [calculator initialRatingsWithDictionary:initialRatings];

    // Gespeicherte Daten neu einlesen...
    [self updateView];
}

@end
