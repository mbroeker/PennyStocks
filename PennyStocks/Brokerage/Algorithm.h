//
//  Algorithm.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Algorithm : NSObject

/**
 *
 * @param matrix
 * @return
 */
+ (NSArray *)gaussAlgorithm:(NSArray *)matrix;

/**
 *
 * @param A
 * @param equations
 */
+ (void)gaussAlgorithm:(double **)A withEquations:(int)equations;

/**
 *
 * @param value
 * @param accuracy
 * @return
 */
+ (double)nearest:(double)value withAccuracy:(double)accuracy;

@end
