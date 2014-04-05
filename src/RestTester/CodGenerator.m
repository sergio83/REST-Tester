//
//  CodGenerator.m
//  RestTester
//
//  Created by Sergio Cirasa on 01/07/12.
//  Copyright (c) 2012 Creative Coefficient. All rights reserved.
//

#import "CodGenerator.h"
#import "SSZipArchive.h"
#define kNameOfClass  @"BaseClass"

@implementation CodGenerator
@synthesize serviceName;

//-------------------------------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if(self){
    
    }
    return self;
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (NSString*) uppercaseFirstCharacter:(NSString*) text
{
    if([text length]==0)
        return text;
    
    NSString *firstCharacter = [[text uppercaseString] substringWithRange:NSMakeRange(0, 1)];
    NSString *restOfTheString = @"";
    
    if([text length]>1)
        restOfTheString = [text substringWithRange:NSMakeRange(1, [text length]-1)];
    
    return [NSString stringWithFormat:@"%@%@",firstCharacter,restOfTheString];
    
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (NSString*) lowercaseFirstCharacter:(NSString*) text
{
    if([text length]==0)
        return text;
    
    NSString *firstCharacter = [[text lowercaseString] substringWithRange:NSMakeRange(0, 1)];
    NSString *restOfTheString = @"";
    
    if([text length]>1)
        restOfTheString = [text substringWithRange:NSMakeRange(1, [text length]-1)];
    
    return [NSString stringWithFormat:@"%@%@",firstCharacter,restOfTheString];
}
//-------------------------------------------------------------------------------------------------------------------------------------
- (void)recognizeClass:(id) dic name:(NSString*) name
{
    
    if([dic isKindOfClass:NSDictionary.class]){
        [classes addObject:[NSDictionary dictionaryWithObjectsAndKeys:dic,@"Value",name,@"Key", nil]];
        NSArray *keys = [dic allKeys];
        
        for(NSString *key in keys){
            id value = [dic objectForKey:key];
            
            if([value isKindOfClass:NSDictionary.class]){
                [self recognizeClass:value name:key];
                
            }else if([value isKindOfClass:NSArray.class]){
                    NSArray *array = (NSArray*)value;
                    if([array count]>0){
                            id obj = [array objectAtIndex:0];
                            if([obj isKindOfClass:NSDictionary.class]){
                                [self recognizeClass:obj name:key];
                            }else{
                              //  [classes addObject:[NSDictionary dictionaryWithObjectsAndKeys:value,@"Value",[key substringWithRange:NSMakeRange(0, [key length]-1)],@"Key", nil]];
                            }
                    }                            
            }
        }
        
    }else if([dic isKindOfClass:NSArray.class]){
        id pp = [(NSArray*)dic objectAtIndex:0];
        [self recognizeClass:pp name:name];
    }
    
}
//-----------------------------------------------------------------------------------------------
- (void)printHeader:(NSDictionary*) dic{
    NSString *name = [self uppercaseFirstCharacter:[dic objectForKey:@"Key"]];
    NSDictionary *aClass = [dic objectForKey:@"Value"];
    NSArray *keys = [aClass allKeys];
    NSMutableString *outputStr= [[NSMutableString alloc] initWithCapacity:30];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	NSString *date = [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];

     dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy"];
	NSString *year = [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
    
    [outputStr appendString:[NSString stringWithFormat:@"//\n"]];
    [outputStr appendString:[NSString stringWithFormat:@"// %@.h\n",name]];
    [outputStr appendString:[NSString stringWithFormat:@"//\n"]];
    [outputStr appendString:[NSString stringWithFormat:@"// Created by Sergio Cirasa on %@.\n",date]];
    [outputStr appendString:[NSString stringWithFormat:@"// Copyright (c) %@ Creative Coefficient. All rights reserved.\n",year]];
    [outputStr appendString:[NSString stringWithFormat:@"//\n\n"]];
    
    
    [outputStr appendString:@"#import <Foundation/Foundation.h>\n"];
    [outputStr appendString:@"#import \"JSONKit.h\" \n\n"];
    
    for(NSString *key in keys){
        id value = [aClass objectForKey:key];
        
        if([value isKindOfClass:NSDictionary.class]){
            [outputStr appendString:[NSString stringWithFormat:@"@class %@;\n",[self uppercaseFirstCharacter:key]]];
            
        }else if([value isKindOfClass:NSArray.class]){
            NSString *name = [self uppercaseFirstCharacter:key] ;
            [outputStr appendString:[NSString stringWithFormat:@"@class %@; \n",[name substringWithRange:NSMakeRange(0, [name length]-1)]]];
            
        }
        
    }
    
    [outputStr appendString:@"\n"];
    [outputStr appendString:[NSString stringWithFormat:@"@interface %@ : NSObject{ \n",name]];
    
    for(NSString *key in keys){
        id value = [aClass objectForKey:key];
        
        if([value isKindOfClass:NSDictionary.class]){
            [outputStr appendString:[NSString stringWithFormat:@"    %@ *%@;\n",[self uppercaseFirstCharacter:key],[self lowercaseFirstCharacter:key]]];
            
        }else if([value isKindOfClass:NSArray.class]){
            [outputStr appendString:[NSString stringWithFormat:@"    NSMutableArray *%@; \n",[self lowercaseFirstCharacter:key]]];
            
        }else if([value isKindOfClass:NSNumber.class]){
            [outputStr appendString:[NSString stringWithFormat:@"    NSNumber *%@; \n",[self lowercaseFirstCharacter:key]]];
            
        }else if([value isKindOfClass:NSString.class]){            
            [outputStr appendString:[NSString stringWithFormat:@"    NSString *%@; \n",[self lowercaseFirstCharacter:key]]];
        }
        
    }
    
    [outputStr appendString:@"}\n\n"];
    
    for(NSString *key in keys){
        id value = [aClass objectForKey:key];
        
        if([value isKindOfClass:NSDictionary.class]){
            [outputStr appendString:[NSString stringWithFormat:@"@property(nonatomic,retain) %@ *%@; \n",[self uppercaseFirstCharacter:key],[self lowercaseFirstCharacter:key] ]];
            
        }else if([value isKindOfClass:NSArray.class]){
            [outputStr appendString:[NSString stringWithFormat:@"@property(nonatomic,retain) NSMutableArray *%@; \n",[self lowercaseFirstCharacter:key] ]];
        }else if([value isKindOfClass:NSNumber.class]){
            [outputStr appendString:[NSString stringWithFormat:@"@property(nonatomic,retain) NSNumber *%@; \n",[self lowercaseFirstCharacter:key] ]];
        }else if([value isKindOfClass:NSString.class]){            
            [outputStr appendString:[NSString stringWithFormat:@"@property(nonatomic,retain) NSString *%@; \n",[self lowercaseFirstCharacter:key] ]];
        }
        
    }

    [outputStr appendString:@"\n"];
    [outputStr appendString:@"+ (id)objectWithDictionary:(NSDictionary*)dictionary; \n"];
    [outputStr appendString:@"- (id)initWithDictionary:(NSDictionary*)dictionary; \n\n"];
    [outputStr appendString:@"@end \n\n"];    

    [files addObject:[NSString stringWithFormat:@"%@/%@.h",pathToSave,name]];
    [outputStr writeToFile:[NSString stringWithFormat:@"%@/%@.h",pathToSave,name] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [outputStr release];
}
//-----------------------------------------------------------------------------------------------
- (void)printSource:(NSDictionary*) dic{
    NSString *name = [self uppercaseFirstCharacter:[dic objectForKey:@"Key"]];
    NSDictionary *aClass = [dic objectForKey:@"Value"];
    NSArray *keys = [aClass allKeys];
    NSMutableString *outputStr= [[NSMutableString alloc] initWithCapacity:30];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	NSString *date = [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
    
    dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy"];
	NSString *year = [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
    
    [outputStr appendString:[NSString stringWithFormat:@"//\n"]];
    [outputStr appendString:[NSString stringWithFormat:@"// %@.m\n",name]];
    [outputStr appendString:[NSString stringWithFormat:@"//\n"]];
    [outputStr appendString:[NSString stringWithFormat:@"// Created by Sergio Cirasa on %@.\n",date]];
    [outputStr appendString:[NSString stringWithFormat:@"// Copyright (c) %@ Creative Coefficient. All rights reserved.\n",year]];
    [outputStr appendString:[NSString stringWithFormat:@"// \n\n"]];
    
    [outputStr appendString:[NSString stringWithFormat:@"#import \"%@.h\" \n\n",name ]];
    [outputStr appendString:[NSString stringWithFormat:@"@implementation %@ \n",name ]];
    
    for(NSString *key in keys){
            [outputStr appendString:[NSString stringWithFormat:@"@synthesize %@; \n",[self lowercaseFirstCharacter:key] ]];
    }
    
    [outputStr appendString:[NSString stringWithFormat:@"\n\n" ]];
    [outputStr appendString:[NSString stringWithFormat:@"+ (id)objectWithDictionary:(NSDictionary*)dictionary \n{ \n   id obj = [[[%@ alloc] initWithDictionary:dictionary] autorelease]; \n   return obj; \n} \n\n",name ]];
    
    [outputStr appendString:[NSString stringWithFormat:@"- (id)initWithDictionary:(NSDictionary*)dictionary\n{\n    self=[super init];\n    if(self){\n" ]];
    
    for(NSString *key in keys){
        id value = [aClass objectForKey:key];
        
        if([value isKindOfClass:NSDictionary.class]){
                [outputStr appendString:[NSString stringWithFormat:@"       %@ = [[%@ alloc] initWithDictionary:[dictionary objectForKey:@\"%@\"]]; \n",[self lowercaseFirstCharacter:key],[self uppercaseFirstCharacter:key],key ]];
        }else if([value isKindOfClass:NSArray.class]){
                [outputStr appendString:[NSString stringWithFormat:@"\n       NSArray* temp =  [dictionary objectForKey:@\"%@\"]; \n",key ]];
                [outputStr appendString:[NSString stringWithFormat:@"       %@ = [[NSMutableArray alloc] init];\n",[self lowercaseFirstCharacter:key] ]];
                [outputStr appendString:[NSString stringWithFormat:@"       for(NSDictionary *d in temp) {\n" ]];
            
                NSArray *array = (NSArray*) value;
                if([array count]>0){
                    if([[array objectAtIndex:0] isKindOfClass:NSDictionary.class])
                        [outputStr appendString:[NSString stringWithFormat:@"           [%@ addObject:[%@ objectWithDictionary:d]];\n",[self lowercaseFirstCharacter:key],[self uppercaseFirstCharacter:[key substringWithRange:NSMakeRange(0, [key length]-1)]] ]];
                    else{
                            [outputStr appendString:[NSString stringWithFormat:@"           [%@ addObject:d];\n",[self lowercaseFirstCharacter:key] ]];
                    }
                }
            
                [outputStr appendString:[NSString stringWithFormat:@"       }\n\n" ]];
            
        }else if([value isKindOfClass:NSNumber.class]){
                [outputStr appendString:[NSString stringWithFormat:@"       %@ = [dictionary objectForKey:@\"%@\"]; \n",[self lowercaseFirstCharacter:key],key ]];
            
        }else if([value isKindOfClass:NSString.class]){            
                [outputStr appendString:[NSString stringWithFormat:@"       %@ = [dictionary objectForKey:@\"%@\"]; \n",[self lowercaseFirstCharacter:key],key ]];
        }
        
    }
    
    [outputStr appendString:[NSString stringWithFormat:@"   }\n     return self;\n}\n" ]];
    
    
    [outputStr appendString:[NSString stringWithFormat:@"\n- (void)dealloc{\n" ]];
    
    for(NSString *key in keys){
            [outputStr appendString:[NSString stringWithFormat:@"    [%@ release]; \n",[self lowercaseFirstCharacter:key] ]];
    }

    [outputStr appendString:[NSString stringWithFormat:@"    [super dealloc];\n}\n" ]];   

    [outputStr appendString:[NSString stringWithFormat:@"\n" ]];
    [outputStr appendString:[NSString stringWithFormat:@"@end \n\n" ]];
    
    [files addObject:[NSString stringWithFormat:@"%@/%@.m",pathToSave,name]];
    [outputStr writeToFile:[NSString stringWithFormat:@"%@/%@.m",pathToSave,name] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [outputStr release];
}
//-----------------------------------------------------------------------------------------------
- (void)generateClass:(NSDictionary*) dic
{
    [self printHeader:dic];
    [self printSource:dic];
}
//-----------------------------------------------------------------------------------------------
- (void)jsonToModel:(id)json saveFiles:(BOOL) saveFiles
{
    [jsonString release];
    jsonString = [json retain];
    id value = [jsonString objectFromJSONString];
    
    if(value==nil){
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                            defaultButton:@"Ok" 
                                          alternateButton:nil
                                              otherButton:nil
                                informativeTextWithFormat:@"JSON invalid."];
        [theAlert runModal];
        return;
    }
    
    NSAlert *theAlert = [NSAlert alertWithMessageText:@"Insert the name of class." 
                                        defaultButton:@"Accept" 
                                      alternateButton:@"Cancel"
                                          otherButton:nil
                            informativeTextWithFormat:@"Name:"];
    
    NSTextField *accessory = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,294,22)];
	[accessory setDrawsBackground:YES];
    [theAlert setAccessoryView:accessory];
    [accessory release];
    
    int rCode = [theAlert runModal];
    NSString *className = kNameOfClass;
    
    if (rCode && (accessory.stringValue && [accessory.stringValue length]>0)) {
        className = [NSString stringWithFormat:accessory.stringValue];
    }else{
        return;
    }
    
    [files release];
    files = [[NSMutableArray alloc] initWithCapacity:10];
    
    [classes release];
    classes = [[NSMutableArray alloc] initWithCapacity:10];
 
    
    NSString *path = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count])
    {
        NSString *bundleName =
        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    }
    
    pathToSave = [NSString stringWithFormat:@"%@/Model",path];
    NSError *error=nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToSave]){
        [[NSFileManager defaultManager] removeItemAtPath:pathToSave error:&error];
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:pathToSave withIntermediateDirectories:YES attributes:nil error:&error];   
    
    [self recognizeClass:value name:className];
    
    for(NSDictionary *dic in classes){
        [self generateClass:dic];
    }

    if(saveFiles){
        BOOL est = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/zip.zip",pathToSave] withFilesAtPaths:files];
        
        if(est){
                NSSavePanel * zSavePanel = [NSSavePanel savePanel];
                NSInteger zResult = [zSavePanel runModal];
                if (zResult == NSFileHandlingPanelCancelButton) {
                    return;
                } 
                
                NSURL *zUrl = [zSavePanel URL];
                path = [NSString stringWithFormat:@"%@.zip",[zUrl path]];

                if (![[NSFileManager defaultManager] copyItemAtPath:[NSString stringWithFormat:@"%@/zip.zip",pathToSave] toPath:path error:&error]) 
                {
                    if([[NSFileManager defaultManager] fileExistsAtPath:pathToSave]){
                        [[NSFileManager defaultManager] removeItemAtPath:pathToSave error:&error];
                    }
                }
            }else{
                NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                           defaultButton:@"Ok" 
                                         alternateButton:nil
                                             otherButton:nil
                               informativeTextWithFormat:@"No se pudo generar el modelo."];
                [theAlert runModal];
            }
    }
    
}
//-----------------------------------------------------------------------------------------------
- (void)generateHeaderService
{
    NSError *error = nil;
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"CustomServiceH" ofType:@""];
    NSString *outputStr = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];

    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#NAME#" withString:serviceName];

    if([request.httpMethod intValue]==GET){
        NSMutableString *params = [[NSMutableString alloc] initWithCapacity:30];
        NSArray *array = [request params];
        
        if([array count]>0){
            [params appendFormat:@"With"];
            [params appendFormat:@"%@:(NSString*) %@ ",[self uppercaseFirstCharacter:[array objectAtIndex:0]],[array objectAtIndex:0]];
        }
        
        for(int i=1; i<[array count];i++){
            NSString *name = [array objectAtIndex:i];
            [params appendFormat:@"%@:(NSString*) %@ ",name,name];
        }
        
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#PARAMS#" withString:params];
        [params release];
    }else{
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#PARAMS#" withString:@"WithPostBody:(NSString*) postBodyString"];
    }
    
    [files addObject:[NSString stringWithFormat:@"%@/%@Service.h",pathToSave,serviceName]];
    [outputStr writeToFile:[NSString stringWithFormat:@"%@/TestSeviceExample/TestSeviceExample/Component/%@Service.h",pathToSave,serviceName] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}
//-----------------------------------------------------------------------------------------------
- (void)generateSourceService
{
    NSError *error = nil;
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"CustomServiceM" ofType:@""];
    NSString *outputStr = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#NAME#" withString:serviceName];
    
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#METHOD#" withString:[Request methodForIndex:[request.httpMethod intValue]]];    
    
    if([request.httpMethod intValue]!=GET){
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#KEYS#" withString:@""];
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#VALUES#" withString:@""];
        
        if(request.httpBody!=nil && [request.httpBody length]!=0){
            outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#PARAMS#" withString:@"WithPostBody:(NSString*) postBodyString"];
            outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#POSTVALUES#" withString:@"       [request setPostBody:[postBodyString dataUsingEncoding:NSUTF8StringEncoding]];"];
        }
        
    }else{
        
        NSMutableString *params = [[NSMutableString alloc] initWithCapacity:30];
        NSArray *array = [request params];
        
        if([array count]>0){
            [params appendFormat:@"With"];
            [params appendFormat:@"%@:(NSString*) %@ ",[self uppercaseFirstCharacter:[array objectAtIndex:0]],[array objectAtIndex:0]];
        }
        
        for(int i=1; i<[array count];i++){
            NSString *name = [array objectAtIndex:i];
            [params appendFormat:@"%@:(NSString*) %@ ",name,name];
        }
        
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#PARAMS#" withString:params];
        [params release];
        
        NSMutableString *keys = [[NSMutableString alloc] initWithCapacity:30];
        NSMutableString *values = [[NSMutableString alloc] initWithCapacity:30];
        
        if([array count]>1){
            [keys appendFormat:@"?%@=%%@",[array objectAtIndex:0]];
            [values appendFormat:@",%@",[array objectAtIndex:0]];      
        }
        
        for(int i=1; i<[array count];i++){
            NSString *name = [array objectAtIndex:i];
            [keys appendFormat:@"&%@=%%@",name];
            [values appendFormat:@",%@",name];            
        }
        
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#KEYS#" withString:keys];
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#VALUES#" withString:values];
        [keys release];
        [values release];
        
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#POSTVALUES#" withString:@""];
    }
    
    NSMutableString *headerOutput = [[NSMutableString alloc] initWithCapacity:30];

    for(Header *header in request.httpHeaders){
        [headerOutput appendFormat:@"       [request addRequestHeader:@\"%@\" value:@\"%@\"];\n",header.key,header.value];
    }
    
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#HEADERSVALUES#" withString:headerOutput];
    [headerOutput release];
    
    [files addObject:[NSString stringWithFormat:@"%@/%@Service.m",pathToSave,serviceName]];
    [outputStr writeToFile:[NSString stringWithFormat:@"%@/TestSeviceExample/TestSeviceExample/Component/%@Service.m",pathToSave,serviceName] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}
//-----------------------------------------------------------------------------------------------
- (void)generateExample{
    NSError *error = nil;
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"ExampleH" ofType:@""];
    NSString *outputStr = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#NAME#" withString:serviceName];
    
    [files addObject:[NSString stringWithFormat:@"%@/Example.h",pathToSave]];
    [outputStr writeToFile:[NSString stringWithFormat:@"%@/TestSeviceExample/TestSeviceExample/Component/Example.h",pathToSave] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
   //--------- 
    fullPath = [[NSBundle mainBundle] pathForResource:@"ExampleM" ofType:@""];
     outputStr = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#NAME#" withString:serviceName];
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#USER#" withString:request.user];
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#PASSWORD#" withString:request.password];
    
    if([request.httpMethod intValue]!=GET){
        if(request.httpBody!=nil && [request.httpBody length]!=0){
            outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#PARAMS#" withString:[NSString stringWithFormat:@"WithPostBody:@\"%@\"",request.httpBody]];
        }
        
    }else{
        NSMutableString *params = [[NSMutableString alloc] initWithCapacity:30];
        NSArray *array = [request params];
        NSArray *values = [request values];
        
        if([array count]>0){
            NSString *value = (0<[values count])?[values objectAtIndex:0]:@"";
            [params appendFormat:@"With"];
            [params appendFormat:@"%@:@\"%@\"",[self uppercaseFirstCharacter:[array objectAtIndex:0]],value];
        }
        
        for(int i=1; i<[array count];i++){
            NSString *name = (i<[array count])?[array objectAtIndex:i]:@""; 
            NSString *value = (i<[values count])?[values objectAtIndex:i]:@"";
            [params appendFormat:@"%@:@\"%@\" ",name,value];
        }
        
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#PARAMS#" withString:params];
        [params release];
    }
    
    [files addObject:[NSString stringWithFormat:@"%@/Example.m",pathToSave]];
    [outputStr writeToFile:[NSString stringWithFormat:@"%@/TestSeviceExample/TestSeviceExample/Component/Example.m",pathToSave] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}
//-----------------------------------------------------------------------------------------------
- (void)copyResources{
    NSError *error=nil;
 
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"WebServiceConfigH" ofType:@""];
    NSString *outputStr = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#NAME#" withString:serviceName];
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#URLSERVICE#" withString:[request serviceName]];
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#URLBASE#" withString:[request baseUrl]];
    
    [files addObject:[NSString stringWithFormat:@"%@/WebServiceConfig.h",pathToSave]];
    [outputStr writeToFile:[NSString stringWithFormat:@"%@/TestSeviceExample/TestSeviceExample/Component/WebServiceConfig.h",pathToSave] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    
    outputStr = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/TestSeviceExample/TestSeviceExample.xcodeproj/project.pbxproj",pathToSave] encoding:NSUTF8StringEncoding error:&error];
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"#NAME#" withString:serviceName];
    [outputStr writeToFile:[NSString stringWithFormat:@"%@/TestSeviceExample/TestSeviceExample.xcodeproj/project.pbxproj",pathToSave]  atomically:YES encoding:NSUTF8StringEncoding error:&error];
}
//-----------------------------------------------------------------------------------------------
- (void)generateWSCode:(Request*)_request
{
    
    NSAlert *theAlert = [NSAlert alertWithMessageText:@"Insert the name of service." 
                                        defaultButton:@"Accept" 
                                      alternateButton:@"Cancel"
                                          otherButton:nil
                            informativeTextWithFormat:@"Name:"];
    
    NSTextField *accessory = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,294,22)];
	[accessory setDrawsBackground:YES];
    [theAlert setAccessoryView:accessory];
    [accessory release];
    
    int rCode = [theAlert runModal];
     self.serviceName = @"";
    
    if (rCode && (accessory.stringValue && [accessory.stringValue length]>0)) {
        self.serviceName = [NSString stringWithFormat:accessory.stringValue];
        if([serviceName isEqual:@"Service"])
            serviceName = [NSString stringWithFormat:@"MyService"];
    }else{
        return;
    }
    
    [request release];
    request=[_request retain];  
    [files release];
    files = [[NSMutableArray alloc] initWithCapacity:10];
    
    [classes release];
    classes = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSString *path = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count])
    {
        NSString *bundleName =
        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    }
    
    pathToSave = [NSString stringWithFormat:@"%@/Files",path];
    NSLog(@"PATH %@",pathToSave);
    NSError *error=nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToSave]){
        [[NSFileManager defaultManager] removeItemAtPath:pathToSave error:&error];
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:pathToSave withIntermediateDirectories:YES attributes:nil error:&error];   
    
    NSString* pathToZipFile = [[NSBundle mainBundle] pathForResource:@"Project" ofType:@"zip"];
    [SSZipArchive unzipFileAtPath:pathToZipFile toDestination:pathToSave delegate:nil];    
    
    [self generateHeaderService];
    [self generateSourceService];
    [self generateExample];
    [self copyResources];
    
    if(copyModel){
        NSString *path = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                             NSCachesDirectory, NSUserDomainMask, YES);
        if ([paths count])
        {
            NSString *bundleName =
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
        }
        
        if (![[NSFileManager defaultManager] copyItemAtPath:[NSString stringWithFormat:@"%@/Model",path] toPath:[NSString stringWithFormat:@"%@/TestSeviceExample/Model",pathToSave] error:&error]){
        }
    }
    
    NSLog(@"URL %@",[NSString stringWithFormat:@"%@/TestSeviceExample",pathToSave]);
    
  //  BOOL est = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/zip.zip",pathToSave] withFilesAtPaths:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@/TestSeviceExample",pathToSave], nil]];
    
    if(1){
        NSSavePanel * zSavePanel = [NSSavePanel savePanel];
        NSInteger zResult = [zSavePanel runModal];
        if (zResult == NSFileHandlingPanelCancelButton) {
            return;
        } 
        
        NSURL *zUrl = [zSavePanel URL];
        path = [NSString stringWithFormat:@"%@",[zUrl path]];
        
        if (![[NSFileManager defaultManager] copyItemAtPath:[NSString stringWithFormat:@"%@/TestSeviceExample",pathToSave] toPath:path error:&error]){
            if([[NSFileManager defaultManager] fileExistsAtPath:pathToSave]){
                [[NSFileManager defaultManager] removeItemAtPath:pathToSave error:&error];
            }
        }
    }else{
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" 
                                            defaultButton:@"Ok" 
                                          alternateButton:nil
                                              otherButton:nil
                                informativeTextWithFormat:@"No se pudo generar el modelo."];
        [theAlert runModal];
    }
}
//-----------------------------------------------------------------------------------------------
- (void)generateWSCode:(Request*)_request withJson:(NSString*) json{

    copyModel=YES;
    if(json && [json length]>0)
        [self jsonToModel:json saveFiles:NO];

    [self generateWSCode:_request];
    copyModel=NO;
}
//-----------------------------------------------------------------------------------------------
- (void)dealloc
{
    [request release];
    [classes release];
    [jsonString release];
    [super dealloc];
}
//-----------------------------------------------------------------------------------------------

@end
