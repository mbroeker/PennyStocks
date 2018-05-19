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

@property(weak) IBOutlet NSButton *standardExchangeButton;
@property(weak) IBOutlet NSTextField *apikeyField;
@property(weak) IBOutlet NSSecureTextField *secretField;

@property(weak) IBOutlet NSTextField *legalNoticeLabel;
@property(weak) IBOutlet NSButton *keyEraseButton;
@property(weak) IBOutlet NSButton *saveButton;

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
