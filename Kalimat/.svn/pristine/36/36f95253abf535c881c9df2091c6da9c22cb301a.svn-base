

#import "Chapter.h"


@implementation Chapter 

@synthesize  chapterIndex, title, pageCount, spinePath, text, fontPercentSize;

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex{
    if((self=[super init])){
        spinePath = [theSpinePath retain];
        title = [theTitle retain];
        chapterIndex = theIndex;

		NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:theSpinePath]] encoding:NSUTF8StringEncoding];
		text = [[html stringByConvertingHTMLToPlainText] retain];
		[html release];
    }
    return self;
}

- (void)dealloc {
    [title release];
	[spinePath release];
	[text release];
    [super dealloc];
}


@end
