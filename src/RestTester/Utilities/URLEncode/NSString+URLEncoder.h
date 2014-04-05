//
//  NSString+URLEncoder.h
//  Ribbit Mobile
//
//  Created by Daniel Dalto on 14/01/10.
//  Copyright 2010 Ryan Partnership All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncoder)

+ (NSString*)URLEncode:(NSString*)s;
+ (NSString*) myURLEncode:(NSString*)s;

@end
