//
//  BittrexViewController.h
//  iBroker
//
//  Created by Markus Bröker on 26.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BittrexViewController : NSViewController

@property (strong) IBOutlet NSTextField *apikeyField;
@property (strong) IBOutlet NSSecureTextField *secretField;

@property (strong) IBOutlet NSTextField *legalNoticeLabel;
@property (strong) IBOutlet NSButton *keyEraseButton;
- (IBAction)keyEraseAction:(id)sender;

@property (strong) IBOutlet NSButton *saveButton;

- (IBAction)saveAction:(id)sender;

@property (strong) IBOutlet NSButton *standardExchangeButton;
- (IBAction)standardExchangeAction:(id)sender;
@end
