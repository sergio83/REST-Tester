//
//  ResponseView.h
//  RestTester
//
//  Created by Sergio Cirasa on 25/06/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "CodGenerator.h"
#import "Request.h"

@interface ResponseView : NSView
{
    IBOutlet NSTextView *responseText;
    IBOutlet WebView *responseHeadersWebView;
    IBOutlet NSTabView *tabView;
    IBOutlet WebView *jsonWebView;
    NSString *jsonString;
    CodGenerator *generator;
    Request *request;
    
}

@property(nonatomic,retain) NSString *responseString;
@property(nonatomic,retain) NSDictionary *responseHeaders;
@property(nonatomic,retain) NSString *jsonString;
@property(nonatomic,retain) Request *request;

- (IBAction)generateAllButtonAction:(id)sender;
- (IBAction)generateModelButtonAction:(id)sender;
- (IBAction)generateWSButtonAction:(id)sender;

@end
