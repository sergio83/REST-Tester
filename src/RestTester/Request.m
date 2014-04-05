//
//  Request.m
//  RestTester
//
//  Created by Sergio Cirasa on 07/07/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import "Request.h"
#import "Header.h"
#import <objc/runtime.h> 
#import <objc/message.h>

@implementation Request
@synthesize name,url,httpBody,httpMethod,httpHeaders,user,password;
//----------------------------------------------------------------------------------------------------------------
- (id)init{
    self = [super init];
    if(self){
        self.user=nil;
        self.password=nil;
        self.url=nil;
        self.httpHeaders=nil;
        self.httpMethod=nil;
        self.httpBody=nil;
        self.name=nil;
    }
    return self;
}
//----------------------------------------------------------------------------------------------------------------
- (id)initWithDictionary:(NSDictionary*) dic{
    self = [super init];
    if(self){
        
        for(NSString *key in [dic allKeys]){
            if(![key isEqual:@"httpHeaders"]){
                [self setValue:[dic objectForKey:key] forKey:key];
            }
        }
        
        NSArray * array = [dic objectForKey:@"httpHeaders"];
        self.httpHeaders = [NSMutableArray arrayWithCapacity:10];
        
        for(NSDictionary *dictionary in array){
            Header *h = [Header headerWithDictionary:dictionary];
            [httpHeaders addObject:h];
        }

    }
    return self;
}
//----------------------------------------------------------------------------------------------------------------
+ (id)requestWithDictionary:(NSDictionary*) dic{
    Request *r = [[Request alloc] initWithDictionary:dic];
    return [r autorelease];
}
//----------------------------------------------------------------------------------------------------------------
- (NSDictionary*)dictionary{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [dic setValue:name forKey:@"name"];
    [dic setValue:url forKey:@"url"];
    [dic setValue:httpBody forKey:@"httpBody"];
    [dic setValue:httpMethod forKey:@"httpMethod"];
    [dic setValue:user forKey:@"user"];
    [dic setValue:password forKey:@"password"];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for(Header *h in self.httpHeaders){
        [array addObject:[h dictionary]];
    }
    
    [dic setValue:array forKey:@"httpHeaders"];
    
    /*
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:propName];
        if(key!=@"httpHeaders")
            [dic setValue:[self valueForKey:key] forKey:key];
    }
    free(properties);
    */
    return dic;
}
//----------------------------------------------------------------------------------------------------------------
- (NSArray*)params
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    if([httpMethod intValue]==GET){
        NSArray *listItems = [url componentsSeparatedByString:@"?"];
        if([listItems count]>1){
            NSString *params = [listItems lastObject];
            if(params!=nil && [params length]>0){
                listItems = [params componentsSeparatedByString:@"&"];
                for(NSString* param in listItems){
                    NSArray *keyvalue = [param componentsSeparatedByString:@"="];
                    if([keyvalue count]==2)
                        [array addObject:[keyvalue objectAtIndex:0]];
                }
            }
        }

    }else{

    }
    
    return array;
}
//----------------------------------------------------------------------------------------------------------------
- (NSArray*)values
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    if([httpMethod intValue]==GET){
        NSArray *listItems = [url componentsSeparatedByString:@"?"];
        if([listItems count]>1){
            NSString *params = [listItems lastObject];
            if(params!=nil && [params length]>0){
                listItems = [params componentsSeparatedByString:@"&"];
                for(NSString* param in listItems){
                    NSArray *keyvalue = [param componentsSeparatedByString:@"="];
                    if([keyvalue count]==2)
                        [array addObject:[keyvalue objectAtIndex:1]];
                }
            }
        }
        
    }else{
        
    }
    
    return array;
}
//----------------------------------------------------------------------------------------------------------------
- (NSString*)baseUrl{
    NSMutableArray* parts = [NSMutableArray arrayWithArray:[self.url componentsSeparatedByString:@"/"]];
    if(parts && [parts count]>0){
        [parts removeLastObject];
        return  [parts componentsJoinedByString:@"/"];
    }
    
    return @"";
}
//----------------------------------------------------------------------------------------------------------------
- (NSString*)serviceName{
    NSArray* parts = [self.url componentsSeparatedByString:@"/"];
    NSString *service = [parts lastObject];
    
    if(service && [service length]>0){
        parts = [service componentsSeparatedByString:@"?"];
        if(parts && [parts count]>0)
            return [parts  objectAtIndex:0];
    }
    return @"";
}
//----------------------------------------------------------------------------------------------------------------
+ (NSString*)methodForIndex:(NSInteger)index{
    switch (index) {
        case 1:
            return @"GET";
        case 2:
            return @"POST";
        case 3:
            return @"PUT";
        case 4:
            return @"DELETE";
    }
    return @"";
}
//----------------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [name release];
    [url release];
    [httpMethod release];
    [httpHeaders release];
    [httpBody release];
    [user release];
    [password release];
    [super dealloc];
}
//----------------------------------------------------------------------------------------------------------------
@end
