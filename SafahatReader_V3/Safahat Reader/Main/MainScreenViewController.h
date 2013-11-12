//
//  MainScreenViewController.h
//  Safahat Reader
//
//  Created by Ahmed Aly on 12/4/12.
//  Copyright (c) 2012 Ahmed Aly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalTableCell.h"
//#define kiCloudNotification @"iCloudNotification"

@interface MainScreenViewController : UIViewController <UIWebViewDelegate,UIGestureRecognizerDelegate ,HorizontaleTableCellDelegate,UIScrollViewDelegate,UINavigationControllerDelegate>
{

    
    
    BOOL shaking ;
    BOOL validUntill;
    BOOL thereMoreIssues;
    BOOL isDeleted;
    
    NSMutableArray * issuesArray;
    NSMutableArray *reusableCells;
    NSMutableArray * moreIssuesArray;
    NSMutableArray *articlesStillDownloading;
    
    int issuesCount ;
    int issuePagingIndex ;
    int sectionSize ;

    float Version ;

    NSString *issueName;
    
    dispatch_queue_t DQueue ;
}


@property (retain, nonatomic) IBOutlet UILabel *safahatLabel ;

@property (retain, nonatomic) IBOutlet UIView *indicatorView ;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView ;
@property (retain, nonatomic) IBOutlet UIView *indicatorBgView;


@property (retain, nonatomic) IBOutlet UIButton *loadMoreBtn;


@property (retain, nonatomic) IBOutlet UITableView *collectionTableView;


@property (retain, nonatomic) NSMutableArray * articlesArray;
@property (retain, nonatomic) NSMutableArray * moreIssuesArray;
@property (retain, nonatomic) NSMutableArray * articlesStillDownloading;
@property (retain, nonatomic) NSMutableArray * issuesArray;
@property (nonatomic, retain) NSMutableArray * reusableCells;

@property (assign) BOOL validUntill;


-(IBAction)actionUpdatelist :(id)sender;

@end
