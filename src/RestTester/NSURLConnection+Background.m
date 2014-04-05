//
//  NSURLConnection+Background.m
//  Ocesa2
//
//  Created by Daniel Dalto on 23/02/12.
//  Copyright (c) 2012 Creative Coefficient Corp. All rights reserved.
//

#import "NSURLConnection+Background.h"

@implementation NSURLConnection (Background)

+ (void)sendSynchronousRequest:(NSURLRequest *)request 
inBackgroundWithCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler {
	
	dispatch_async(dispatch_queue_create
				   ("AsynchRequest", NULL), ^{
					   NSURLResponse *response = nil;
					   NSError *error = nil;
					   NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
					   
					   dispatch_sync(dispatch_get_main_queue(), ^{
						   handler(response,data,error);
					   });
				   });
}

@end
