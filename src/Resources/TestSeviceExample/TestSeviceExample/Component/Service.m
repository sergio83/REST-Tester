//
//  Service.m
//
//  Created by Sergio on 26/08/11.
//  Copyright 2011 Creative Coefficient. All rights reserved.
//


#import "Service.h"

@implementation Service
@synthesize responseStatusCode;
@synthesize response,username,password;

- (id)initWithRequestMethod:(NSString*)requestMethod url:(NSString*)url {
    self = [super init];    
	if (self) {
		request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
		request.delegate = self;
        request.username=nil;
        request.password=nil;
		[request setRequestMethod:requestMethod];
		[request setPersistentConnectionTimeoutSeconds:5];
	}
	return self;
}
//-------------------------------------------------------------------------------------------------------------
- (id)initWithRequestMethod:(NSString*)requestMethod username:(NSString*)_username password:(NSString*)_password url:(NSString*)url {
	self = [self initWithRequestMethod:requestMethod url:url];
	self.username = _username;
	self.password = _password;
	[request setPersistentConnectionTimeoutSeconds:5];
	return self;
}
//-------------------------------------------------------------------------------------------------------------
- (id)initForPostWithUsername:(NSString*)_username password:(NSString*)_password url:(NSString*)url {
    self = [super init];    
	if (self) {
		request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
		request.delegate = self;
		self.username = _username;
		self.password = _password;
		[request setPersistentConnectionTimeoutSeconds:5];
	}
	return self;
}
//-------------------------------------------------------------------------------------------------------------
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
//-------------------------------------------------------------------------------------------------------------
- (void)start {
    request.username=self.username;
    request.password=self.password;
	[request startAsynchronous];
}
//-------------------------------------------------------------------------------------------------------------
- (void)requestFailed:(ASIHTTPRequest *)_request {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil) message:NSLocalizedString(@"The application could not connect to web services. Please try again", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
//-------------------------------------------------------------------------------------------------------------
- (id)response
{
    if(!request)
        return nil;
    
    if([request error]){
        return [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
    }else{
        NSString *data = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
        id result = [data objectFromJSONString];
        if(result)
            return result;
            
            return data;
    }
}
//-------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [username release];
    [password release];
	[request release];
	[super dealloc];
}

@end