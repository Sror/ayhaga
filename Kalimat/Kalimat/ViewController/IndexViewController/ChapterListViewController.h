

#import <UIKit/UIKit.h>
#import "EPubViewController.h"

@interface ChapterListViewController : UITableViewController {
    EPubViewController* epubViewController;
    NSArray *tableData;
}

@property(nonatomic, assign) EPubViewController* epubViewController;
@property(nonatomic,retain) NSArray *tableData;
@end
