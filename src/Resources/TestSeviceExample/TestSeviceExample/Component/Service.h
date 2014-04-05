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
#import "WebServiceConfig.h"

@class ASIFormDataRequest;

@interface Service : NSObject {
	NSMutableString* mutableString;
	ASIFormDataRequest* request;
  	int responseStatusCode;
  	id response;
    NSString *username;
    NSString *password;
}

@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,readonly) int responseStatusCode;
@property (nonatomic, readonly) id response;

- (id)initWithRequestMethod:(NSString*)requestMethod url:(NSString*)url;

- (id)initWithRequestMethod:(NSString*)requestMethod username:(NSString*)username password:(NSString*)password url:(NSString*)url;

- (id)initForPostWithUsername:(NSString*)username password:(NSString*)password url:(NSString*)url;

- (id)initForPostUrl:(NSString*)url;

- (void)start;

@end
