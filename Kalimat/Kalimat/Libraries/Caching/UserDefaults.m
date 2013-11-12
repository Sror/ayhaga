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

+ (void)addBookmark:(NSString *)bookId withPage:(NSDictionary *)pageDictionary{
    NSMutableDictionary *returnObject =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:bookId]];
    NSMutableArray *bookmarkArray=[NSMutableArray arrayWithArray:[returnObject objectForKey:BOOKMARK]];
    [bookmarkArray addObject:pageDictionary];
    [returnObject addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:bookmarkArray,BOOKMARK, nil]];
    [self addObject:returnObject withKey:bookId ifKeyNotExists:NO];
}
+ (NSArray *)getBookmarkPages:(NSString *)bookId forFontSize:(int)fontSize{
    NSArray *bookmarksArray=[NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:bookId] objectForKey:BOOKMARK]];
    NSMutableArray *currentArray=[NSMutableArray array];
    for (int i=0; i<[bookmarksArray count]; i++) {
        if ([[[bookmarksArray objectAtIndex:i] objectForKey:FONT_SIZE] intValue]== fontSize) {
            [currentArray addObject:[bookmarksArray objectAtIndex:i]];
        }
    }
    return currentArray;
}
+(BOOL)isBookmarkNotExist:(NSString *)bookId withPage:(NSDictionary *)pageDictionary{
     NSArray *bookmarksArray=[NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:bookId] objectForKey:BOOKMARK]];
    for (int i=0; i<[bookmarksArray count]; i++) {
        if ([[[bookmarksArray objectAtIndex:i] objectForKey:CHAPTER_KEY] isEqual:[pageDictionary objectForKey:CHAPTER_KEY]] && [[[bookmarksArray objectAtIndex:i] objectForKey:PAGE_KEY] isEqual:[pageDictionary objectForKey:PAGE_KEY]]&& [[[bookmarksArray objectAtIndex:i] objectForKey:FONT_SIZE] isEqual:[pageDictionary objectForKey:FONT_SIZE]]) {
            return NO;
        }
    }
    return YES;
}
+(void)removeBookmark:(NSString *)bookId withPage:(NSDictionary *)pageDictionary{
    NSMutableDictionary *returnObject =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:bookId]];
    NSMutableArray *bookmarksArray=[NSMutableArray arrayWithArray:[returnObject objectForKey:BOOKMARK]];
    for (int i=0; i<[bookmarksArray count]; i++) {
        if ([[[bookmarksArray objectAtIndex:i] objectForKey:CHAPTER_KEY] isEqual:[pageDictionary objectForKey:CHAPTER_KEY]] && [[[bookmarksArray objectAtIndex:i] objectForKey:PAGE_KEY] isEqual:[pageDictionary objectForKey:PAGE_KEY]]) {
            [bookmarksArray removeObjectAtIndex:i];
            [returnObject addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:bookmarksArray,BOOKMARK, nil]];
            [self addObject:returnObject withKey:bookId ifKeyNotExists:NO];
        }
    }
    
}

+(void)setCSSIDforBookID:(NSString *)bookID withCSSID:(NSString *)cssID{
    NSMutableDictionary *returnObject =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:bookID]];
    NSDictionary *styleDict=[NSDictionary dictionaryWithObjectsAndKeys:cssID,CSSID, nil];
    [returnObject addEntriesFromDictionary:styleDict];
    [self addObject:returnObject withKey:bookID ifKeyNotExists:NO];

}
+ (NSString *)getCSSIDforBookID:(NSString *)bookId{
    NSString *styleID=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:bookId] objectForKey:CSSID]];
    if (styleID) {
        return styleID;
    }
    return nil;
}
+ (void)setLastPageOpened:(NSString *)bookId withPage:(NSDictionary *)pageDictionary{
    NSMutableDictionary *returnObject =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:bookId]];
    NSDictionary *lastPageDict=[NSDictionary dictionaryWithObjectsAndKeys:pageDictionary,LAST_PAGE, nil];
    [returnObject addEntriesFromDictionary:lastPageDict];
    [self addObject:returnObject withKey:bookId ifKeyNotExists:NO];
}
+ (NSDictionary *)getLastPageOpened:(NSString *)bookId{
    NSDictionary *lastPageDict=[NSDictionary dictionaryWithDictionary:[[[NSUserDefaults standardUserDefaults] objectForKey:bookId] objectForKey:LAST_PAGE]];
   // NSLog(@"%@",lastPageDict);
    if ([lastPageDict count]>0) {
        return lastPageDict;
    }
    return nil;
}
+ (void)deleteItemsAtPath:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:folder error:NULL];
}

+ (void)deleteItemsAtPathFromCache:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:folder error:NULL];
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
+ (NSDictionary *)getDictionaryWithKey:(NSString *)dictKey{
    NSDictionary *userData = nil;
	
	if (dictKey != nil) {
		NSObject *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:dictKey];
		if ([returnObject isKindOfClass:[NSDictionary class]]) {
			userData = (NSDictionary *)returnObject;
		}
	}
	
	return userData;
}

+(NSArray *)getNumOfPages:(NSString *)bookID withFontSize:(int)fontSize{
   // bookID=@"test";
    NSArray *numberOFPages=[NSArray array];
    if (bookID !=nil && UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        NSDictionary *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:bookID];
        numberOFPages=[returnObject objectForKey:[NSString stringWithFormat:@"%d",fontSize]];
    }
    return numberOFPages;
}
/*
        
        if (fontSize==LEVEL1 && [returnObject objectForKey:PORT_LEVEL1] !=nil) {
            numberOFPages=[returnObject objectForKey:PORT_LEVEL1];
            return numberOFPages;
        }else if (fontSize==LEVEL2 && [returnObject objectForKey:PORT_LEVEL2] !=nil) {
            numberOFPages=[returnObject objectForKey:PORT_LEVEL2];
            return numberOFPages;
        }
    }else if (bookID !=nil && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        NSDictionary *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:bookID];
        if (fontSize==LEVEL1 && [returnObject objectForKey:LAND_LEVEL1] !=nil) {
            numberOFPages=[returnObject objectForKey:LAND_LEVEL1];
            return numberOFPages;
        }else if (fontSize==LEVEL2 && [returnObject objectForKey:LAND_LEVEL2] !=nil) {
            numberOFPages=[returnObject objectForKey:LAND_LEVEL2];
            return numberOFPages;
        }
    }
    return numberOFPages;
}
 */

+(void)setNumOfPages:(NSString *)bookID withPagesNumbers:(NSArray *)numberOFPages withFontSize:(int)fontSize{
   // bookID=@"test";
    NSMutableDictionary *returnObject=[NSMutableDictionary  dictionary];
    if (bookID !=nil)  {
        if ([self checkForKey:bookID]) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:bookID] isKindOfClass:[NSMutableDictionary class]]) {
                returnObject =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:bookID]];
            }
        }
        [returnObject addEntriesFromDictionary:[NSDictionary dictionaryWithObject:numberOFPages
                                                                           forKey:[NSString stringWithFormat:@"%d",fontSize]]];
        [self addObject:returnObject withKey:bookID ifKeyNotExists:NO];
    }
}
        /*
        if (fontSize==LEVEL1) {
            [returnObject addEntriesFromDictionary:[NSDictionary dictionaryWithObject:numberOFPages
                                                                               forKey:PORT_LEVEL1]];
        }else if (fontSize==LEVEL2) {
            [returnObject addEntriesFromDictionary:[NSDictionary dictionaryWithObject:numberOFPages forKey:PORT_LEVEL2]];
        }
       //  NSLog(@"dict=%@",returnObject);
    }else if (bookID !=nil && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:bookID] isKindOfClass:[NSMutableDictionary class]]) {
             returnObject =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:bookID]];
        }

        if (fontSize==LEVEL1) {
            [returnObject addEntriesFromDictionary:[NSDictionary dictionaryWithObject:numberOFPages forKey:LAND_LEVEL1]];
        }else if (fontSize==LEVEL2) {
            [returnObject addEntriesFromDictionary:[NSDictionary dictionaryWithObject:numberOFPages forKey:LAND_LEVEL2]];
        }
    }
    */
    
   // [returnObject release];

+(void)setBookmark:(NSString *)bookId withChapterNumber:(int)chapterNum withPageNumber:(int)pageNum{
    if ([self checkForKey:bookId]) {
       NSMutableDictionary *returnObject =[NSMutableDictionary dictionaryWithDictionary:[[[NSUserDefaults standardUserDefaults] objectForKey:bookId] objectForKey:BOOKMARK]];
        if (returnObject) {
            
        } 
    }
    
}
+ (BOOL)checkForKey:(NSString *)checkKey{

	BOOL checkResult = YES;
	NSObject *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:checkKey];
	if (returnObject == nil) {
		checkResult = NO;
	}
	
	return checkResult;
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

+ (NSData *)getDataWithName:(NSString *)dataName inRelativePath:(NSString *)path inDocument:(BOOL)inDocument{
    NSArray *documentPaths =nil;
    if (inDocument) {
        documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    }else
        documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSString *dataPath = [folder stringByAppendingPathComponent:dataName];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	return [fm contentsAtPath:dataPath];
}
+ (NSString *)getStringWithKey:(NSString *)key{
	NSString *userData = nil;
	
	if (key != nil) {
		NSObject *returnObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
		if ([returnObject isKindOfClass:[NSString class]]) {
			userData = (NSString *)returnObject;
		}
	}
	
	return userData;
}
+(BOOL)isBookDwonloadedWithID:(NSString *)bookID{
    NSArray *downloadedBooks=[self getArrayWithKey:DOWNLOADED_BOOKS];
    for (int index=0; index<[downloadedBooks count]; index++) {
        if ([[downloadedBooks objectAtIndex:index] isEqualToString:bookID]) {
            return YES;
        }
    }
    return NO;
}

+(void)addBookWithID:(NSString *)bookID{
     NSMutableArray *downloadedBooks=[NSMutableArray arrayWithArray:[self getArrayWithKey:DOWNLOADED_BOOKS]];
    [downloadedBooks addObject:bookID];
    [self addObject:downloadedBooks withKey:DOWNLOADED_BOOKS ifKeyNotExists:NO];
}
+(void)removeBookWithID:(NSString *)bookID{
     NSMutableArray *downloadedBooks=[NSMutableArray arrayWithArray:[self getArrayWithKey:DOWNLOADED_BOOKS]];
    for (int index=0; index<[downloadedBooks count]; index++) {
        if ([[downloadedBooks objectAtIndex:index] isEqualToString:bookID]) {
            [downloadedBooks removeObjectAtIndex:index];
            break;
        }
    }
    [self addObject:downloadedBooks withKey:DOWNLOADED_BOOKS ifKeyNotExists:NO];

}

+(void)addDownloadingBookWithID:(NSString *)bookID{
    NSMutableArray *downloadedBooks=[NSMutableArray arrayWithArray:[self getArrayWithKey:StillDOWNLOADED_BOOKS]];
    [downloadedBooks addObject:bookID];
    [self addObject:downloadedBooks withKey:StillDOWNLOADED_BOOKS ifKeyNotExists:NO];
}
+(void)removeDownloadingBookWithID:(NSString *)bookID{
    NSMutableArray *downloadedBooks=[NSMutableArray arrayWithArray:[self getArrayWithKey:StillDOWNLOADED_BOOKS]];
    for (int index=0; index<[downloadedBooks count]; index++) {
        if ([[downloadedBooks objectAtIndex:index] isEqualToString:bookID]) {
            [downloadedBooks removeObjectAtIndex:index];
            break;
        }
    }
    [self addObject:downloadedBooks withKey:StillDOWNLOADED_BOOKS ifKeyNotExists:NO];
    
}
+(BOOL)isBookInDwonloadingWithID:(NSString *)bookID{
    NSArray *downloadedBooks=[self getArrayWithKey:StillDOWNLOADED_BOOKS];
    for (int index=0; index<[downloadedBooks count]; index++) {
        if ([[downloadedBooks objectAtIndex:index] isEqualToString:bookID]) {
            return YES;
        }
    }
    return NO;
}

+(NSString *)getBadgesNumber{
    NSString *badgeNumber=[self getStringWithKey:BADGE];
    if (badgeNumber==nil) {
        badgeNumber=@"0";
    }
    badgeNumber=[NSString stringWithFormat:@"%d",badgeNumber.intValue+1];
    [self addObject:badgeNumber withKey:BADGE ifKeyNotExists:NO];
    return badgeNumber;
    
}

@end
