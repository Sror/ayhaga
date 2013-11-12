

#import <Foundation/Foundation.h>
#import "TouchXML.h"
		

@interface EPub : NSObject {
	NSArray* spineArray;
	NSString* epubFilePath;
    NSString *bookId;
}

@property(nonatomic, retain) NSArray* spineArray;
@property(nonatomic, retain) NSString *bookId;

- (id) initWithEPubPath:(NSString*)path;

+ (int)pathId;
+ (void)setPathId:(int)newPath;
- (NSArray *)getIndex;
@end
