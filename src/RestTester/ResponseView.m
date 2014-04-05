//
//  ResponseView.m
//  RestTester
//
//  Created by Sergio Cirasa on 25/06/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import "ResponseView.h"

@implementation ResponseView
@synthesize responseString,jsonString,responseHeaders,request;

//-------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)awakeFromNib{
    [responseText setEditable:NO];
    [tabView selectTabViewItemAtIndex:0];
    [responseText setTextContainerInset:NSMakeSize(5.0f, 10.0f)];
    [responseText setFont:[NSFont fontWithName:@"Helvetica" size:13]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"html"];
    
    if(path==nil || [path length]<=0)
        return;
    
    NSURLRequest *url = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path isDirectory:NO]];
    [[jsonWebView mainFrame] loadRequest:url];
    generator = [[CodGenerator alloc] init];

}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)generateAllButtonAction:(id)sender{
    [generator generateWSCode:request withJson:jsonString];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)generateModelButtonAction:(id)sender{
    if(jsonString==nil || [jsonString length]==0){
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                            defaultButton:@"Ok" 
                                          alternateButton:nil
                                              otherButton:nil
                                informativeTextWithFormat:@"JSON is empty."];
        [theAlert runModal];
        return;
    }
    [generator jsonToModel:jsonString saveFiles:YES];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)generateWSButtonAction:(id)sender{
    [generator generateWSCode:request];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)setResponseString:(NSString *)_responseString{
    [responseText setString:_responseString];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)setResponseHeaders:(NSDictionary *)_responseHeaders{
    
    NSMutableString *responseHeader = [[NSMutableString alloc] initWithCapacity:10];    
    NSArray *keys = [_responseHeaders allKeys];

    [responseHeader appendFormat:@"<div style=\" font-size: 10pt; font-family: 'helvetica', sans-serif; \">"];
    for(NSString* key in keys){
        NSString *value = [_responseHeaders objectForKey:key];
        [responseHeader appendFormat:@"<p><b>%@:</b> %@</p>",key,value];
    }
    [responseHeader appendFormat:@"</div>"];
    
    [[responseHeadersWebView mainFrame] loadHTMLString:responseHeader baseURL:nil];
    [responseHeader release];
    
    [tabView selectTabViewItemAtIndex:0];
   
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)setJsonString:(NSString *)_jsonString{
    
    [jsonString release];
    jsonString = [_jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];    
    jsonString = [[jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""] retain];
    [jsonWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"Process('%@');",jsonString ]]; 

}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [responseString release];
    [responseHeaders release];
    [jsonString release];
    [request release];
    [generator release];
    [super dealloc];
}
//-------------------------------------------------------------------------------------------------------------------------------------
@end
