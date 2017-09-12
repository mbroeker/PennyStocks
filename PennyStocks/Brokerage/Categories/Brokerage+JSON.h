//
//  Brokerage+JSON.h
//  PennyStocks
//
//  Created by Markus Bröker on 12.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "Brokerage.h"

@interface Brokerage (JSON)
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL;
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL withPayload:(NSDictionary*)payload;
+ (NSDictionary*)jsonRequest:(NSString*)jsonURL withPayload:(NSDictionary*)payload andHeader:(NSDictionary*)header;
+ (NSString*) urlStringEncode:(NSString*)string;
+ (NSString*)urlEncode:(NSDictionary*)payload;
@end
