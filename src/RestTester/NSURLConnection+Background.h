//
//  NSURLConnection+Background.h
//  Ocesa2
//
//  Created by Daniel Dalto on 23/02/12.
//  Copyright (c) 2012 Creative Coefficient Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection (Background)

+ (void)sendSynchronousRequest:(NSURLRequest *)request inBackgroundWithCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

@end
