//
//  Helper.h
//  PennyStocks
//
//  Created by Markus Bröker on 06.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Helper : NSObject
+ (NSString*) double2German:(double) value min:(NSUInteger) min max:(NSUInteger) max;
+ (NSString*) double2GermanPercent:(double) value fractions:(NSUInteger) fractions;
+ (NSModalResponse)messageText:(NSString*) message info:(NSString*) info;
+ (void)relaunchAfterDelay:(float)seconds;
@end
