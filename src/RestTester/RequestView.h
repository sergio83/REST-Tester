//
//  RequestView.h
//  RestTester
//
//  Created by Sergio Cirasa on 25/06/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Request.h"
#import "Header.h"

@protocol WebServiceDelegate <NSObject>
@optional
- (void) willSendRequest:(NSURLRequest *)request;
- (void)connectionDidReceiveResponse:(NSURLResponse *)response;
@end

@interface RequestView : NSView<NSTabViewDelegate,NSTableViewDataSource,NSURLConnectionDelegate>
{

    IBOutlet NSTextField *urlTextFild;
    IBOutlet NSTextField *userTextFild;
    IBOutlet NSTextField *passwordTextFild;
    IBOutlet NSTextView *bodyTextView;    
    IBOutlet NSMatrix *httpMethod;
    IBOutlet NSTableView *tableView;
    IBOutlet NSMutableArray *headers;
    IBOutlet NSComboBox *comboBox;
    
    NSURLResponse* response;
    NSURLAuthenticationChallenge *myChallenge;

    NSArray *httpMethods;
    NSMutableString *stringDataResponse;
    id<WebServiceDelegate> delegate;
    BOOL enabled;

}

@property(nonatomic,assign) id<WebServiceDelegate> delegate;
@property(nonatomic,readonly) NSMutableString *stringDataResponse;
@property(nonatomic,assign) BOOL enabled;
@property(nonatomic,retain)  NSURLAuthenticationChallenge *myChallenge;

- (IBAction)goButtonAction:(id)sender;
- (IBAction)moreButtonAction:(id)sender;
- (IBAction)lessButtonAction:(id)sender;
- (IBAction)httpMethodButtonAction:(id)sender;

- (void)loadRequest:(Request*)request;
- (Request*)currentRequest;

- (void)cleanData;

@end
