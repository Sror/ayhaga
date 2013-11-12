//
//  BookmarkViewController.h
//  AePubReader
//
//  Created by Ahmed Aly on 8/7/12.
//
//

#import <UIKit/UIKit.h>
#import "EPubViewController.h"

@interface BookmarkViewController : UIViewController

@property(nonatomic, assign) EPubViewController* epubViewController;
@property(nonatomic,retain) NSArray *tableData;
@property(nonatomic,retain) NSArray *indexData;
@end
