//
//  BuyAndSellViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 22.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * BuyAndSell Segue Overlay
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface BuyAndSellViewController : NSViewController
@property(weak) IBOutlet NSButton *dismissButton;
@property(weak) NSString *currentAsset;

@property(weak) IBOutlet NSTextField *buyAssetField;
@property(weak) IBOutlet NSTextField *buyAssetPriceField;
@property(weak) IBOutlet NSTextField *buyAsset1TotalField;

@property(weak) IBOutlet NSTextField *sellAssetField;
@property(weak) IBOutlet NSTextField *sellAssetPriceField;
@property(weak) IBOutlet NSTextField *sellAsset1TotalField;

@property(weak) IBOutlet NSButton *buyAssetImage;
@property(weak) IBOutlet NSButton *buyAsset1Image;
@property(weak) IBOutlet NSButton *buyAsset1TotalImage;

@property(weak) IBOutlet NSButton *sellAssetImage;
@property(weak) IBOutlet NSButton *sellAsset1Image;
@property(weak) IBOutlet NSButton *sellAsset1TotalImage;

@property(weak) IBOutlet NSButton *buyButton;
@property(weak) IBOutlet NSButton *sellButton;

/**
 *
 * @param sender
 */
- (IBAction)dismissActionClicked:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)buyButtonAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)sellButtonAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)buyAssetAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)buyAsset1Action:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)buyAsset1TotalAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)sellAssetAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)sellAsset1Action:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)sellAsset1TotalAction:(id)sender;

@end
