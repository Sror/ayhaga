

#import <Foundation/Foundation.h>
@class Chapter;


@interface Chapter : NSObject {
    NSString* spinePath;
    NSString* title;
	NSString* text;
    int pageCount;
    int chapterIndex;
    int fontPercentSize;

}

@property (nonatomic, readonly) int chapterIndex, fontPercentSize;
@property (nonatomic, readonly) NSString *spinePath, *title, *text;
@property (nonatomic) int pageCount;

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex;

@end
