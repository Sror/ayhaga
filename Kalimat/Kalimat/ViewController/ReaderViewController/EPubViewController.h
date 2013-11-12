

#import <UIKit/UIKit.h>
#import "ZipArchive.h"
#import "EPub.h"
#import "Chapter.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "FontViewController.h"

@class SearchResultsViewController;
@class SearchResult;

@interface EPubViewController : UIViewController <UIWebViewDelegate, UISearchBarDelegate,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,FontDelegate> {
    
    UIToolbar *toolbar;
	UIWebView *webView;
    UIBarButtonItem* chapterListButton;
	UIBarButtonItem* decTextSizeButton;
	UIBarButtonItem* incTextSizeButton;
    UISlider* pageSlider;
    UILabel* currentPageLabel;
    UIProgressView *progressBar;
			
    int currentSpineIndex;
	int currentPageInSpineIndex;
	int pagesInCurrentSpineCount;
	int currentTextSize;
	int totalPagesCount;
    int ChapterIndex;
    int transitionIndex;
    int background_Color_Tag;
    int bookIndex;
    float progressRate;
    
    BOOL epubLoaded;
    BOOL paginating;
    BOOL searching;
    BOOL isCashed;
    BOOL isBarsHidden;
    
    UIPopoverController* chaptersPopover;
    UIPopoverController* searchResultsPopover;
    UIPopoverController* bookmarksPopover;
    UIPopoverController* fontPopover;

    EPub* loadedEpub;
    SearchResultsViewController* searchResViewController;
    SearchResult* currentSearchResult;
    
    NSString *bookId;
    NSString *filePath;
    NSString *bgColor;
    
    NSMutableArray *chaptersArray;
  
    NSInvocationOperation *loadBookOperation;
    NSOperationQueue *queue;
    
    UIView *headerView;
    UIView *footerView;
    IBOutlet UIView *indicatorView;
    IBOutlet UIActivityIndicatorView *indicatorProgress;
    BOOL isFootnotePressed;
    NSMutableArray *usageData ;
    NSDate *startTime ;
    NSDate *endTime ;
}
@property (retain, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (retain, nonatomic) IBOutlet UISearchBar *bookSearchBar;
@property (retain, nonatomic) IBOutlet UIToolbar *toolbar;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *chapterListButton;

@property (retain, nonatomic) IBOutlet UISlider *pageSlider;
@property (retain, nonatomic) IBOutlet UILabel *currentPageLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;
@property (retain, nonatomic) IBOutlet UIButton *bookmarkResultButton;


@property (retain, nonatomic) IBOutlet UIButton *optionButton;
@property (retain, nonatomic) IBOutlet UIButton *indexButton;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UIWebView *chaptersWebview;
@property (retain, nonatomic) IBOutlet UIView *_backView;
@property (retain, nonatomic) UIPopoverController* bookmarksPopover;

@property (retain, nonatomic) IBOutlet UIButton *searchButton;
@property (retain, nonatomic) NSString *filePath;
@property (retain, nonatomic) NSString *bgColor;
@property (retain, nonatomic) NSMutableArray *chaptersArray;
@property (retain, nonatomic) SearchResult* currentSearchResult;
@property (nonatomic, assign) EPub* loadedEpub;
@property (retain, nonatomic)  NSString *bookId;

@property (assign) int currentTextSize;
@property BOOL searching;
@property (nonatomic) BOOL webViewLoaded;
@property (assign)int bookIndex;
@property (retain, nonatomic) IBOutlet UIView *imageView;
@property (retain, nonatomic) IBOutlet UIWebView *imageWebview;

- (IBAction) showChapterIndex:(id)sender;
- (IBAction) slidingStarted:(id)sender;
- (IBAction) slidingEnded:(id)sender;
- (id)initWithUrl:(NSURL*) epubURL withID:(NSString *)bookID;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult;
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex WithFontSize:(int)fontSize;
@end
