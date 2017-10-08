//
//  AppDelegate.h
//  PennyStocks
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(strong) IBOutlet NSMenuItem *menubarItem;
@property(strong) IBOutlet NSMenuItem *eurUSDItem;
@property(strong) IBOutlet NSMenuItem *usdEURItem;

@property(strong) IBOutlet NSMenuItem *eurGBPItem;
@property(strong) IBOutlet NSMenuItem *usdGBPItem;
@property(strong) IBOutlet NSMenuItem *usdCNYItem;
@property(strong) IBOutlet NSMenuItem *usdJPYItem;

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