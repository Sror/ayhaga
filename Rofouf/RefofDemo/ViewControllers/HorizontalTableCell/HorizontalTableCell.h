//
//  HorizontalTableCell.h
//  Safahat Reader
//
//  Created by Marwa Aman on 8/22/13.
//  Copyright (c) 2013 Ahmed Aly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"



@protocol HorizontaleTableCellDelegate <NSObject>
@required
-(void) deleteCell;
-(void) shakeCell;
-(void) stopShake ;
-(void) updateListDelegate ;

@end

@interface HorizontalTableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource,ASIHTTPRequestDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    UITableView *_horizontalTableView;
    NSArray *issuesContents;
    
    UIAlertView *progressAlert;
    BOOL isLessThan4;
    
    ASINetworkQueue *networkQueue;
    ASINetworkQueue *networkQueueFetchSize;
    ASIHTTPRequest *requestFileSize;
    
    UIViewController *viewController;
    NSMutableArray *articlesArray;
//    NSMutableArray *articlesStillDownloading;

    

    NSString *issueName ;
    
    int sectionSize ; 
    
    
    id<HorizontaleTableCellDelegate> delegate;
    BOOL shaking ;
    
    BOOL isDeleted ;
}

@property (nonatomic, retain) UITableView *horizontalTableView;
@property (nonatomic, retain) NSArray *issuesContents;
@property (nonatomic, retain) UILabel *cellTitle;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) NSMutableArray *articlesArray;


//@property (retain, nonatomic) NSMutableArray * articlesStillDownloading;
@property (nonatomic, assign) id<HorizontaleTableCellDelegate> delegate;

-(void)shakeAnimation ;
-(void)stopShaking ;

- (IBAction)fetchFileSizeFinished:(ASIHTTPRequest *)request;

- (id)initWithIsLastCategory:(BOOL)isLastCategory;


@end
