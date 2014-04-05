//
//  CodGenerator.h
//  RestTester
//
//  Created by Sergio Cirasa on 01/07/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "Request.h"
#import "Header.h"

@interface CodGenerator : NSObject
{
    NSString *jsonString;
    NSMutableArray *classes;
    NSMutableArray *files;
    NSString *pathToSave;
    Request *request;
    NSString *serviceName;
    BOOL copyModel;
}

@property(nonatomic,retain)    NSString *serviceName;

- (void)jsonToModel:(id)json saveFiles:(BOOL) saveFiles;
- (void)generateWSCode:(Request*)request;
- (void)generateWSCode:(Request*)request withJson:(NSString*) json;

@end
