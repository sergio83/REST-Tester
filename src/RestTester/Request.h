//
//  Request.h
//  RestTester
//
//  Created by Sergio Cirasa on 07/07/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    GET = 1,
    POST,
    PUT,
    DELETE
} HttpMethod;

@interface Request : NSObject{
    NSString *name;
    NSString *url;
    NSString *httpBody;
    NSNumber *httpMethod;
    NSString *user;
    NSString *password;
    NSMutableArray *httpHeaders;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain) NSString *httpBody;
@property(nonatomic,retain) NSNumber *httpMethod;
@property(nonatomic,retain) NSString *user;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,retain) NSMutableArray *httpHeaders;

- (id)initWithDictionary:(NSDictionary*) dic;
+ (id)requestWithDictionary:(NSDictionary*) dic;
- (NSDictionary*)dictionary;
- (NSArray*)params;
- (NSArray*)values;
+ (NSString*)methodForIndex:(NSInteger)index;
- (NSString*)serviceName;
- (NSString*)baseUrl;

@end
