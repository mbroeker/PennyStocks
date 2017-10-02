//
//  AppDelegate.h
//  PennyStocks
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) IBOutlet NSMenuItem *menubarItem;
@property (strong) IBOutlet NSMenuItem *eurUSDItem;
@property (strong) IBOutlet NSMenuItem *usdEURItem;

@property (strong) IBOutlet NSMenuItem *eurGBPItem;
@property (strong) IBOutlet NSMenuItem *usdGBPItem;
@property (strong) IBOutlet NSMenuItem *usdCNYItem;
@property (strong) IBOutlet NSMenuItem *usdJPYItem;

@end