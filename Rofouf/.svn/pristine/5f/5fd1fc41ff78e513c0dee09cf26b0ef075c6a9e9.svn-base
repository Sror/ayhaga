//
//  CacheManager.h
//  Safahat-Reader
//
//  Created by Ahmed Aly on 12/31/12.
//  Copyright (c) 2012 Hindawi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject
+ (void)saveArray:(NSArray *)array withName:(NSString *)saveName inRelativePath:(NSString *)path;
+ (NSArray *)getArraywithName:(NSString *)saveName inRelativePath:(NSString *)path;
+ (void)saveData:(NSData *)data withName:(NSString *)saveName inRelativePath:(NSString *)path;
+ (NSData *)getDataWithName:(NSString *)dataName inRelativePath:(NSString *)path;
+ (void)deleteItemsAtPath:(NSString *)path;
@end
