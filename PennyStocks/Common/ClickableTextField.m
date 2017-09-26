//
// Created by Markus Bröker on 26.09.17.
// Copyright (c) 2017 Markus Bröker. All rights reserved.
//

#import "ClickableTextField.h"


@implementation ClickableTextField

/**
 *
 * @param theEvent
 */
- (void)mouseDown:(NSEvent *)theEvent {
    [self sendAction:[self action] to:[self target]];
}

@end