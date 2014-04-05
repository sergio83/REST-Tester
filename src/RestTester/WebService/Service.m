//
//  Service.m
//  Police
//
//  Created by Sergio on 26/08/11.
//  Copyright 2011 Creative Coefficient. All rights reserved.
//


#import "Service.h"

@implementation Service
@synthesize responseStatusCode;
@synthesize result;

- (id)initWithRequestMethod:(NSString*)requestMethod url:(NSString*)url {
    self = [super init];    
	if (self) {
		request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
		request.delegate = self;
		[request setRequestMethod:requestMethod];
        
		[request setPersistentConnectionTimeoutSeconds:5];
	}
	return self;
}

- (id)initWithRequestMethod:(NSString*)requestMethod username:(NSString*)username password:(NSString*)password url:(NSString*)url {
	self = [self initWithRequestMethod:requestMethod url:url];
	request.username = username;
	request.password = password;
	[request setPersistentConnectionTimeoutSeconds:5];
	return self;
}

- (id)initForPostWithUsername:(NSString*)username password:(NSString*)password url:(NSString*)url {
    self = [super init];    
	if (self) {
		request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
		request.delegate = self;
		request.username = username;
		request.password = password;
		[request setPersistentConnectionTimeoutSeconds:5];
	}
	return self;
}

- (id)initForPostUrl:(NSString*)url{
    self = [super init];    
	if (self) {
		request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
		request.delegate = self;
		[request setRequestMethod:@"POST"];        
		[request setPersistentConnectionTimeoutSeconds:5];
	}
	return self;
}

- (void)start {
	[request startAsynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)_request {
    //	NSLog(@"ERROR:%@",[[_request error] description]);
	[[LoaderView sharedLoader] hide];
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil) message:NSLocalizedString(@"The application could not connect to web services. Please try again", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)dealloc {
	[request release];
	[super dealloc];
}

@end