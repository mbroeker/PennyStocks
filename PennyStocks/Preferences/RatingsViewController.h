//
//  RatingsViewController.h
//  iBroker
//
//  Created by Markus Bröker on 26.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RatingsViewController : NSViewController

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

// Action Handler
- (IBAction)saveAction:(id)sender;

// Interne Methode zum Aktualisieren des Views
- (void)updateView;

@end
