//
//  AppDelegate.h
//  iBroker
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenuItem *menubarItem;
@property (weak) IBOutlet NSMenuItem *eurUSDItem;
@property (weak) IBOutlet NSMenuItem *usdEURItem;

@property (weak) IBOutlet NSMenuItem *eurGBPItem;
@property (weak) IBOutlet NSMenuItem *usdGBPItem;
@property (weak) IBOutlet NSMenuItem *usdCNYItem;
@property (weak) IBOutlet NSMenuItem *usdJPYItem;

@end