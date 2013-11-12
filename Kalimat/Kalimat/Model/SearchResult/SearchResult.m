

#import "SearchResult.h"


@implementation SearchResult

@synthesize pageIndex, chapterIndex, neighboringText, hitIndex, originatingQuery;

- initWithChapterIndex:(int)theChapterIndex pageIndex:(int)thePageIndex hitIndex:(int)theHitIndex neighboringText:(NSString*)theNeighboringText originatingQuery:(NSString*)theOriginatingQuery{
    if((self=[super init])){
        chapterIndex = theChapterIndex;
        pageIndex = thePageIndex;
        hitIndex = theHitIndex;
        
        self.neighboringText = [theNeighboringText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.neighboringText=[self.neighboringText stringByReplacingOccurrencesOfString:@"  " withString:@""];
        self.neighboringText = [self.neighboringText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.originatingQuery = theOriginatingQuery;
    }
    return self;
}

- (void)dealloc {
    [neighboringText release];
	[originatingQuery release];
    [super dealloc];
}
@end
