//
//  TabViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "TabViewController.h"
#import "CalculatorConstants.h"

#define DEFAULT_TIMEOUT 30

@implementation TabViewController {
@private
    TemplateViewController *controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabView.delegate = self;

    self.asset1TabViewItem.label = ASSET1;
    self.asset2TabViewItem.label = ASSET2;
    self.asset3TabViewItem.label = ASSET3;
    self.asset4TabViewItem.label = ASSET4;
    self.asset5TabViewItem.label = ASSET5;
    self.asset6TabViewItem.label = ASSET6;
    self.asset7TabViewItem.label = ASSET7;
    self.asset8TabViewItem.label = ASSET8;
    self.asset9TabViewItem.label = ASSET9;
    self.asset10TabViewItem.label = ASSET10;

    controller = (TemplateViewController*)self.tabViewItems.firstObject.viewController;
    [controller updateAssistant];

    // Startseite aufrufen
    [controller updateOverview];

    dispatch_queue_t autoRefreshQueue = dispatch_queue_create("de.4customers.PennyStocks.autoRefresh", NULL);
    dispatch_async(autoRefreshQueue, ^{

        while(true) {
            [NSThread sleepForTimeInterval:DEFAULT_TIMEOUT];

            [controller updateBalanceAndRatings];
            dispatch_async(dispatch_get_main_queue(), ^{
                [controller updateCurrentView:true];
            });
        }

    });
}

/**
 * Sinn und Zweck: Erkennen des jeweils angewählten Tabs
 *
 * @param tabViewItem
 */
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    [super tabView:tabView didSelectTabViewItem:tabViewItem];

    NSString *tab = tabViewItem.label;

    controller = (TemplateViewController*)tabViewItem.viewController;
    [controller updateTemplateView:tab];
}

@end
