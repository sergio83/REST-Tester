//
//  TabViewController.m
//  RestTester
//
//  Created by Sergio Cirasa on 26/06/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import "TabViewController.h"

@implementation TabViewController

//------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)awakeFromNib{
    self.delegate=self;
    CALayer *viewLayer = [CALayer layer];
    CGColorRef color = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0.2);
    [viewLayer setBackgroundColor:color]; //RGB plus Alpha Channel
    CGColorRelease(color);
    [loadingView setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [loadingView setLayer:viewLayer];
    requestView.delegate=self;
    favoriteView.requestView=requestView;
    favoriteView.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleFavoriteView:) name:kFavoriteView object:nil];
}
//------------------------------------------------------------------------------------------------------
- (void)toggleFavoriteView:(NSNotification*) notification{
    static BOOL showFavorites=NO;
    [progress setHidden:!showFavorites];
    [loadingView setHidden:showFavorites];
    
    [favoriteView setHidden:YES];
    [favoriteView setHidden:NO];    
    showFavorites=!showFavorites;
}
//------------------------------------------------------------------------------------------------------
- (void) willSendRequest:(NSURLRequest *)request{
    [loadingView setHidden:NO];
    [progress startAnimation:nil];
    requestView.enabled=NO;
    responseView.request = [requestView currentRequest];
}
//------------------------------------------------------------------------------------------------------
- (void)connectionDidReceiveResponse:(NSURLResponse *)response{
    [loadingView setHidden:YES];
    [progress stopAnimation:nil];
    requestView.enabled=YES;
    if(response==nil)
        return;
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *headers = httpResponse.allHeaderFields;

    responseView.responseString = requestView.stringDataResponse;
    responseView.responseHeaders = headers;
    responseView.jsonString = requestView.stringDataResponse;
    [self selectTabViewItemAtIndex:1];
    
}
//------------------------------------------------------------------------------------------------------
- (void)showFavoriteView{
     //[loadingView setHidden:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)hideFavoriteView{
  //  [loadingView setHidden:YES];
}
//------------------------------------------------------------------------------------------------------
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
    if([tabViewItem.identifier isEqual:@"0"])
        [favoriteView setHidden:NO];
    else [favoriteView setHidden:YES];    
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFavoriteView object:nil];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end
