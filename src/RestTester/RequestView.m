//
//  RequestView.m
//  RestTester
//
//  Created by Sergio Cirasa on 25/06/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import "RequestView.h"
#import "NSURLConnection+Background.h"
#import "JSONKit.h"
#import "Base64.h"

#define kEmptyString @"               -               "

@implementation RequestView
@synthesize delegate,stringDataResponse,enabled;

//-------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)awakeFromNib{
        enabled=YES;
    
        headers = [[NSMutableArray alloc] initWithCapacity:10];
        httpMethods = [[NSArray arrayWithObjects:@"GET",@"POST",@"PUT",@"DELETE", nil] retain];
        stringDataResponse = [[NSMutableString alloc] initWithCapacity:1];
    
        [httpMethod selectCellWithTag:2];
    
    /*
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:@"soapAction" forKey:kKey];
    [dic setObject:@"urn:sap-com:document:sap:soap:functions:mc-style:ZLSO_MOBILE_EDUCATION_011:ZMobActivitiesGetRequest" forKey:kValue];
    [headers addObject:dic];
    */
    
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (NSView *)hitTest:(NSPoint)aPoint{
    
    if(!enabled)
        return nil;

    return  [super hitTest:aPoint];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)cleanData{
    [urlTextFild setStringValue:@""];
    [userTextFild setStringValue:@""];
    [passwordTextFild setStringValue:@""];
    [bodyTextView setString:@""];
    [headers release];
    headers = [[NSMutableArray alloc] initWithCapacity:10];
        
    [tableView reloadData];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)goButtonAction:(id)sender{
    
    if([urlTextFild.stringValue length]==0){
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                            defaultButton:@"Ok" 
                                          alternateButton:nil
                                              otherButton:nil
                                informativeTextWithFormat:@"The url is empty"];
        [theAlert runModal];
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlTextFild.stringValue] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
	//NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlTextFild.stringValue]];
	[request setHTTPMethod: [httpMethods objectAtIndex:httpMethod.selectedRow]];

    for(Header*header in headers){
        if(![header.key isEqual:kEmptyString] && ![header.key isEqual:@""]){
            [request setValue:header.value forHTTPHeaderField:header.key];
        }
    }
    
    NSData *myRequestData = [NSData dataWithBytes:[bodyTextView.string UTF8String] length:[bodyTextView.string length]];
	[request setHTTPBody:myRequestData];
    
    [stringDataResponse release];
    stringDataResponse = [[NSMutableString alloc] initWithCapacity:1];
    
    if(delegate && [delegate respondsToSelector:@selector(willSendRequest:)])
        [delegate willSendRequest:request];
    
   // [self removeCredentials];

    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
}
//-------------------------------------------------------------------------------------------------------------------------------------
-(void) removeCredentials{
    
    // reset the credentials cache...
    NSDictionary *credentialsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];

    if ([credentialsDict count] > 0) {
        // the credentialsDict has NSURLProtectionSpace objs as keys and dicts of userName => NSURLCredential
        NSEnumerator *protectionSpaceEnumerator = [credentialsDict keyEnumerator];
        id urlProtectionSpace;
        
        // iterate over all NSURLProtectionSpaces
        while (urlProtectionSpace = [protectionSpaceEnumerator nextObject]) {
            NSEnumerator *userNameEnumerator = [[credentialsDict objectForKey:urlProtectionSpace] keyEnumerator];
            id userName;
            
            // iterate over all usernames for this protectionspace, which are the keys for the actual NSURLCredentials
            while (userName = [userNameEnumerator nextObject]) {
                NSURLCredential *cred = [[credentialsDict objectForKey:urlProtectionSpace] objectForKey:userName];
                NSLog(@"cred to be removed: %@", cred);
                [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:urlProtectionSpace];
            }
        }
    }
     
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)loadRequest:(Request*)request{    
   urlTextFild.stringValue= request.url ;
    userTextFild.stringValue=request.user ;
    passwordTextFild.stringValue=request.password;
    bodyTextView.string = request.httpBody;
    [httpMethod selectCellWithTag:[request.httpMethod  intValue]];

    if(headers!=nil)
        [headers release];

    headers=[[NSMutableArray alloc] initWithArray:request.httpHeaders]; 
    [tableView reloadData];
    [self httpMethodButtonAction:nil];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (Request*)currentRequest{
    Request *request = [[Request alloc] init];
    request.name = @"";
    request.url = urlTextFild.stringValue;
    request.user = userTextFild.stringValue;
    request.password = passwordTextFild.stringValue;
    request.httpBody = [NSString stringWithString:bodyTextView.string];
    request.httpMethod = [NSNumber numberWithInt:httpMethod.selectedTag];
    request.httpHeaders=headers;
    return [request autorelease];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                        defaultButton:@"Ok" 
                                      alternateButton:nil
                                          otherButton:nil
                            informativeTextWithFormat:[error description]];
    [theAlert runModal];
    
    if(delegate && [delegate respondsToSelector:@selector(connectionDidReceiveResponse:)])
        [delegate connectionDidReceiveResponse:nil];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if(delegate && [delegate respondsToSelector:@selector(connectionDidReceiveResponse:)])
        [delegate connectionDidReceiveResponse:[response autorelease]];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)_response{
    response=[_response retain];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(dataString==nil)
        dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    if(dataString){
        [stringDataResponse appendString:dataString];
        [dataString release];
    }
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return YES;
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:userTextFild.stringValue
                                                                    password:passwordTextFild.stringValue
                                                                 persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        self.myChallenge=challenge;
    }
    else {
        NSLog(@"previous authentication failure");
        
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Authentication failure"
                                            defaultButton:@"Ok"
                                          alternateButton:nil
                                              otherButton:nil
                                informativeTextWithFormat:@""];
        [theAlert runModal];
        
        if(delegate && [delegate respondsToSelector:@selector(connectionDidReceiveResponse:)])
            [delegate connectionDidReceiveResponse:nil];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)moreButtonAction:(id)sender{
    NSString *value = [comboBox objectValueOfSelectedItem];
    Header *header = [Header headerWithValue:kEmptyString key:(value==nil || [value isEqual:@""])?kEmptyString:value];
    
    [headers addObject:header];
    [tableView reloadData];
    [comboBox selectItemAtIndex:0];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)lessButtonAction:(id)sender{
    if([headers count]>0 && tableView.selectedRow < [headers count]){
        [headers removeObjectAtIndex:tableView.selectedRow];
        [tableView reloadData];
    }
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)httpMethodButtonAction:(id)sender{

    if(httpMethod.selectedRow==0){
        [bodyTextView setEditable:NO];
        [bodyTextView setString:@""];
        [bodyTextView setBackgroundColor:[NSColor colorWithDeviceRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
    }else{
        [bodyTextView setEditable:YES];   
        [bodyTextView setBackgroundColor:[NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    }
    
}
//-------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - NSTableViewDeleate & NSTableViewDataSource 
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    return [headers count];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    if(rowIndex>=[headers count])
        return nil;
    
    NSUInteger tableColumnIndex=[[tableView tableColumns] indexOfObject:aTableColumn];
    Header *header = [headers objectAtIndex:rowIndex];
    
    if(tableColumnIndex==0)
        return header.key;
    else return header.value;
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    if(rowIndex<[headers count]){
        NSUInteger tableColumnIndex=[[tableView tableColumns] indexOfObject:aTableColumn];
        Header *header = [headers objectAtIndex:rowIndex];
        
        if(tableColumnIndex==0)
            header.key=anObject;
        else header.value=anObject;
        
//        [headers replaceObjectAtIndex:rowIndex withObject:header];

        header = [headers objectAtIndex:rowIndex];
        NSLog(@"HEADER: %@  %@",header.value,header.key);
    }
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc{
    self.myChallenge=nil;
    [httpMethods release];
    [headers release];
    [super dealloc];
}
//-------------------------------------------------------------------------------------------------------------------------------------
@end
