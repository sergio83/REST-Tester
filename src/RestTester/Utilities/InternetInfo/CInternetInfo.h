//
//  InternetInfo.h
//  LibreriaComunicaciones
//
//  Created by developer on 17/09/10.
//  Copyright 2010 Cubika. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kERROR_INTERNET_CONNECTION 95

/*!
 @enum NetworkStatus
 @discussion Returns the type of internet connection: None, WiFi, WWan
 */
typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} eNetworkStatus;

/*!
 @class InternetInfo
 @discussion This class handles all info about the connection of the device.
 */
@interface CInternetInfo : NSObject {

}

/*!
 @discussion Returns the type of connection of the device: NotReachable if it has no internet, ReachableViaWiFi if it connects via WiFi, ReachableViaWWan if it connects via WWan
 */
+ (eNetworkStatus)typeOfInternetConnection;

/*!
 @discussion returns YES if it has internet connection or NO if it has not
 */
+ (BOOL)hasInternetConnection;

+ (BOOL)hasInternetConnectionWithMessage:(id)delegate;
@end
