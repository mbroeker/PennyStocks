//
//  ApplicationsViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 15.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * Application Management
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface ApplicationsViewController : NSViewController

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
 *
 * @param sender
 */
- (IBAction)asset1ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset2ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset3ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset4ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset5ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset6ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset7ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset8ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset9ClickedAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)asset10ClickedAction:(id)sender;

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
