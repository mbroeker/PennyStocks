//
//  BittrexViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 26.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "BittrexViewController.h"
#import "Calculator.h"
#import "CalculatorConstants.h"
#import "KeychainWrapper.h"

@implementation BittrexViewController

- (void)awakeFromNib {
    NSColor *color = [NSColor whiteColor];
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self.standardExchangeButton attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [self.standardExchangeButton setAttributedTitle:colorTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateView];
}

- (void)updateView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *keychain = [KeychainWrapper keychain2ApiKeyAndSecret:@"BITTREX"];

    self.apikeyField.stringValue = (keychain[@"apiKey"] != nil) ? keychain[@"apiKey"][@"Key"] : @"";
    self.secretField.stringValue = (keychain[@"secret"] != nil) ? keychain[@"secret"] : @"";

    NSString *defaultExchange = [defaults objectForKey:KEY_DEFAULT_EXCHANGE];

    self.standardExchangeButton.state = NSOffState;
    if ([defaultExchange isEqualToString:EXCHANGE_BITTREX]) {
        self.standardExchangeButton.state = NSOnState;
    }

    self.legalNoticeLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"legal_notice", @"legal_notice"), @"Bittrex"];
}

- (IBAction)standardExchangeAction:(id)sender {
    Calculator *calculator = [Calculator instance];
    [calculator defaultExchange:EXCHANGE_BITTREX];

    [self updateView];
}

- (IBAction)saveAction:(id)sender {

    NSString *combinedKey = [NSString stringWithFormat:@"%@:%@", self.apikeyField.stringValue, self.secretField.stringValue];
    [KeychainWrapper createKeychainValue:combinedKey forIdentifier:@"BITTREX"];

    [self updateView];
}

- (IBAction)keyEraseAction:(id)sender {
    [KeychainWrapper deleteItemFromKeychainWithIdentifier:@"BITTREX"];
    [self updateView];
}
@end
