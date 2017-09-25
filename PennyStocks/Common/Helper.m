//
//  Helper.m
//  PennyStocks
//
//  Created by Markus Bröker on 06.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Helper.h"

@implementation Helper

/**
 * Umwandlung von double Werten in das Format des jeweiligen Landes(Deutschland)
 *
 * @param value
 * @param min
 * @param max
 * @return NSString*
 */
+ (NSString *)double2German:(double)value min:(NSUInteger)min max:(NSUInteger)max {

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];

    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:min];
    [formatter setMaximumFractionDigits:max];

    return [formatter stringFromNumber:@(value)];
}

/**
 * Umwandlung von double Werten in das Prozent-Format des jeweiligen Landes(Deutschland)
 *
 * @param value
 * @param fractions
 * @return NSString*
 */
+ (NSString *)double2GermanPercent:(double)value fractions:(NSUInteger)fractions {

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];

    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:fractions];

    NSString *signs = @"";

    if (value > 0.0) {
        signs = @"+";
    } else if (value == 0.0) {
        return @"+/- 0";
    }

    return [NSString stringWithFormat:@"%@%@ %%", signs, [formatter stringFromNumber:@(value)]];
}

/**
 * Anzeige eines modalen Dialogs
 *
 * @param message
 * @param info
 * @return NSModalResponse*
 *
 */
+ (NSModalResponse)messageText:(NSString *)message info:(NSString *)info {

    NSAlert *msg = [[NSAlert alloc] init];

    [msg setAlertStyle:NSInformationalAlertStyle];
    [msg addButtonWithTitle:NSLocalizedString(@"acknowledge", @"Bestätigen"])];
    [msg addButtonWithTitle:NSLocalizedString(@"abort", @"Verwerfen"])];

    msg.messageText = message;
    msg.informativeText = info;

    return [msg runModal];

}

/**
 * Restart App
 *
 * @param seconds
 */
+ (void)relaunchAfterDelay:(float)seconds {
    NSTask *task = [[NSTask alloc] init];
    NSMutableArray *args = [NSMutableArray array];
    [args addObject:@"-c"];
    [args addObject:[NSString stringWithFormat:@"sleep %f; open \"%@\"", seconds, [[NSBundle mainBundle] bundlePath]]];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:args];
    [task launch];

    [NSApp terminate:nil];
}

@end
