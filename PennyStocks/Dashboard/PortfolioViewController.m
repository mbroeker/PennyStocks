//
//  PortfolioViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 14.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "PortfolioViewController.h"
#import "Calculator.h"
#import "CalculatorConstants.h"
#import "Helper.h"

@interface PortfolioViewController ()

@end

@implementation PortfolioViewController

- (void)viewDidAppear {
    self.view.window.backgroundColor = [NSColor colorWithCalibratedRed:1.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setPreferredContentSize:self.view.frame.size];

    self.asset1Field.editable = false;
    self.asset2Field.editable = false;
    self.asset3Field.editable = false;
    self.asset4Field.editable = false;
    self.asset5Field.editable = false;
    self.asset6Field.editable = false;
    self.asset7Field.editable = false;
    self.asset8Field.editable = false;
    self.asset9Field.editable = false;
    self.asset10Field.editable = false;

    self.asset1ImageButton.image = [NSImage imageNamed:ASSET1];
    self.asset2ImageButton.image = [NSImage imageNamed:ASSET2];
    self.asset3ImageButton.image = [NSImage imageNamed:ASSET3];
    self.asset4ImageButton.image = [NSImage imageNamed:ASSET4];
    self.asset5ImageButton.image = [NSImage imageNamed:ASSET5];

    self.asset6ImageButton.image = [NSImage imageNamed:ASSET6];
    self.asset7ImageButton.image = [NSImage imageNamed:ASSET7];
    self.asset8ImageButton.image = [NSImage imageNamed:ASSET8];
    self.asset9ImageButton.image = [NSImage imageNamed:ASSET9];
    self.asset10ImageButton.image = [NSImage imageNamed:ASSET10];

    self.title = NSLocalizedString(@"total_saldo", @"Gesamtbestand umgerechnet");

    [self updatePortfolioView];
}

- (void)updatePortfolioView {
    Calculator *calculator = [Calculator instance];

    // Aktualisierte Ratings besorgen
    NSMutableDictionary *currentRatings = [calculator currentRatings];

    NSArray *data = @[
        @([calculator calculateWithRatings:currentRatings currency:ASSET1]),
        @([calculator calculateWithRatings:currentRatings currency:ASSET2]),
        @([calculator calculateWithRatings:currentRatings currency:ASSET3]),
        @([calculator calculateWithRatings:currentRatings currency:ASSET4]),
        @([calculator calculateWithRatings:currentRatings currency:ASSET5]),

        @([calculator calculateWithRatings:currentRatings currency:ASSET6]),
        @([calculator calculateWithRatings:currentRatings currency:ASSET7]),
        @([calculator calculateWithRatings:currentRatings currency:ASSET8]),
        @([calculator calculateWithRatings:currentRatings currency:ASSET9]),
        @([calculator calculateWithRatings:currentRatings currency:ASSET10]),
    ];

    self.asset1Field.stringValue = [Helper double2German:[data[0] doubleValue] min:8 max:8];
    self.asset2Field.stringValue = [Helper double2German:[data[1] doubleValue] min:8 max:8];
    self.asset3Field.stringValue = [Helper double2German:[data[2] doubleValue] min:8 max:8];
    self.asset4Field.stringValue = [Helper double2German:[data[3] doubleValue] min:8 max:8];
    self.asset5Field.stringValue = [Helper double2German:[data[4] doubleValue] min:8 max:8];

    self.asset6Field.stringValue = [Helper double2German:[data[5] doubleValue] min:8 max:8];
    self.asset7Field.stringValue = [Helper double2German:[data[6] doubleValue] min:8 max:8];
    self.asset8Field.stringValue = [Helper double2German:[data[7] doubleValue] min:8 max:8];
    self.asset9Field.stringValue = [Helper double2German:[data[8] doubleValue] min:8 max:8];
    self.asset10Field.stringValue = [Helper double2German:[data[9] doubleValue] min:8 max:8];
}

- (IBAction)asset1ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset2ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset3ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset4ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset5ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset6ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset7ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset8ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset9ClickedAction:(id)sender {
    [self updatePortfolioView];
}

- (IBAction)asset10ClickedAction:(id)sender {
    [self updatePortfolioView];
}

@end
