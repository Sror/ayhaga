//      //  CollectionViewController.h
//  Kalimat
//
//  Created by Staff on 4/21/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	category = 1,
	search
} ClassType;


@interface CollectionViewController : UIViewController <UISearchBarDelegate>
{
    NSMutableArray *booksArray;
    NSString *categoryId;
    NSMutableArray *reusableCells;
    ClassType classType;
    NSString *categoryName;
}
@property (retain, nonatomic) IBOutlet UITableView *collectionTableView;
@property (retain, nonatomic) NSMutableArray *booksArray;
@property (retain, nonatomic) NSString *categoryId;
@property (nonatomic, retain) NSMutableArray *reusableCells;
@property (assign) ClassType classType;
@property (retain, nonatomic) IBOutlet UISearchBar *bookSearchBar;
@property (retain, nonatomic) IBOutlet UIView *activityView;
@property (nonatomic, strong) NSString *categoryName;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (retain, nonatomic) IBOutlet UILabel *arrowLabel;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@end
