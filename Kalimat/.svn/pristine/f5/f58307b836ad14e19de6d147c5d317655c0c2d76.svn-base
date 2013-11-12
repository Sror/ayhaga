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

+(NSArray *)getNumOfPages:(NSString *)bookID withFontSize:(int)fontSize;
+(void)setNumOfPages:(NSString *)bookID withPagesNumbers:(NSArray *)numberOFPages withFontSize:(int)fontSize;
+ (void)saveData:(NSData *)data withName:(NSString *)saveName inRelativePath:(NSString *)path inDocument:(BOOL)inDocument;
+ (NSData *)getDataWithName:(NSString *)dataName inRelativePath:(NSString *)path inDocument:(BOOL)inDocument;
+ (void)addBookmark:(NSString *)bookId withPage:(NSDictionary *)pageDictionary;
+(void)removeBookmark:(NSString *)bookId withPage:(NSDictionary *)pageDictionary;
+ (NSArray *)getBookmarkPages:(NSString *)bookId forFontSize:(int)fontSize;
+ (NSArray *)getArrayWithKey:(NSString *)arrayKey;
+ (NSDictionary *)getDictionaryWithKey:(NSString *)dictKey;
+(BOOL)isBookmarkNotExist:(NSString *)bookId withPage:(NSDictionary *)pageDictionary;
+ (NSDictionary *)getLastPageOpened:(NSString *)bookId;
+ (void)setLastPageOpened:(NSString *)bookId withPage:(NSDictionary *)pageDictionary;
+ (void)deleteItemsAtPath:(NSString *)path;

+ (void)deleteItemsAtPathFromCache:(NSString *)path;
+(BOOL)isBookDwonloadedWithID:(NSString *)bookID;
+(void)addBookWithID:(NSString *)bookID;
+(void)removeBookWithID:(NSString *)bookID;

+(void)addDownloadingBookWithID:(NSString *)bookID;
+(void)removeDownloadingBookWithID:(NSString *)bookID;
+(BOOL)isBookInDwonloadingWithID:(NSString *)bookID;
+ (NSString *)getStringWithKey:(NSString *)key;
+(NSString *)getBadgesNumber;

+(void)setCSSIDforBookID:(NSString *)bookID withCSSID:(NSString *)cssID;
+(NSString *)getCSSIDforBookID:(NSString *)bookId;
@end
