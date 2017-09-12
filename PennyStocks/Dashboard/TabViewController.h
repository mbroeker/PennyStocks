//
//  TabViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TemplateViewController.h"

@interface TabViewController : NSTabViewController<NSTabViewDelegate>

// Reihe 1 der TabviewItem Labels
@property (strong) IBOutlet NSTabViewItem *asset1TabViewItem;
@property (strong) IBOutlet NSTabViewItem *asset2TabViewItem;
@property (strong) IBOutlet NSTabViewItem *asset3TabViewItem;
@property (strong) IBOutlet NSTabViewItem *asset4TabViewItem;
@property (strong) IBOutlet NSTabViewItem *asset5TabViewItem;

// Reihe 2 der TabviewItem Labels
@property (strong) IBOutlet NSTabViewItem *asset6TabViewItem;
@property (strong) IBOutlet NSTabViewItem *asset7TabViewItem;
@property (strong) IBOutlet NSTabViewItem *asset8TabViewItem;
@property (strong) IBOutlet NSTabViewItem *asset9TabViewItem;
@property (strong) IBOutlet NSTabViewItem *asset10TabViewItem;

@end
