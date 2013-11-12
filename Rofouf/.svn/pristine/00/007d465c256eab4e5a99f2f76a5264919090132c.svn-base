//
//  UserDefaults.m
//  AePubReader
//
//  Created by Ahmed Aly on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDefaults.h"
#import "Constants.h"


@implementation UserDefaults



+ (NSDictionary *)getDictionaryWithKey:(NSString *)key{
    NSDictionary *userData = nil;
	
	if (key != nil) {
		NSObject *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
		if ([returnObject isKindOfClass:[NSDictionary class]]) {
			userData = (NSDictionary *)returnObject;
		}
	}
	
	return userData;
}
+ (void)addObject:(id)objectValue withKey:(NSString *)objectKey ifKeyNotExists:(BOOL)keyCheck{

   // NSLog(@"dict=%@",objectValue);
	if ((objectKey != nil) && !keyCheck) {
		[[NSUserDefaults standardUserDefaults] setObject:objectValue forKey:objectKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else if (objectKey != nil) {
		NSObject *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:objectKey];
		if (returnObject == nil) {
			[[NSUserDefaults standardUserDefaults] setObject:objectValue forKey:objectKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
}

+ (NSArray *)getArrayWithKey:(NSString *)arrayKey{
	NSArray *userData = nil;
	
	if (arrayKey != nil) {
		NSObject *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:arrayKey];
		if ([returnObject isKindOfClass:[NSArray class]]) {
			userData = (NSArray *)returnObject;
		}
	}
	
	return userData;
}
+ (NSString *)getStringWithKey:(NSString *)key{
	NSString *userData = nil;
	
	if (key != nil) {
		NSObject *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
		if ([returnObject isKindOfClass:[NSArray class]]) {
			userData = (NSString *)returnObject;
		}
        
        else
            userData = [NSString stringWithFormat:@"%@",returnObject];
	}
	
	return userData;
}
//commit
+ (BOOL)checkForKey:(NSString *)checkKey{

	BOOL checkResult = YES;
	NSObject *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:checkKey];
	if (returnObject == nil) {
		checkResult = NO;
	}
	
	return checkResult;
}

+ (void)saveData:(NSData *)data withName:(NSString *)saveName inRelativePath:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	[data writeToFile:[folder stringByAppendingPathComponent:saveName] atomically:YES];
}

+ (void)saveData:(NSData *)data withName:(NSString *)saveName inRelativePath:(NSString *)path inDocument:(BOOL)inDocument{
    NSArray *documentPaths =nil;
    
    if (inDocument) {
        documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    }else
        documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	
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
@end
