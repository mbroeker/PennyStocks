//
//  YourAssetsViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 06.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "YourAssetsViewController.h"
#import "Calculator.h"

@implementation YourAssetsViewController

- (void)viewDidLoad {
    // Properties List
    self.asset1Field.placeholderString = ASSET_KEY(1);
    self.asset2Field.placeholderString = ASSET_KEY(2);
    self.asset3Field.placeholderString = ASSET_KEY(3);
    self.asset4Field.placeholderString = ASSET_KEY(4);
    self.asset5Field.placeholderString = ASSET_KEY(5);

    self.asset6Field.placeholderString = ASSET_KEY(6);
    self.asset7Field.placeholderString = ASSET_KEY(7);
    self.asset8Field.placeholderString = ASSET_KEY(8);
    self.asset9Field.placeholderString = ASSET_KEY(9);
    self.asset10Field.placeholderString = ASSET_KEY(10);

    self.asset1Field.stringValue = ASSET_KEY(1);
    self.asset2Field.stringValue = ASSET_KEY(2);
    self.asset3Field.stringValue = ASSET_KEY(3);
    self.asset4Field.stringValue = ASSET_KEY(4);
    self.asset5Field.stringValue = ASSET_KEY(5);

    self.asset6Field.stringValue = ASSET_KEY(6);
    self.asset7Field.stringValue = ASSET_KEY(7);
    self.asset8Field.stringValue = ASSET_KEY(8);
    self.asset9Field.stringValue = ASSET_KEY(9);
    self.asset10Field.stringValue = ASSET_KEY(10);

#ifdef RELEASE_BUILD
    // MASTER ASSET is not changeable in UI!
    self.asset1Field.enabled = NO;
#endif    

    // Images List
    self.asset1ImageButton.image = [NSImage imageNamed:ASSET_KEY(1)];
    self.asset2ImageButton.image = [NSImage imageNamed:ASSET_KEY(2)];
    self.asset3ImageButton.image = [NSImage imageNamed:ASSET_KEY(3)];
    self.asset4ImageButton.image = [NSImage imageNamed:ASSET_KEY(4)];
    self.asset5ImageButton.image = [NSImage imageNamed:ASSET_KEY(5)];

    self.asset6ImageButton.image = [NSImage imageNamed:ASSET_KEY(6)];
    self.asset7ImageButton.image = [NSImage imageNamed:ASSET_KEY(7)];
    self.asset8ImageButton.image = [NSImage imageNamed:ASSET_KEY(8)];
    self.asset9ImageButton.image = [NSImage imageNamed:ASSET_KEY(9)];
    self.asset10ImageButton.image = [NSImage imageNamed:ASSET_KEY(10)];
}

/**
 * Aktualisierung des Views vereinheitlicht
 */
- (void)updateView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // aktualisierten Saldo besorgen
    NSArray *currentAssets = [defaults objectForKey:KEY_CURRENT_ASSETS];

    self.asset1Field.stringValue = currentAssets[1][0];
    self.asset2Field.stringValue = currentAssets[2][0];
    self.asset3Field.stringValue = currentAssets[3][0];
    self.asset4Field.stringValue = currentAssets[4][0];
    self.asset5Field.stringValue = currentAssets[5][0];
    self.asset6Field.stringValue = currentAssets[6][0];
    self.asset7Field.stringValue = currentAssets[7][0];
    self.asset8Field.stringValue = currentAssets[8][0];
    self.asset9Field.stringValue = currentAssets[9][0];
    self.asset10Field.stringValue = currentAssets[10][0];

    // Images List
    self.asset1ImageButton.image = [NSImage imageNamed:currentAssets[1][0]];
    self.asset2ImageButton.image = [NSImage imageNamed:currentAssets[2][0]];
    self.asset3ImageButton.image = [NSImage imageNamed:currentAssets[3][0]];
    self.asset4ImageButton.image = [NSImage imageNamed:currentAssets[4][0]];
    self.asset5ImageButton.image = [NSImage imageNamed:currentAssets[5][0]];

    self.asset6ImageButton.image = [NSImage imageNamed:currentAssets[6][0]];
    self.asset7ImageButton.image = [NSImage imageNamed:currentAssets[7][0]];
    self.asset8ImageButton.image = [NSImage imageNamed:currentAssets[8][0]];
    self.asset9ImageButton.image = [NSImage imageNamed:currentAssets[9][0]];
    self.asset10ImageButton.image = [NSImage imageNamed:currentAssets[10][0]];
}

/**
 * Speichern der Adressen des Nutzers
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender {

    NSArray *currentAssets = @[
        @[DASHBOARD, DASHBOARD],
        @[self.asset1Field.stringValue, [self pictureForKey:self.asset1Field.stringValue]],
        @[self.asset2Field.stringValue, [self pictureForKey:self.asset2Field.stringValue]],
        @[self.asset3Field.stringValue, [self pictureForKey:self.asset3Field.stringValue]],
        @[self.asset4Field.stringValue, [self pictureForKey:self.asset4Field.stringValue]],
        @[self.asset5Field.stringValue, [self pictureForKey:self.asset5Field.stringValue]],
        @[self.asset6Field.stringValue, [self pictureForKey:self.asset6Field.stringValue]],
        @[self.asset7Field.stringValue, [self pictureForKey:self.asset7Field.stringValue]],
        @[self.asset8Field.stringValue, [self pictureForKey:self.asset8Field.stringValue]],
        @[self.asset9Field.stringValue, [self pictureForKey:self.asset9Field.stringValue]],
        @[self.asset10Field.stringValue, [self pictureForKey:self.asset10Field.stringValue]],
    ];

    BOOL insertable = YES;
    for (int i = 0; i < currentAssets.count; i++) {
        NSArray *check = currentAssets[i];
        if ([check[0] isEqualToString:@""] || [check[1] isEqualToString:@""]) {
            insertable = NO;
            break;
        }
    }

    if (insertable) {
        self.titleLabel.stringValue = NSLocalizedString(@"restart_required", @"Restart required");
        self.titleLabel.textColor = [NSColor redColor];
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        [[defaults objectForKey:KEY_CURRENT_ASSETS] mutableCopy];
        [defaults setObject:currentAssets forKey:KEY_CURRENT_ASSETS];
        [defaults synchronize];
    }

    // Gepeicherte Daten neu einlesen...
    [self updateView];    
}

/**
 * pictureForKey
 *
 * @param key
 */
- (NSString *)pictureForKey:(NSString*)key {
    NSDictionary *images = @{
        @"ADA": @"Cardano",
        @"ADX": @"AD Token",
        @"ARK": @"Ark Byte",
        @"BAT": @"BAT",
        @"BCC": @"BC Cash",
        @"BTC": @"Bitcoin",
        @"BTS": @"BitShares",
        @"DASH": @"Dash",
        @"DCR": @"Decred",
        @"DGB": @"DigiByte",
        @"DOGE": @"Dogecoin",
        @"EMC2": @"Einsteinium",
        @"ERC": @"Europe Coin",
        @"ETC": @"Ethereum Classic",
        @"ETH": @"Ethereum",
        @"GAME": @"GameCredits",
        @"GME": @"GME",
        @"IOP": @"Internet of People",
        @"KMD": @"Komodo",
        @"LDOGE": @"Light Doge",
        @"LSK": @"Lisk",
        @"LTC": @"Litecoin",
        @"MAID": @"Safemaid",
        @"MCO": @"Monaco",
        @"NEO": @"NEO",
        @"OK": @"OK",
        @"OMG": @"Omise GO",
        @"PAY": @"Pay Token",
        @"PTC": @"Pesetacoin",
        @"QTUM": @"Qtum",
        @"RDD": @"Red Coin",
        @"RISE": @"Rise",
        @"SC": @"Siacoin",
        @"STEEM": @"Steem",
        @"STR": @"Stellar Lumens",
        @"STRAT": @"Stratis",
        @"SYS": @"Syscoin",
        @"XEM": @"XEM",
        @"XMR": @"Monero",
        @"XRP": @"Ripple",
        @"XVG": @"The Verge",
        @"ZEC": @"ZCash",
    };

    // We are dealing with NSUSerDefaults: It must be a valid string
    if (!images[key]) { return @""; }

    return images[key];
}

@end
