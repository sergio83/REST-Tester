//
//  TabViewController.h
//  RestTester
//
//  Created by Sergio Cirasa on 26/06/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RequestView.h"
#import "ResponseView.h"
#import "FavoriteView.h"

@interface TabViewController : NSTabView<WebServiceDelegate,NSTabViewDelegate,FavoriteViewDelegate>{

    IBOutlet RequestView *requestView;
    IBOutlet ResponseView *responseView;
    IBOutlet NSView *loadingView;
    IBOutlet NSProgressIndicator *progress;
    IBOutlet FavoriteView *favoriteView;
}

@end
