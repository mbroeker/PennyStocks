//
// Created by Markus Bröker on 26.09.17.
// Copyright (c) 2017 Markus Bröker. All rights reserved.
//

#import "RestrictedClickableTextField.h"
#import "Calculator.h"

@implementation RestrictedClickableTextField

/**
 * onHover effect for restricted and clickable TextFields
 */
- (void)viewWillDraw {
    if ([self.stringValue isEqualToString:DASHBOARD] || [self.stringValue isEqualToString:ASSET_DESC(1)]) {
        return;
    }

    NSCursor *cursor = [NSCursor openHandCursor];
    [self addCursorRect:[self bounds] cursor:cursor];
}

/**
 *
 * @param theEvent
 */
- (void)mouseDown:(NSEvent *)theEvent {
    if ([self.stringValue isEqualToString:DASHBOARD] || [self.stringValue isEqualToString:ASSET_DESC(1)]) {
        return;
    }

    [self sendAction:[self action] to:[self target]];
}
@end