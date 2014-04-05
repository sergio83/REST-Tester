//
//  Header.m
//  RestTester
//
//  Created by Sergio Cirasa on 07/07/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import "Header.h"

@implementation Header
@synthesize key,value;

//----------------------------------------------------------------------------------------------------------------
- (id)init{
    self = [super init];
    if(self){
        self.key = nil;
        self.value = nil;      
    }
    return self;
}
//----------------------------------------------------------------------------------------------------------------
- (id)initWithDictionary:(NSDictionary*) dic{
    self = [super init];
    if(self){
        self.key = [dic objectForKey:@"key"];
        self.value = [dic objectForKey:@"value"];        
    }
    return self;
}
//----------------------------------------------------------------------------------------------------------------
+ (id)headerWithDictionary:(NSDictionary*) dic{
    Header *h = [[Header alloc] initWithDictionary:dic];
    return [h autorelease];
}
//----------------------------------------------------------------------------------------------------------------
+ (id)headerWithValue:(NSString*)_value key:(NSString*)_key{
    Header *h = [[Header alloc] init];
    h.value=_value;
    h.key=_key;
    return [h autorelease];
}
//----------------------------------------------------------------------------------------------------------------
- (NSDictionary*) dictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setValue:key forKey:@"key"];
    [dic setValue:value forKey:@"value"];
    return dic;
}
//----------------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [key release];
    [value release];
    [super dealloc];
}
//----------------------------------------------------------------------------------------------------------------
@end
