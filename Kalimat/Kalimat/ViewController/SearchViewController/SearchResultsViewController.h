

#import <UIKit/UIKit.h>
#import "EPubViewController.h"


@interface SearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate,UISearchBarDelegate> {
    UITableView* resultsTableView;
    NSMutableArray* results;
    EPubViewController* epubViewController;
    
    int currentChapterIndex;
    NSString* currentQuery;
    UIWebView* searchWebView;
    
    int currentSearchCount;
}

@property (nonatomic, retain) IBOutlet UITableView* resultsTableView;
@property (nonatomic, assign) EPubViewController* epubViewController;
@property (nonatomic, retain) NSMutableArray* results;
@property (nonatomic, retain) NSString* currentQuery;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) UIActivityIndicatorView *moreTweetActivityIndicator;
@property (retain, nonatomic) IBOutlet UIView *loadingView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (void) searchString:(NSString*)query;
-(CGRect)getWindowSize;
@end
