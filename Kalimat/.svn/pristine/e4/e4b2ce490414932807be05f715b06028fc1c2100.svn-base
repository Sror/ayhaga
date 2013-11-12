//
//  MyBooksCell.h
//  Kalimat
//
//  Created by Staff on 4/28/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyBookCellDelegate <NSObject>
@required
-(void) deleteCell;
-(void) shakeCell;
-(void) stopShake ; 

@end

@interface MyBooksCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate ,UIScrollViewDelegate>
{
    UITableView *horizontalTableView;
    NSArray *booksArray;
    UIViewController *viewController;
    BOOL isLessThan4;
    
    BOOL shaking ;
    
    id<MyBookCellDelegate> delegate;

}

@property (nonatomic, assign) id<MyBookCellDelegate> delegate;
@property (nonatomic, retain) UITableView *horizontalTableView;
@property (nonatomic, retain) NSArray *booksArray;
@property (nonatomic, retain) UIViewController *viewController;
- (id)initWithIsLastCategory:(BOOL)isLastCategory;

-(void)shakeAnimation ;
-(void)stopShaking ; 

@end


