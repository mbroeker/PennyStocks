//
//  Algorithm.h
//  iBroker
//
//  Created by Markus Bröker on 12.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Algorithm : NSObject
+ (NSArray*)gaussAlgorithm:(NSArray*)matrix;
+ (void)gaussAlgorithm:(double**)A withEquations:(int)equations;
@end
