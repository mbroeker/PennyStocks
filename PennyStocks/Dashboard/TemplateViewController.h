//
//  TemplateViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 04.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ClickableTextField.h"

@interface TemplateViewController : NSViewController

// Die Menübar selber
@property(strong) IBOutlet NSView *menuBar;

// Definition der Menü-Buttons
@property(strong) IBOutlet NSButton *dashboardButton;
@property(strong) IBOutlet NSButton *homeButton;
@property(strong) IBOutlet NSButton *leftButton;
@property(strong) IBOutlet NSButton *rightButton;
@property(strong) IBOutlet NSButton *walletButton;
@property(strong) IBOutlet NSButton *automatedTradingButton;

@property(strong) IBOutlet NSButton *homepageButton;

// Definition des blauen InfoButtons
@property(strong) IBOutlet NSButton *infoButton;

// Definition der Labels
@property(strong) IBOutlet ClickableTextField *headlineLabel;
@property(strong) IBOutlet NSTextField *percentLabel;
@property(strong) IBOutlet NSTextField *iBrokerLabel;
@property(strong) IBOutlet NSTextField *statusLabel;
@property(strong) IBOutlet NSTextField *infoLabel;

// Definition der Eingabefelder
@property(strong) IBOutlet NSButton *currencyButton;
@property(strong) IBOutlet NSTextField *currencyUnits;

@property(strong) IBOutlet NSButton *cryptoButton;
@property(strong) IBOutlet NSTextField *cryptoUnits;

// Definition der unteren Labels
@property(strong) IBOutlet NSTextField *rateInputLabel;
@property(strong) IBOutlet NSTextField *rateInputCurrencyLabel;
@property(strong) IBOutlet NSTextField *rateOutputLabel;

// Definition der Exchange Rate Labels und Felder
@property(strong) IBOutlet NSTextField *currency1Label;
@property(strong) IBOutlet NSTextField *currency2Label;
@property(strong) IBOutlet NSTextField *currency3Label;
@property(strong) IBOutlet NSTextField *currency4Label;
@property(strong) IBOutlet NSTextField *currency5Label;
@property(strong) IBOutlet NSTextField *currency6Label;
@property(strong) IBOutlet NSTextField *currency7Label;
@property(strong) IBOutlet NSTextField *currency8Label;
@property(strong) IBOutlet NSTextField *currency9Label;
@property(strong) IBOutlet NSTextField *currency10Label;


@property(strong) IBOutlet ClickableTextField *currency1Field;
@property(strong) IBOutlet ClickableTextField *currency2Field;
@property(strong) IBOutlet ClickableTextField *currency3Field;
@property(strong) IBOutlet ClickableTextField *currency4Field;
@property(strong) IBOutlet ClickableTextField *currency5Field;

@property(strong) IBOutlet ClickableTextField *currency6Field;
@property(strong) IBOutlet ClickableTextField *currency7Field;
@property(strong) IBOutlet ClickableTextField *currency8Field;
@property(strong) IBOutlet ClickableTextField *currency9Field;
@property(strong) IBOutlet ClickableTextField *currency10Field;

// Definition der Poloniex Label und Felder
@property(strong) IBOutlet NSTextField *lastLabel;
@property(strong) IBOutlet NSTextField *highLabel;
@property(strong) IBOutlet NSTextField *changeLabel;
@property(strong) IBOutlet NSTextField *high24Label;
@property(strong) IBOutlet NSTextField *low24Label;

@property(strong) IBOutlet NSTextField *lastField;
@property(strong) IBOutlet NSTextField *highField;
@property(strong) IBOutlet NSTextField *changeField;
@property(strong) IBOutlet NSTextField *high24Field;
@property(strong) IBOutlet NSTextField *low24Field;

@property(strong) IBOutlet NSPopUpButton *exchangeSelection;

// Definition der Menüpunkte
@property(strong) IBOutlet NSMenuItem *asset1MenuItem;
@property(strong) IBOutlet NSMenuItem *asset2MenuItem;
@property(strong) IBOutlet NSMenuItem *asset3MenuItem;
@property(strong) IBOutlet NSMenuItem *asset4MenuItem;
@property(strong) IBOutlet NSMenuItem *asset5MenuItem;
@property(strong) IBOutlet NSMenuItem *asset6MenuItem;
@property(strong) IBOutlet NSMenuItem *asset7MenuItem;
@property(strong) IBOutlet NSMenuItem *asset8MenuItem;
@property(strong) IBOutlet NSMenuItem *asset9MenuItem;
@property(strong) IBOutlet NSMenuItem *asset10MenuItem;

@property(strong) IBOutlet NSMenuItem *fiatAsset1MenuItem;
@property(strong) IBOutlet NSMenuItem *fiatAsset2MenuItem;

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
