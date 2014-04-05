//
//  AppDelegate.m
//  RestTester
//
//  Created by Sergio Cirasa on 23/06/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import "AppDelegate.h"
#import "Request.h"
#import "Header.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

@end
