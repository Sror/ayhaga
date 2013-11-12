//
//  HomeViewController.h
//  RefofDemo
//
//  Created by Mohamed Alaa El-Din on 11/6/13.
//  Copyright (c) 2013 Mohamed Alaa El-Din. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "LoginViewController.h"
#import "HorizontalTableCell.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HorizontaleTableCellDelegate, UIGestureRecognizerDelegate, DBRestClientDelegate>
{
    NSMutableArray *issuesFileNamesArray, *issuesFileUrlsArray, *issuesThumbinalArray, *reusableCells, *moreIssuesArray, *articlesStillDownloading, *files;
    
    int issuesCount, issuePagingIndex, sectionSize, count ;
    
    BOOL thereMoreIssues, shaking;
    
    NSString *issueName;
    
   // dispatch_queue_t DQueue ;
}

@property (retain, nonatomic) NSMutableArray *issuesFileNamesArray;
@property (retain, nonatomic) NSMutableArray *issuesFileUrlsArray;
@property (retain, nonatomic) NSMutableArray *issuesThumbinalArray;
@property (retain, nonatomic) NSMutableArray *reusableCells;
@property (retain, nonatomic) NSMutableArray *moreIssuesArray;
@property (retain, nonatomic) NSMutableArray *articlesStillDownloading;

@property (nonatomic, readonly) DBRestClient *restClient;

@property (retain, nonatomic) IBOutlet UITableView *mainTableView;

@property (retain, nonatomic) IBOutlet UIButton *loadMoreBtn;

@property (retain, nonatomic) IBOutlet UIView *indicatorView ;
@property (retain, nonatomic) IBOutlet UIView *indicatorBgView;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView ;

@property (retain, nonatomic) IBOutlet UILabel *refofLabel ;


- (IBAction)logout:(id)sender;

@end
