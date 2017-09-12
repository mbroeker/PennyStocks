//
//  SaldoViewController.h
//  PennyStocks
//
//  Created by Markus Bröker on 21.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SaldoViewController : NSViewController

// Properties List
@property (strong) IBOutlet NSTextField *asset1Field;
@property (strong) IBOutlet NSTextField *asset2Field;
@property (strong) IBOutlet NSTextField *asset3Field;
@property (strong) IBOutlet NSTextField *asset4Field;
@property (strong) IBOutlet NSTextField *asset5Field;
@property (strong) IBOutlet NSTextField *asset6Field;
@property (strong) IBOutlet NSTextField *asset7Field;
@property (strong) IBOutlet NSTextField *asset8Field;
@property (strong) IBOutlet NSTextField *asset9Field;
@property (strong) IBOutlet NSTextField *asset10Field;

// Images List
@property (strong) IBOutlet NSImageView *asset1ImageView;
@property (strong) IBOutlet NSImageView *asset2ImageView;
@property (strong) IBOutlet NSImageView *asset3ImageView;
@property (strong) IBOutlet NSImageView *asset4ImageView;
@property (strong) IBOutlet NSImageView *asset5ImageView;
@property (strong) IBOutlet NSImageView *asset6ImageView;
@property (strong) IBOutlet NSImageView *asset7ImageView;
@property (strong) IBOutlet NSImageView *asset8ImageView;
@property (strong) IBOutlet NSImageView *asset9ImageView;
@property (strong) IBOutlet NSImageView *asset10ImageView;

// Action Handler
- (IBAction)saveAction:(id)sender;

// Interne Methode zum Aktualisieren des Views
- (void)updateView;

@end
