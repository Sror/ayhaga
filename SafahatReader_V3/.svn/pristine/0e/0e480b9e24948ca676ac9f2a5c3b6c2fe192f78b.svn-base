//
//  ViewController.h
//  WebScroll
//
//  Created by Marwa Aman on 11/19/12.
//  Copyright (c) 2012 Zein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController <UIWebViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UINavigationControllerDelegate>
{

    
    UIScrollView *scrollView ;
    
    NSMutableArray *webViewArray ;
    NSMutableArray *imgViewArray ;
    NSMutableArray *indexImgArray;
    
   
   
    NSArray *categoryArray ;
    NSString *issueName ;
   // NSString *year ;
    
    UIView *toolBar ;
    UIView *indexView ;
    
    
    BOOL ChangesRight ;
    BOOL ChangesLeft ;
    BOOL Begin ;
    int lastOffset ;
    int pageIndex;
    int start;
    int end;
    

    int refPage, currentPage;
    dispatch_queue_t DQueue ;
    int prevPage ;
    int indexPrevPage ;
    

 // usage
    
    
    NSMutableArray *usageData ;
    NSMutableDictionary *savedDict ;
    NSMutableArray *timerArray ;
  
  
    
    
    NSDate *startTime ;
    NSDate *endTime ; 
    BOOL articleAdded ;
    
}
@property(nonatomic)BOOL Begin ;
@property(nonatomic,retain) NSString *issueName ;
@property (nonatomic,retain) NSString *issueTitle ;
@property (nonatomic,retain) NSString *yearTitle ;
//@property(nonatomic,retain) NSString *year ;
@property(nonatomic,retain)  IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)  IBOutlet UIView *toolBar;
@property(nonatomic,retain)  IBOutlet UIView *indexView;
@property(nonatomic,retain) NSMutableArray *webViewArray ;
@property(nonatomic,retain) NSMutableArray *imgViewArray ;
@property(nonatomic,retain) NSArray *categoryArray ;
@property (retain, nonatomic) IBOutlet UIButton *homeButton;


-(IBAction)back:(id)sender;
@end
