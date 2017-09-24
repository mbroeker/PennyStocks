//
//  BuyAndSellViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 22.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "BuyAndSellViewController.h"
#import "Calculator.h"

@implementation BuyAndSellViewController {
    @private
    Calculator *calculator;
    NSString *tabLabel;
}

/**
 * Initialize the View
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.buyButton.title = NSLocalizedString(@"buy", "Kaufen");
    self.sellButton.title = NSLocalizedString(@"sell", "Verkaufen");

    NSTabViewController *controller = (NSTabViewController*)[[[NSApplication sharedApplication] mainWindow] contentViewController];
    NSUInteger pos = controller.selectedTabViewItemIndex;
    NSTabViewItem *item = controller.tabViewItems[pos];

    tabLabel = item.label;

    calculator = [Calculator instance];

    // Vorbelegen der Preise
    self.buyAssetPriceField.doubleValue = [calculator btcPriceForAsset:tabLabel];
    self.sellAssetPriceField.doubleValue = [calculator btcPriceForAsset:tabLabel];

    [self updateBuyAndSellView];
}

/**
 * Update the view after user interaction
 */
- (void) updateBuyAndSellView {
    self.buyAssetImage.image = [NSImage imageNamed:tabLabel];
    self.buyAsset1Image.image = [NSImage imageNamed:ASSET1];
    self.buyAsset1TotalImage.image = [NSImage imageNamed:ASSET1];

    self.sellAssetImage.image = [NSImage imageNamed:tabLabel];
    self.sellAsset1Image.image = [NSImage imageNamed:ASSET1];
    self.sellAsset1TotalImage.image = [NSImage imageNamed:ASSET1];

    double amountAssetsToBuy = self.buyAssetField.doubleValue;
    double buyPrice = self.buyAssetPriceField.doubleValue;
    double buyPriceTotal = buyPrice * amountAssetsToBuy;

    self.buyAssetField.doubleValue = amountAssetsToBuy;
    self.buyAsset1TotalField.doubleValue = buyPriceTotal;

    double amountAssetsToSell = self.sellAssetField.doubleValue;
    double sellPrice = self.sellAssetPriceField.doubleValue;
    double sellPriceTotal = sellPrice * amountAssetsToSell;

    self.sellAssetField.doubleValue = amountAssetsToSell;
    self.sellAsset1TotalField.doubleValue = sellPriceTotal;
}

/**
 * close the dialog
 *
 * @param sender
 */
- (IBAction)dismissActionClicked:(id)sender {
    NSWindow *window = self.view.window;
    [window.sheetParent endSheet:window returnCode:NSModalResponseOK];
}

/**
 * Buy the crypto with user supplied conditions
 *
 * @param sender
 */
- (IBAction)buyButtonAction:(id)sender {
    double amount = self.buyAssetField.doubleValue;
    double rate = self.buyAssetPriceField.doubleValue;

    [calculator autoBuy:tabLabel amount:amount withRate:rate];
}

/**
 * Sell the crypto with user supplied conditions
 *
 * @param sender
 */
- (IBAction)sellButtonAction:(id)sender {
    double amount = self.sellAssetField.doubleValue;
    double rate = self.sellAssetPriceField.doubleValue;

    [calculator autoSell:tabLabel amount:amount withRate:rate];
}


/* Kaufen */

/**
 * Update the view after input change
 *
 * @param sender
 */
- (IBAction)buyAssetAction:(id)sender {
    [self updateBuyAndSellView];
}

/**
 * Update the view after input change
 *
 * @param sender
 */
- (IBAction)buyAsset1Action:(id)sender {
    [self updateBuyAndSellView];
}

/**
 * Update the view after input change
 *
 * @param sender
 */
- (IBAction)buyAsset1TotalAction:(id)sender {
    [self updateBuyAndSellView];
}
/* Kaufen ends */


/* Verkaufen */

/**
 * Update the view after input change
 *
 * @param sender
 */
- (IBAction)sellAssetAction:(id)sender {
    [self updateBuyAndSellView];
}

/**
 * Update the view after input change
 *
 * @param sender
 */
- (IBAction)sellAsset1Action:(id)sender {
    [self updateBuyAndSellView];
}

/**
 * Update the view after input change
 *
 * @param sender
 */
- (IBAction)sellAsset1TotalAction:(id)sender {
    [self updateBuyAndSellView];
}
/* Verkaufen ends */

@end
