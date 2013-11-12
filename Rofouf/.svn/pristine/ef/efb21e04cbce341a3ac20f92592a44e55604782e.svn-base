//
//  CacheManager.m
//  Safahat-Reader
//
//  Created by Ahmed Aly on 12/31/12.
//  Copyright (c) 2012 Hindawi. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager

+ (void)saveArray:(NSArray *)array withName:(NSString *)saveName inRelativePath:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	[array writeToFile:[folder stringByAppendingPathComponent:saveName] atomically:YES];
}

+ (NSArray *)getArraywithName:(NSString *)saveName inRelativePath:(NSString *)path{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
    return [NSArray arrayWithContentsOfFile:[folder stringByAppendingPathComponent:saveName]];
}

+ (void)saveData:(NSData *)data withName:(NSString *)saveName inRelativePath:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	[data writeToFile:[folder stringByAppendingPathComponent:saveName] atomically:YES];
}

+ (NSData *)getDataWithName:(NSString *)dataName inRelativePath:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSString *dataPath = [folder stringByAppendingPathComponent:dataName];
	NSFileManager *fm = [NSFileManager defaultManager];
	return [fm contentsAtPath:dataPath];
}
+ (void)deleteItemsAtPath:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:folder error:NULL];
}


@end
