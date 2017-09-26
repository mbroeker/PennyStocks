//
// Created by Markus Bröker on 26.09.17.
// Copyright (c) 2017 Markus Bröker. All rights reserved.
//

#import "RestrictedClickableTextField.h"
#import "CalculatorConstants.h"

@implementation RestrictedClickableTextField

/**
 *
 * @param theEvent
 */
- (void)mouseDown:(NSEvent *)theEvent {
    if ([self.stringValue isEqualToString:DASHBOARD] || [self.stringValue isEqualToString:ASSET1]) {
        return;
    }

    [self sendAction:[self action] to:[self target]];
}

@end