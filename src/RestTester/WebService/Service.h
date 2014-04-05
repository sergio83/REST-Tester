//
//  Service.h
//  Police
//
//  Created by Sergio on 26/08/11.
//  Copyright 2011 Creative Coefficient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "PathService.h"


@class ASIFormDataRequest;

@interface Service : NSObject {
	NSMutableString* mutableString;
	ASIFormDataRequest* request;
  	int responseStatusCode;
  	NSObject *result;
}

@property (nonatomic,readonly) int responseStatusCode;
@property (nonatomic, readonly) NSObject *result;

- (id)initWithRequestMethod:(NSString*)requestMethod url:(NSString*)url;

- (id)initWithRequestMethod:(NSString*)requestMethod username:(NSString*)username password:(NSString*)password url:(NSString*)url;

- (id)initForPostWithUsername:(NSString*)username password:(NSString*)password url:(NSString*)url;

- (id)initForPostUrl:(NSString*)url;

- (void)start;

@end
