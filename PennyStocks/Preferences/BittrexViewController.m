//
//  BittrexViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 26.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "BittrexViewController.h"
#import "Calculator.h"

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

    NSDictionary *apiKey = [defaults objectForKey:@"BITTREX_KEY"];
    NSString *secret = [defaults objectForKey:@"BITTREX_SEC"];

    NSString *defaultExchange = [defaults objectForKey:KEY_DEFAULT_EXCHANGE];

    self.standardExchangeButton.state = NSOffState;
    if ([defaultExchange isEqualToString:@"BITTREX_EXCHANGE"]) {
        self.standardExchangeButton.state = NSOnState;
    }

    self.apikeyField.stringValue = (apiKey != nil) ? apiKey[@"Key"] : @"";
    self.secretField.stringValue = (secret != nil) ? secret : @"";

    self.legalNoticeLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"legal_notice", @"legal_notice"), @"Bittrex"];
}

- (IBAction)standardExchangeAction:(id)sender {
    Calculator *calculator = [Calculator instance];
    [calculator defaultExchange:@"BITTREX_EXCHANGE"];

    [self updateView];
}

- (IBAction)saveAction:(id)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *apiKey = [[NSMutableDictionary alloc] init];
    NSString *secret = self.secretField.stringValue;
    apiKey[@"Key"] = self.apikeyField.stringValue;

    [defaults setObject:apiKey forKey:@"BITTREX_KEY"];
    [defaults setObject:secret forKey:@"BITTREX_SEC"];

    [defaults synchronize];

    [self updateView];
}

- (IBAction)keyEraseAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults removeObjectForKey:@"BITTREX_KEY"];
    [defaults removeObjectForKey:@"BITTREX_SEC"];

    [defaults synchronize];

    [self updateView];
}
@end
