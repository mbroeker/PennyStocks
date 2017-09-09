//
//  ApplicationsViewController.m
//  iBroker
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
    self.asset1Field.placeholderString = ASSET1_DESC;
    self.asset2Field.placeholderString = ASSET2_DESC;
    self.asset3Field.placeholderString = ASSET3_DESC;
    self.asset4Field.placeholderString = ASSET4_DESC;
    self.asset5Field.placeholderString = ASSET5_DESC;

    self.asset6Field.placeholderString = ASSET6_DESC;
    self.asset7Field.placeholderString = ASSET7_DESC;
    self.asset8Field.placeholderString = ASSET8_DESC;
    self.asset9Field.placeholderString = ASSET9_DESC;
    self.asset10Field.placeholderString = ASSET10_DESC;

    // Images List
    self.asset1ImageButton.image = [NSImage imageNamed:ASSET1];
    self.asset2ImageButton.image = [NSImage imageNamed:ASSET2];
    self.asset3ImageButton.image = [NSImage imageNamed:ASSET3];
    self.asset4ImageButton.image = [NSImage imageNamed:ASSET4];
    self.asset5ImageButton.image = [NSImage imageNamed:ASSET5];

    self.asset6ImageButton.image = [NSImage imageNamed:ASSET6];
    self.asset7ImageButton.image = [NSImage imageNamed:ASSET7];
    self.asset8ImageButton.image = [NSImage imageNamed:ASSET8];
    self.asset9ImageButton.image = [NSImage imageNamed:ASSET9];
    self.asset10ImageButton.image = [NSImage imageNamed:ASSET10];

    [self updateView];
}

/**
 * Aktualisierung des Views vereinheitlicht
 */
- (void)updateView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // aktualisierten Saldo besorgen
    NSMutableDictionary *applications = [[defaults objectForKey:TV_APPLICATIONS] mutableCopy];

    self.asset1Field.stringValue = applications[ASSET1_DESC];
    self.asset2Field.stringValue = applications[ASSET2_DESC];
    self.asset3Field.stringValue = applications[ASSET3_DESC];
    self.asset4Field.stringValue = applications[ASSET4_DESC];
    self.asset5Field.stringValue = applications[ASSET5_DESC];
    self.asset6Field.stringValue = applications[ASSET6_DESC];
    self.asset7Field.stringValue = applications[ASSET7_DESC];
    self.asset8Field.stringValue = applications[ASSET8_DESC];
    self.asset9Field.stringValue = applications[ASSET9_DESC];
    self.asset10Field.stringValue = applications[ASSET10_DESC];
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
    
    applications[ASSET1_DESC] = self.asset1Field.stringValue;
    applications[ASSET2_DESC] = self.asset2Field.stringValue;
    applications[ASSET3_DESC] = self.asset3Field.stringValue;
    applications[ASSET4_DESC] = self.asset4Field.stringValue;
    applications[ASSET5_DESC] = self.asset5Field.stringValue;
    applications[ASSET6_DESC] = self.asset6Field.stringValue;
    applications[ASSET7_DESC] = self.asset7Field.stringValue;
    applications[ASSET8_DESC] = self.asset8Field.stringValue;
    applications[ASSET9_DESC] = self.asset9Field.stringValue;
    applications[ASSET10_DESC] = self.asset10Field.stringValue;

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
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:YES];
    [panel setDirectoryURL:[NSURL URLWithString:@"/Applications/"]];

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
