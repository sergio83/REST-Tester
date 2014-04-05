//
//  FavoriteView.m
//  RestTester
//
//  Created by Sergio Cirasa on 07/07/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import "FavoriteView.h"
#define kRequests @"Requests"

@implementation FavoriteView
@synthesize requestView,delegate;

//-------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)awakeFromNib{
    CALayer *viewLayer = [CALayer layer];
    CGColorRef color = CGColorCreateGenericRGB(0.9, 0.9, 0.9, 1.0);
    [viewLayer setBackgroundColor:color]; //RGB plus Alpha Channel
    CGColorRelease(color);
    [self setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [self setLayer:viewLayer];
    requests = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kRequests];
    for(NSDictionary *dic in array){
        [requests addObject:[Request requestWithDictionary:dic]];
    }
    
    [tableView reloadData];
}
//-------------------------------------------------------------------------------------------------------------------------------------
-(void) synchronize{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[requests count]];
    
    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [requests sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    [aSortDescriptor release];
    
    for(Request *r in requests){
        [array addObject:[r dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:array forKey:kRequests];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableView reloadData];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)toggleFavoritesButtonAction:(id)sender{
    
    NSNotification* notification = [NSNotification notificationWithName:kFavoriteView object:nil];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    
    if(self.frame.origin.y==530){
        requestView.enabled=NO;
        if(delegate)
            [delegate showFavoriteView];
    }else{ 
        requestView.enabled=YES;
        if(delegate)
            [delegate hideFavoriteView];
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.8];
    [[self animator] setFrame:NSMakeRect(self.frame.origin.x, (self.frame.origin.y==530)?151:530, self.frame.size.width, self.frame.size.height)];
    [NSAnimationContext endGrouping];
    
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)deleteFavoriteButtonAction:(id)sender{
    int index = [tableView selectedRow];
    
    if(index>=0){
        [requests removeObjectAtIndex:[tableView selectedRow]];
        [self synchronize];
    }else{
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                            defaultButton:@"Ok" 
                                          alternateButton:nil
                                              otherButton:nil
                                informativeTextWithFormat:@"Please select a favorite."];
        [theAlert runModal];
    }

}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)addFavoriteMethodButtonAction:(id)sender{
    
    NSAlert *theAlert = [NSAlert alertWithMessageText:@"Add Favorite" 
                                        defaultButton:@"Add" 
                                      alternateButton:@"Done"
                                          otherButton:nil
                            informativeTextWithFormat:@"Name:"];

    NSTextField *accessory = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,294,22)];
	[accessory setDrawsBackground:YES];
    [theAlert setAccessoryView:accessory];
    [accessory release];
    
   int rCode = [theAlert runModal];

    if (rCode) {
        Request *r = [requestView currentRequest];
        r.name = [NSString stringWithFormat:accessory.stringValue];
        [requests addObject:r];
        [self synchronize];
        [self toggleFavoritesButtonAction:nil];
    }

}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)saveFavoriteMethodButtonAction:(id)sender{
    
    int index = [tableView selectedRow];
    
    if(index>=0){
    
        Request *aux = [requests objectAtIndex:index];
        Request *r = [requestView currentRequest];
        r.name = aux.name;
        [requests replaceObjectAtIndex:index withObject:r];
        [self synchronize];
        [self toggleFavoritesButtonAction:nil];
        
    }else{
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                            defaultButton:@"Ok" 
                                          alternateButton:nil
                                              otherButton:nil
                                informativeTextWithFormat:@"Please select a favorite."];
        [theAlert runModal];
    }
    
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)loadFavoriteMethodButtonAction:(id)sender{
    int index = [tableView selectedRow];
    
    if(index>=0){
        Request *request = [requests objectAtIndex:index];
        [requestView loadRequest:request];
        [self toggleFavoritesButtonAction:nil];
    }else{
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                            defaultButton:@"Ok" 
                                          alternateButton:nil
                                              otherButton:nil
                                informativeTextWithFormat:@"Please select a favorite."];
        [theAlert runModal];
    }

}
//-------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - NSTableViewDeleate & NSTableViewDataSource 
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    return [requests count];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    Request *r = [requests objectAtIndex:rowIndex];
    return r.name;
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{

}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [requests release];
    [requestView release];
    [super dealloc];
}
//-------------------------------------------------------------------------------------------------------------------------------------
@end
