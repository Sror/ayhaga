

#import <Foundation/Foundation.h>


@interface SearchResult : NSObject {
    int chapterIndex;
    int hitIndex;
    int pageIndex;
    NSMutableString* neighboringText;
    NSString* originatingQuery;
}

@property int chapterIndex, pageIndex, hitIndex;
@property (nonatomic, retain) NSString *neighboringText, *originatingQuery;

- initWithChapterIndex:(int)theChapterIndex pageIndex:(int)thePageIndex hitIndex:(int)theHitIndex neighboringText:(NSString*)theNeighboringText originatingQuery:(NSString*)theOriginatingQuery;

@end
