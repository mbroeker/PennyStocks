//
//  ExtraViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 19.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "ExtraViewController.h"
#import "CalculatorConstants.h"

@implementation ExtraViewController {
    NSUserDefaults *defaults;
}

/**
 * Nervige Farbverbesserungen
 *
 */
- (void)awakeFromNib {
    self.extraSettingsTextField.textColor = [NSColor whiteColor];
    self.percentRateLabel.textColor = [NSColor whiteColor];
    self.extraSettingsTextField.textColor = [NSColor blackColor];

    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"actions_ack", @"Aktionen bestätigen")];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:range];
    [attrTitle fixAttributesInRange:range];

    [self.tradingWithConfirmationButton setAttributedTitle:attrTitle];
    self.extraSettingsTextField.stringValue = NSLocalizedString(@"extra_settings_text", @"Standard Text");
}

/**
 * Initialisierung des ViewControllers
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    defaults = [NSUserDefaults standardUserDefaults];
    [self updateExtraViewController];
}

/**
 * Aktualisiert Slider und Button
 */
- (void)updateExtraViewController {
    NSNumber *percentRate = [defaults objectForKey:COINCHANGE_PERCENTAGE];
    NSNumber *tradingWithConfirmation = [defaults objectForKey:KEY_TRADING_WITH_CONFIRMATION];

    self.percentRateIndicator.integerValue = [percentRate integerValue];
    self.percentRateLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"percentrate_with_param", @"Prozentrate"), [percentRate doubleValue]];

    if (tradingWithConfirmation.boolValue == YES) {
        self.tradingWithConfirmationButton.state = NSOnState;
    } else {
        self.tradingWithConfirmationButton.state = NSOffState;
    }
}

/**
 * Aktualisiert nur den Text oben rechts
 */
- (IBAction)sliderAction:(id)sender {
    double percentRate = self.percentRateIndicator.integerValue;
    self.percentRateLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"percentrate_with_param", @"Prozentrate"), percentRate];
}

/**
 * Speichert den State des Views
 */
- (IBAction)saveAction:(id)sender {
    NSNumber *percentRate = @(self.percentRateIndicator.integerValue);
    NSNumber *tradingWithConfirmation = [NSNumber numberWithBool:(self.tradingWithConfirmationButton.state == NSOnState)];

    [defaults setObject:percentRate forKey:COINCHANGE_PERCENTAGE];
    [defaults setObject:tradingWithConfirmation forKey:KEY_TRADING_WITH_CONFIRMATION];

    [defaults synchronize];

    [self updateExtraViewController];
}

@end
