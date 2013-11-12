//
//  MyBookViewController.h
//  Kalimat
//
//  Created by Staff on 3/31/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MyBooksCell.h"

@interface MyBookViewController : UIViewController <MyBookCellDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    NSMutableArray *booksArray;
    int sectionSize ;
    BOOL shaking ;
    NSMutableArray *reusableCells;
    IBOutlet UILabel *arrowLabel ;
    IBOutlet UILabel *titleLabel ; 
}
@property (retain, nonatomic) NSMutableArray *booksArray;
//@property (retain, nonatomic) IBOutlet PSUICollectionView *booksCollectionView;
//@property (nonatomic, strong) IBOutlet PSUICollectionViewFlowLayout *customLayout;
@property (retain, nonatomic) IBOutlet UIView *activityView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (retain, nonatomic) IBOutlet UITableView *collectionTableView;
@property (nonatomic, retain) NSMutableArray *reusableCells;

@property (retain, nonatomic)  IBOutlet UILabel *arrowLabel ;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel ;

@end
