


#import "HorizontalTableCell.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface HorizontalTableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource,ASIHTTPRequestDelegate>
{
    UITableView *_horizontalTableView;
    NSArray *booksArray;
    BOOL isLessThan4;
    
    ASINetworkQueue *networkQueue;
    ASINetworkQueue *networkQueueFetchSize;
    ASIHTTPRequest *requestFileSize;
    
    UIViewController *viewController;
    NSMutableArray *booksInDownloading;
    
    NSString *categoryName;
     NSString *categoryID;
    
    
    UILabel *titleLabel;
    UIButton *seeMoreButton;
    
    int categoryIndex;
    unsigned long long totalBytesReceived;
   NSString *styleUrl;
    NSString *CSSId;
}

@property (nonatomic, retain) UITableView *horizontalTableView;
@property (nonatomic, retain) NSArray *booksArray;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) NSMutableArray *booksInDownloading;
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) NSString *categoryID;
@property (nonatomic, retain) NSString *styleUrl;
@property (nonatomic, retain) NSString *CSSId;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *seeMoreButton;
@property (assign) int categoryIndex;
- (IBAction)fetchFileSizeFinished:(ASIHTTPRequest *)request;

- (id)initWithIsLastCategory:(BOOL)isLastCategory withBook:(NSArray *)books;
@end
