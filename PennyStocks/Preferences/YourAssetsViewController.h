//
//  YourAssetsViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 06.10.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * Coins Management
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface YourAssetsViewController : NSViewController

@property(weak) IBOutlet NSTextField *titleLabel;

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
@property(weak) IBOutlet NSButton *asset1ImageButton;
@property(weak) IBOutlet NSButton *asset2ImageButton;
@property(weak) IBOutlet NSButton *asset3ImageButton;
@property(weak) IBOutlet NSButton *asset4ImageButton;
@property(weak) IBOutlet NSButton *asset5ImageButton;

@property(weak) IBOutlet NSButton *asset6ImageButton;
@property(weak) IBOutlet NSButton *asset7ImageButton;
@property(weak) IBOutlet NSButton *asset8ImageButton;
@property(weak) IBOutlet NSButton *asset9ImageButton;
@property(weak) IBOutlet NSButton *asset10ImageButton;

/**
 * Save Action
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender;

/**
 * Update the current View
 */
- (void)updateView;

@end
