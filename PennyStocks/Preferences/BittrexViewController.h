//
//  BittrexViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 26.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * Settings for Bittrex
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface BittrexViewController : NSViewController

@property(strong) IBOutlet NSButton *standardExchangeButton;
@property(strong) IBOutlet NSTextField *apikeyField;
@property(strong) IBOutlet NSSecureTextField *secretField;

@property(strong) IBOutlet NSTextField *legalNoticeLabel;
@property(strong) IBOutlet NSButton *keyEraseButton;
@property(strong) IBOutlet NSButton *saveButton;

/**
 *
 * @param sender
 */
- (IBAction)keyEraseAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)standardExchangeAction:(id)sender;

@end
