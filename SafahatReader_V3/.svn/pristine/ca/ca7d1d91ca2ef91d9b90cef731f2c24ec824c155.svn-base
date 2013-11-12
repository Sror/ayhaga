//
//  UserDefaults.h
//  AePubReader
//
//  Created by Ahmed Aly on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+ (void)addObject:(id)objectValue withKey:(NSString *)objectKey ifKeyNotExists:(BOOL)keyCheck;
+ (BOOL)checkForKey:(NSString *)checkKey;

+ (NSString *)getStringWithKey:(NSString *)key;
+ (NSData *)getDataWithName:(NSString *)dataName inRelativePath:(NSString *)path;
+ (NSArray *)getArrayWithKey:(NSString *)arrayKey;
+ (NSDictionary *)getDictionaryWithKey:(NSString *)key;
+ (void)saveData:(NSData *)data withName:(NSString *)saveName inRelativePath:(NSString *)path;
+ (void)saveData:(NSData *)data withName:(NSString *)saveName inRelativePath:(NSString *)path inDocument:(BOOL)inDocument;

@end
//dddddd