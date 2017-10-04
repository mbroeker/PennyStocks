//
//  ApplicationsViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 15.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "ApplicationsViewController.h"
#import "Calculator.h"

@implementation ApplicationsViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Properties List
    self.asset1Field.placeholderString = ASSET_DESC(1);
    self.asset2Field.placeholderString = ASSET_DESC(2);
    self.asset3Field.placeholderString = ASSET_DESC(3);
    self.asset4Field.placeholderString = ASSET_DESC(4);
    self.asset5Field.placeholderString = ASSET_DESC(5);

    self.asset6Field.placeholderString = ASSET_DESC(6);
    self.asset7Field.placeholderString = ASSET_DESC(7);
    self.asset8Field.placeholderString = ASSET_DESC(8);
    self.asset9Field.placeholderString = ASSET_DESC(9);
    self.asset10Field.placeholderString = ASSET_DESC(10);

    // Images List
    self.asset1ImageButton.image = [NSImage imageNamed:ASSET_KEY(1)];
    self.asset2ImageButton.image = [NSImage imageNamed:ASSET_KEY(2)];
    self.asset3ImageButton.image = [NSImage imageNamed:ASSET_KEY(3)];
    self.asset4ImageButton.image = [NSImage imageNamed:ASSET_KEY(4)];
    self.asset5ImageButton.image = [NSImage imageNamed:ASSET_KEY(5)];

    self.asset6ImageButton.image = [NSImage imageNamed:ASSET_KEY(6)];
    self.asset7ImageButton.image = [NSImage imageNamed:ASSET_KEY(7)];
    self.asset8ImageButton.image = [NSImage imageNamed:ASSET_KEY(8)];
    self.asset9ImageButton.image = [NSImage imageNamed:ASSET_KEY(9)];
    self.asset10ImageButton.image = [NSImage imageNamed:ASSET_KEY(10)];

    [self updateView];
}

/**
 * Aktualisierung des Views vereinheitlicht
 */
- (void)updateView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // aktualisierten Saldo besorgen
    NSMutableDictionary *applications = [[defaults objectForKey:TV_APPLICATIONS] mutableCopy];

    self.asset1Field.stringValue = applications[ASSET_DESC(1)];
    self.asset2Field.stringValue = applications[ASSET_DESC(2)];
    self.asset3Field.stringValue = applications[ASSET_DESC(3)];
    self.asset4Field.stringValue = applications[ASSET_DESC(4)];
    self.asset5Field.stringValue = applications[ASSET_DESC(5)];
    self.asset6Field.stringValue = applications[ASSET_DESC(6)];
    self.asset7Field.stringValue = applications[ASSET_DESC(7)];
    self.asset8Field.stringValue = applications[ASSET_DESC(8)];
    self.asset9Field.stringValue = applications[ASSET_DESC(9)];
    self.asset10Field.stringValue = applications[ASSET_DESC(10)];
}

/**
 * Speichern der Adressen des Nutzers
 *
 * @param sender
 */
- (IBAction)saveAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // aktualisierten Saldo besorgen
    NSMutableDictionary *applications = [[defaults objectForKey:TV_APPLICATIONS] mutableCopy];

    applications[ASSET_DESC(1)] = self.asset1Field.stringValue;
    applications[ASSET_DESC(2)] = self.asset2Field.stringValue;
    applications[ASSET_DESC(3)] = self.asset3Field.stringValue;
    applications[ASSET_DESC(4)] = self.asset4Field.stringValue;
    applications[ASSET_DESC(5)] = self.asset5Field.stringValue;
    applications[ASSET_DESC(6)] = self.asset6Field.stringValue;
    applications[ASSET_DESC(7)] = self.asset7Field.stringValue;
    applications[ASSET_DESC(8)] = self.asset8Field.stringValue;
    applications[ASSET_DESC(9)] = self.asset9Field.stringValue;
    applications[ASSET_DESC(10)] = self.asset10Field.stringValue;

    [defaults setObject:applications forKey:TV_APPLICATIONS];
    [defaults synchronize];

    // Gepeicherte Daten neu einlesen...
    [self updateView];
}

/**
 * File Chooser für Applications
 *
 */
- (NSURL *)pickApplication {
    NSArray *possibleURLs = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSLocalDomainMask];
    NSURL *applicationsFolder;

    if ([possibleURLs count] > 0) {
        applicationsFolder = possibleURLs[0];
    } else {
        // Fallback for things that might happen...
        applicationsFolder = [[NSURL alloc] initWithString:@"/Applications"];
    }

    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:YES];
    [panel setDirectoryURL:applicationsFolder];

    NSInteger clicked = [panel runModal];

    if (clicked == NSFileHandlingPanelOKButton) {
        return [panel URL];
    }

    return nil;
}

/**
 * Action Handler für Asset1
 */
- (IBAction)asset1ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset1Field.stringValue = url.path;
    }
}

/**
 * Action Handler für Asset2
 */
- (IBAction)asset2ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset2Field.stringValue = url.path;
    }
}

/**
 * Action Handler für Asset3
 */
- (IBAction)asset3ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset3Field.stringValue = url.path;
    }

}

/**
 * Action Handler für Asset4
 */
- (IBAction)asset4ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset4Field.stringValue = url.path;
    }

}

/**
 * Action Handler für Asset5
 */
- (IBAction)asset5ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset5Field.stringValue = url.path;
    }

}

/**
 * Action Handler für Asset6
 */
- (IBAction)asset6ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset6Field.stringValue = url.path;
    }
}

/**
 * Action Handler für Asset7
 */
- (IBAction)asset7ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset7Field.stringValue = url.path;
    }
}

/**
 * Action Handler für Asset8
 */
- (IBAction)asset8ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset8Field.stringValue = url.path;
    }

}

/**
 * Action Handler für Asset9
 */
- (IBAction)asset9ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset9Field.stringValue = url.path;
    }

}

/**
 * Action Handler für Asset10
 */
- (IBAction)asset10ClickedAction:(id)sender {
    NSURL *url = [self pickApplication];

    if (url != nil) {
        self.asset10Field.stringValue = url.path;
    }

}

@end
