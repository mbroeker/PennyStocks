//
//  BuyAndSellViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 22.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BuyAndSellViewController : NSViewController
@property (strong) IBOutlet NSButton *dismissButton;

- (IBAction)dismissActionClicked:(id)sender;

@property (strong) IBOutlet NSTextField *buyAssetField;
@property (strong) IBOutlet NSTextField *buyAssetPriceField;
@property (strong) IBOutlet NSTextField *buyAsset1TotalField;

@property (strong) IBOutlet NSTextField *sellAssetField;
@property (strong) IBOutlet NSTextField *sellAssetPriceField;
@property (strong) IBOutlet NSTextField *sellAsset1TotalField;

@property (strong) IBOutlet NSButton *buyAssetImage;
@property (strong) IBOutlet NSButton *buyAsset1Image;
@property (strong) IBOutlet NSButton *buyAsset1TotalImage;

@property (strong) IBOutlet NSButton *sellAssetImage;
@property (strong) IBOutlet NSButton *sellAsset1Image;
@property (strong) IBOutlet NSButton *sellAsset1TotalImage;

@property (strong) IBOutlet NSButton *buyButton;
@property (strong) IBOutlet NSButton *sellButton;

- (IBAction)buyButtonAction:(id)sender;
- (IBAction)sellButtonAction:(id)sender;

- (IBAction)buyAssetAction:(id)sender;
- (IBAction)buyAsset1Action:(id)sender;
- (IBAction)buyAsset1TotalAction:(id)sender;

- (IBAction)sellAssetAction:(id)sender;
- (IBAction)sellAsset1Action:(id)sender;
- (IBAction)sellAsset1TotalAction:(id)sender;

@end
