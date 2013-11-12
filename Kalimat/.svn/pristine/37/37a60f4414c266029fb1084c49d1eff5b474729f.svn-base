//
//  FourBooksCell.h
//  Kalimat
//
//  Created by Staff on 4/21/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface FourBooksCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource,ASIHTTPRequestDelegate>
{
    UITableView *_horizontalTableView;
    NSArray *booksArray;
    BOOL isLessThan4;
    
    ASINetworkQueue *networkQueue;
    ASINetworkQueue *networkQueueFetchSize;
    ASIHTTPRequest *requestFileSize;
    NSString *styleUrl;
    UIViewController *viewController;
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
@property (assign) int categoryIndex;
- (IBAction)fetchFileSizeFinished:(ASIHTTPRequest *)request;
- (id)initWithIsLastCategory:(BOOL)isLastCategory withBook:(NSArray *)books;
@end
