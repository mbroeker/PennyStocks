//
//  TemplateViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ClickableTextField.h"

/**
 * Main Entry Point for this Application
 *
 * @author      Markus Bröker<broeker.markus@googlemail.com>
 * @copyright   Copyright (C) 2017 4customers UG
 */
@interface TemplateViewController : NSViewController

// Die Menübar selber
@property(strong) IBOutlet NSView *menuBar;

// Definition der Menü-Buttons
@property(weak) IBOutlet NSButton *dashboardButton;
@property(weak) IBOutlet NSButton *homeButton;
@property(weak) IBOutlet NSButton *leftButton;
@property(weak) IBOutlet NSButton *rightButton;
@property(weak) IBOutlet NSButton *walletButton;
@property(weak) IBOutlet NSButton *automatedTradingButton;

@property(weak) IBOutlet NSButton *homepageButton;

// Definition des blauen InfoButtons
@property(weak) IBOutlet NSButton *infoButton;

// Definition der Labels
@property(weak) IBOutlet ClickableTextField *headlineLabel;
@property(weak) IBOutlet NSTextField *percentLabel;
@property(weak) IBOutlet NSTextField *iBrokerLabel;
@property(weak) IBOutlet NSTextField *statusLabel;
@property(weak) IBOutlet NSTextField *infoLabel;

// Definition der Eingabefelder
@property(weak) IBOutlet NSButton *currencyButton;
@property(weak) IBOutlet NSTextField *currencyUnits;

@property(weak) IBOutlet NSButton *cryptoButton;
@property(weak) IBOutlet NSTextField *cryptoUnits;

// Definition der unteren Labels
@property(weak) IBOutlet NSTextField *rateInputLabel;
@property(weak) IBOutlet NSTextField *rateInputCurrencyLabel;
@property(weak) IBOutlet NSTextField *rateOutputLabel;

// Definition der Exchange Rate Labels und Felder
@property(weak) IBOutlet NSTextField *currency1Label;
@property(weak) IBOutlet NSTextField *currency2Label;
@property(weak) IBOutlet NSTextField *currency3Label;
@property(weak) IBOutlet NSTextField *currency4Label;
@property(weak) IBOutlet NSTextField *currency5Label;
@property(weak) IBOutlet NSTextField *currency6Label;
@property(weak) IBOutlet NSTextField *currency7Label;
@property(weak) IBOutlet NSTextField *currency8Label;
@property(weak) IBOutlet NSTextField *currency9Label;
@property(weak) IBOutlet NSTextField *currency10Label;


@property(weak) IBOutlet ClickableTextField *currency1Field;
@property(weak) IBOutlet ClickableTextField *currency2Field;
@property(weak) IBOutlet ClickableTextField *currency3Field;
@property(weak) IBOutlet ClickableTextField *currency4Field;
@property(weak) IBOutlet ClickableTextField *currency5Field;

@property(weak) IBOutlet ClickableTextField *currency6Field;
@property(weak) IBOutlet ClickableTextField *currency7Field;
@property(weak) IBOutlet ClickableTextField *currency8Field;
@property(weak) IBOutlet ClickableTextField *currency9Field;
@property(weak) IBOutlet ClickableTextField *currency10Field;

// Definition der Poloniex Label und Felder
@property(weak) IBOutlet NSTextField *lastLabel;
@property(weak) IBOutlet NSTextField *highLabel;
@property(weak) IBOutlet NSTextField *changeLabel;
@property(weak) IBOutlet NSTextField *high24Label;
@property(weak) IBOutlet NSTextField *low24Label;

@property(weak) IBOutlet NSTextField *lastField;
@property(weak) IBOutlet NSTextField *highField;
@property(weak) IBOutlet NSTextField *changeField;
@property(weak) IBOutlet NSTextField *high24Field;
@property(weak) IBOutlet NSTextField *low24Field;

@property(weak) IBOutlet NSPopUpButton *exchangeSelection;

// Definition der Menüpunkte
@property(weak) IBOutlet NSMenuItem *asset1MenuItem;
@property(weak) IBOutlet NSMenuItem *asset2MenuItem;
@property(weak) IBOutlet NSMenuItem *asset3MenuItem;
@property(weak) IBOutlet NSMenuItem *asset4MenuItem;
@property(weak) IBOutlet NSMenuItem *asset5MenuItem;
@property(weak) IBOutlet NSMenuItem *asset6MenuItem;
@property(weak) IBOutlet NSMenuItem *asset7MenuItem;
@property(weak) IBOutlet NSMenuItem *asset8MenuItem;
@property(weak) IBOutlet NSMenuItem *asset9MenuItem;
@property(weak) IBOutlet NSMenuItem *asset10MenuItem;

@property(weak) IBOutlet NSMenuItem *fiatAsset1MenuItem;
@property(weak) IBOutlet NSMenuItem *fiatAsset2MenuItem;

/**
 *
 * @param sender
 */
- (IBAction)homeAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)leftAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)rightAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)walletAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)automatedTradingAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)homepageAction:(id)sender;

/**
 *
 * @param sender
 */
- (IBAction)dashboardAction:(id)sender;

/**
 * Info-Icon Action
 *
 * @param sender
 */
- (IBAction)infoAction:(id)sender;

/**
 * Währungssymbole
 *
 * @param sender
 */
- (IBAction)cryptoAction:(id)sender;

/**
 * Rate Action
 *
 * @param sender
 */
- (IBAction)rateInputAction:(id)sender;

/**
 * Getter for applications
 *
 * @return
 */
- (NSDictionary *)applications;

/**
 * Getter for traders
 *
 * @return
 */
- (NSDictionary *)traders;

/**
 * Getter for images
 *
 * @return
 */
- (NSDictionary *)images;

/**
 * Getter for homeURL
 *
 * @return
 */
- (NSString *)homeURL;

/**
 *
 */
- (void)updateOverview;

/**
 *
 * @param label
 */
- (void)updateTemplateView:(NSString *)label;

/**
 *
 * @param withTrading
 */
- (void)updateCurrentView:(BOOL)withTrading;

/**
 *
 */
- (void)updateBalanceAndRatings;

/**
 *
 */
- (void)initializeWithDefaults;

/**
 *
 */
- (void)updateAssistant;

/**
 *
 */
- (void)resetColors;

@end
