//
//  AppDelegate.h
//  PennyStocks
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * Category for Migration of Preferences
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property(weak) IBOutlet NSMenuItem *menubarItem;
@property(weak) IBOutlet NSMenuItem *eurUSDItem;
@property(weak) IBOutlet NSMenuItem *usdEURItem;

@property(weak) IBOutlet NSMenuItem *eurGBPItem;
@property(weak) IBOutlet NSMenuItem *usdGBPItem;
@property(weak) IBOutlet NSMenuItem *usdCNYItem;
@property(weak) IBOutlet NSMenuItem *usdJPYItem;

/**
 * EUR / USD
 *
 * @param sender
 */
- (IBAction)fiateurUSDAction:(id)sender;

/**
 * USD / EUR
 *
 * @param sender
 */
- (IBAction)fiatusdEURAction:(id)sender;

/**
 * EUR / GBP
 *
 * @param sender
 */
- (IBAction)fiateurGBPAction:(id)sender;

/**
 * USD / GBP
 *
 * @param sender
 */
- (IBAction)fiatusdGBPAction:(id)sender;

/**
 * USD / CNY
 *
 * @param sender
 */
- (IBAction)fiatusdCNYAction:(id)sender;

/**
 * USD / JPY
 *
 * @param sender
 */
- (IBAction)fiatusdJPYAction:(id)sender;

/**
 * Menubar ON/OFF
 *
 * @param sender
 */
- (IBAction)toggleMenuBar:(id)sender;

/**
* Reset the entire application data
*
* @param sender
*/
- (IBAction)applicationReset:(id)sender;

@end