//
//  ExtraViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 19.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * Extra Settings Management
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface ExtraViewController : NSViewController
@property(strong) IBOutlet NSButton *tradingWithConfirmationButton;
@property(strong) IBOutlet NSTextField *extraSettingsTextField;
@property(strong) IBOutlet NSButton *saveButton;

@property(strong) IBOutlet NSTextField *percentRateLabel;
@property(strong) IBOutlet NSLevelIndicator *percentRateIndicator;

/**
 *
 * @param sender
 */
- (IBAction)sliderAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender;

@end


