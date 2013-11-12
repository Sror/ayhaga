//
//  MainViewController.h
//  Kalimat
//
//  Created by Staff on 3/24/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDdocument.h"

#define kFILENAME @"icloudDocument.dox"
@interface MainViewController : UIViewController
{
    NSArray *categoriesArray;
    NSMutableArray *reusableCells;
    int selectedCategoryIndex;
    NSMutableArray *booksInDownloading;
    NSData *token;
}
@property(retain,nonatomic) NSArray *categoriesArray;
@property (retain, nonatomic) IBOutlet UIView *activityView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) NSMutableArray *reusableCells;
@property (retain, nonatomic) IBOutlet UITableView *categoryTableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *startIndicator;
@property (nonatomic, retain) NSMutableArray *booksInDownloading;
@property(assign)int selectedCategoryIndex;
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;
@property (retain, nonatomic) NSData *token;
@property (retain, nonatomic) NSString * htmlMessage;

@property (strong) UIDdocument * doc;
@property (strong) NSMetadataQuery *query;

-(void)showIndicator;
@end
