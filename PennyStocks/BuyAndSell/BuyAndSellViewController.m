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
}

/**
 * Initialize the View
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.buyButton.title = NSLocalizedString(@"buy", "Kaufen");
    self.sellButton.title = NSLocalizedString(@"sell", "Verkaufen");

    calculator = [Calculator instance];

    self.buyAssetImage.image = [NSImage imageNamed:self.currentAsset];
    self.buyAsset1Image.image = [NSImage imageNamed:ASSET_KEY(1)];
    self.buyAsset1TotalImage.image = [NSImage imageNamed:ASSET_KEY(1)];

    self.sellAssetImage.image = [NSImage imageNamed:self.currentAsset];
    self.sellAsset1Image.image = [NSImage imageNamed:ASSET_KEY(1)];
    self.sellAsset1TotalImage.image = [NSImage imageNamed:ASSET_KEY(1)];

    // Vorbelegen der Preise
    self.buyAssetPriceField.doubleValue = [calculator ethPriceForAsset:self.currentAsset];
    self.sellAssetPriceField.doubleValue = [calculator ethPriceForAsset:self.currentAsset];

    [self updateBuyAndSellView];
}

/**
 * Update the view after user interaction
 */
- (void)updateBuyAndSellView {
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

    [calculator autoBuy:self.currentAsset amount:amount withRate:rate];
}

/**
 * Sell the crypto with user supplied conditions
 *
 * @param sender
 */
- (IBAction)sellButtonAction:(id)sender {
    double amount = self.sellAssetField.doubleValue;
    double rate = self.sellAssetPriceField.doubleValue;

    [calculator autoSell:self.currentAsset amount:amount withRate:rate];
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
