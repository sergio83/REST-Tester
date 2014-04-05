//
//  InternetInfo.m
//  LibreriaComunicaciones
//
//  Created by developer on 17/09/10.
//  Copyright 2010 Ryan Partnership. All rights reserved.
//

#import "CInternetInfo.h"
#import "Reachability.h"

@implementation CInternetInfo

+ (eNetworkStatus)typeOfInternetConnection {
	Reachability *reachibility = [Reachability reachabilityWithHostName:@"google.com.ar"];
	return [reachibility currentReachabilityStatus];
}

+ (BOOL)hasInternetConnection {    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NetworkStatus internetStatus = [CInternetInfo typeOfInternetConnection];
	BOOL est = ((internetStatus == ReachableViaWiFi) || (internetStatus == ReachableViaWWAN));
    [pool drain];
    return est;
}

+ (BOOL)hasInternetConnectionWithMessage:(id)delegate  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	if(!([CInternetInfo hasInternetConnection])){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This feature requires Internet service. No Internet service is detected. Please try again when service is available."
														message:@""
													   delegate:nil 
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		alert.tag=kERROR_INTERNET_CONNECTION;
		alert.delegate=delegate;
		[alert show];	
		[alert release];
        [pool drain];
		return NO;
	}
    
    [pool drain];	
	return YES;
}
@end
