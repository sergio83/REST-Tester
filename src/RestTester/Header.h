//
//  Header.h
//  RestTester
//
//  Created by Sergio Cirasa on 07/07/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Header : NSObject{
    NSString *key;
    NSString *value;
}

@property(nonatomic,retain) NSString *key;
@property(nonatomic,retain) NSString *value;

- (id)initWithDictionary:(NSDictionary*) dic;
+ (id)headerWithDictionary:(NSDictionary*) dic;
+ (id)headerWithValue:(NSString*)_value key:(NSString*)_key;
- (NSDictionary*) dictionary;

@end