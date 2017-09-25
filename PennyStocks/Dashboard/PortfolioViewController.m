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

@implementation PortfolioViewController {
@private
    NSArray *fields;
    NSArray *initialValues;
}

- (void)viewDidAppear {
    self.view.window.backgroundColor = [NSColor colorWithCalibratedRed:1.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setPreferredContentSize:self.view.frame.size];

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

    fields = @[
        self.asset1Field,
        self.asset2Field,
        self.asset3Field,
        self.asset4Field,
        self.asset5Field,
        self.asset6Field,
        self.asset7Field,
        self.asset8Field,
        self.asset9Field,
        self.asset10Field,
    ];

    for (NSTextField *field in fields) {
        field.editable = false;
    }

    dispatch_queue_t queue = dispatch_queue_create("de.4customers.PennyStocks.updatePortfolioViewer", NULL);
    dispatch_async(queue, ^{

        while (true) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updatePortfolioView];
            });

            [NSThread sleepForTimeInterval:30];
        }

    });
}

/**
 * Formatiere auf n Stellen
 *
 */
- (double)format:(double)value {
    return round(pow(10, 4) * value) / pow(10, 4);
}

- (void)updatePortfolioView {
    Calculator *calculator = [Calculator instance];
    // Aktualisierte Ratings besorgen
    NSDictionary *currentRatings = [calculator currentRatings];

    NSArray *data = @[
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET1]]),
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET2]]),
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET3]]),
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET4]]),
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET5]]),

        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET6]]),
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET7]]),
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET8]]),
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET9]]),
        @([self format:[calculator calculateWithRatings:currentRatings currency:ASSET10]]),
    ];

    if (initialValues == nil) {
        initialValues = [NSArray arrayWithArray:data];
    }

    for (int i = 0; i < fields.count; i++) {
        NSTextField *field = (NSTextField *) fields[i];
        double currentCoins = [data[i] doubleValue];
        double initialCoins = [initialValues[i] doubleValue];

        field.stringValue = [Helper double2German:[data[i] doubleValue] min:4 max:4];

        if (currentCoins > initialCoins) {
            field.backgroundColor = [NSColor greenColor];
        } else if (currentCoins < initialCoins) {
            field.backgroundColor = [NSColor yellowColor];
        } else {
            field.backgroundColor = [NSColor whiteColor];
        }
    }
}

- (IBAction)asset1ClickedAction:(id)sender {
    if ([Helper messageText:NSLocalizedString(@"all_charts", @"") info:NSLocalizedString(@"wanna_update_current_saldo", @"")] == NSAlertFirstButtonReturn) {
        initialValues = nil;
    }

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
