//
//  SaldoViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 21.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * Saldo / Balance Management
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface SaldoViewController : NSViewController

// Properties List
@property(weak) IBOutlet NSTextField *asset1Field;
@property(weak) IBOutlet NSTextField *asset2Field;
@property(weak) IBOutlet NSTextField *asset3Field;
@property(weak) IBOutlet NSTextField *asset4Field;
@property(weak) IBOutlet NSTextField *asset5Field;
@property(weak) IBOutlet NSTextField *asset6Field;
@property(weak) IBOutlet NSTextField *asset7Field;
@property(weak) IBOutlet NSTextField *asset8Field;
@property(weak) IBOutlet NSTextField *asset9Field;
@property(weak) IBOutlet NSTextField *asset10Field;

// Images List
@property(strong) IBOutlet NSImageView *asset1ImageView;
@property(strong) IBOutlet NSImageView *asset2ImageView;
@property(strong) IBOutlet NSImageView *asset3ImageView;
@property(strong) IBOutlet NSImageView *asset4ImageView;
@property(strong) IBOutlet NSImageView *asset5ImageView;
@property(strong) IBOutlet NSImageView *asset6ImageView;
@property(strong) IBOutlet NSImageView *asset7ImageView;
@property(strong) IBOutlet NSImageView *asset8ImageView;
@property(strong) IBOutlet NSImageView *asset9ImageView;
@property(strong) IBOutlet NSImageView *asset10ImageView;

/**
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender;

/**
 * Update the current View
 */
- (void)updateView;

@end
