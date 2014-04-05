//
//  FavoriteView.h
//  RestTester
//
//  Created by Sergio Cirasa on 07/07/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RequestView.h"
#define kFavoriteView @"FAvoriteView"

@protocol FavoriteViewDelegate <NSObject>
- (void)showFavoriteView;
- (void)hideFavoriteView;
@end

@interface FavoriteView : NSView<NSTableViewDataSource,NSURLConnectionDelegate,NSAlertDelegate>
{
    IBOutlet NSTableView *tableView;
    RequestView *requestView;
    NSMutableArray *requests;
    id<FavoriteViewDelegate> delegate;
}

@property(nonatomic,retain) RequestView *requestView;
@property(nonatomic,assign)id<FavoriteViewDelegate> delegate;

- (IBAction)deleteFavoriteButtonAction:(id)sender;
- (IBAction)addFavoriteMethodButtonAction:(id)sender;
- (IBAction)loadFavoriteMethodButtonAction:(id)sender;
- (IBAction)saveFavoriteMethodButtonAction:(id)sender;

@end
