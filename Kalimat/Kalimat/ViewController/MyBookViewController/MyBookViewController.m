//
//  MyBookViewController.m
//  Kalimat
//
//  Created by Staff on 3/31/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import "MyBookViewController.h"


#import "UserDefaults.h"
#import "Constants.h"
#import "EPubViewController.h"
#import "MyBooksCell.h"
#import "ArabicConverter.h"
#import "UsageData.h"
#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 0.5
#define kAnimationTranslateX 86
#define kAnimationTranslateY 119


@interface MyBookViewController ()

@end

@implementation MyBookViewController
@synthesize booksArray,reusableCells,arrowLabel,titleLabel;

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBooks) name:BOOKISDOWNLODED object:nil];
    
    //arrowLabel.frame = CGRectMake(717, 205, 20, 20) ;
    arrowLabel.font = [UIFont fontWithName:@"Hacen Casablanca Light" size:27];
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textColor=[UIColor colorWithRed:122.0/255 green:120.0/255 blue:5.0/255 alpha:1.0];
    arrowLabel.text=@"«";
    
    //titleLabel.frame = CGRectMake(521, 207, 200, 20);
    titleLabel.font = [UIFont fontWithName:@"Hacen Casablanca Light" size:18];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textAlignment=NSTextAlignmentRight;
    titleLabel.textColor=[UIColor whiteColor];
    ArabicConverter *converter = [[ArabicConverter alloc] init];
    
    if([UsageData getiOSVersion]<7){
        NSString* convertedString = [converter convertArabic:@"مكتبتي"];
        titleLabel.text = convertedString ;
    }else{
        NSString* convertedString = @"مكتبتي";
        titleLabel.text = convertedString ;
    }
    
    
    UITapGestureRecognizer *Tapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopShaking)];
    Tapped.numberOfTapsRequired = 2;
    Tapped.delegate = self;
    [self.view addGestureRecognizer:Tapped];
    
    NSArray *collSubviews =  self.collectionTableView.subviews;
    for (int i= 0 ; i< collSubviews.count  ; i++   )
    {
        if([[collSubviews objectAtIndex:i] isKindOfClass:[UIScrollView  class]])
            ( (UIScrollView *)[collSubviews objectAtIndex:i]).delegate = self ;
        
    }
    [converter release];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)showIndicator{
    
    self.activityView.hidden = NO ;
    [self.view bringSubviewToFront:self.activityView];
    [self.indicatorView startAnimating];
}
-(void)hideIndicator{
    self.activityView.hidden = YES ;
    [self.indicatorView stopAnimating];
}

-(void)refreshBooks{
    self.booksArray=[NSMutableArray arrayWithArray:[UserDefaults getArrayWithKey:DOWNLOADED_BOOKS]];
    [self getBooks];
    for (int i = 0; i < [self.reusableCells count]; i++)
    {
        MyBooksCell *cell=(MyBooksCell *)[self.reusableCells objectAtIndex:i];
        [cell.horizontalTableView reloadData];
    }
    [UserDefaults addObject:nil withKey:BADGE ifKeyNotExists:NO];
    if (shaking)
        [self performSelector:@selector(shakeCell) withObject:nil afterDelay:0.05];
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    // self.booksCollectionView.contentSize=CGSizeMake(self.booksCollectionView.contentSize.width, self.booksCollectionView.contentSize.height+24);
    if (self.booksArray.count !=[[UserDefaults getArrayWithKey:DOWNLOADED_BOOKS] count]) {
        [self refreshBooks];
    }
    
    [self.view bringSubviewToFront:self.activityView];
    
    [UserDefaults addObject:nil withKey:BADGE ifKeyNotExists:NO];
    shaking = NO ;
    
    if([UsageData getiOSVersion] == 7)
    {
        self.tabBarController.tabBar .hidden = NO ;
        self.hidesBottomBarWhenPushed = NO ;
        self.tabBarController.tabBar.backgroundColor = [UIColor blackColor];
    
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self stopShaking];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}




///////////////////////////////// Download Isuues//////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1)
    {
        [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"%@.epub",[self.booksArray objectAtIndex:alertView.tag]]];
        [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"%@c.jpg",[self.booksArray objectAtIndex:alertView.tag]]];
        [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"%@t.jpg",[self.booksArray objectAtIndex:alertView.tag]]];
        [UserDefaults removeBookWithID:[self.booksArray objectAtIndex:alertView.tag]];
        self.booksArray=[NSMutableArray arrayWithArray:[UserDefaults getArrayWithKey:DOWNLOADED_BOOKS]];
        [self performSelector:@selector(shakeAnimation) withObject:nil afterDelay:0.05];
        
        
    }
}

//////////////////////////////
-(void)getBooks{
    
    
    
    self.reusableCells=[NSMutableArray array];
    
    if ([self.booksArray count] == 1)
    {
        MyBooksCell *cell = [[MyBooksCell alloc] initWithIsLastCategory:NO];
        cell.viewController=self;
        cell.horizontalTableView.contentOffset=CGPointMake(0, [self.booksArray count]*189);
        cell.booksArray=[NSArray arrayWithArray:booksArray];
        cell.delegate = self ;
        [self.reusableCells addObject:cell];
        [cell release];
    }
    else{
        for (int i = 1; i <= [self.booksArray count]; i++)
        {
            i--;
            BOOL isStart=YES;
            MyBooksCell *cell = [[MyBooksCell alloc] initWithIsLastCategory:NO];
            cell.viewController=self;
            cell.horizontalTableView.contentOffset=CGPointMake(0, [self.booksArray count]*189);
            NSMutableArray *rowBooks=[NSMutableArray array];
            while (i % 4 !=0 || isStart) {
                isStart=NO;
                if (i < [self.booksArray count]) {
                    [rowBooks addObject:[self.booksArray objectAtIndex:i]];
                    i++;
                }else
                    break;
            }
            
            cell.booksArray=[NSArray arrayWithArray:rowBooks];
            
            cell.delegate = self ;
            [self.reusableCells addObject:cell];
            [cell release];
            
        }
    }
    
    [NSThread detachNewThreadSelector:@selector(hideIndicator) toTarget:self withObject:nil];
    [self.collectionTableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBooksCell *cell = [self.reusableCells objectAtIndex:indexPath.section];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor blackColor]];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //   NSLog(@"%d",[self.reusableCells count]);
    return [self.reusableCells count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // NSLog(@"%d",[self.booksArray count]);
    
    int sections=[self.booksArray count]/4;
    if( ([self.booksArray count] % 4)!= 0 )
        sections++;
    if (indexPath.section == sections-1) {
        return 235;
    }
    return 235;
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(shaking)
        [self shakeCell];
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(shaking)
        [self shakeCell];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(shaking)
        [self shakeCell];
}

#pragma delegate delete cell

-(void)shakeCell
{
    
    // NSLog(@"Delegate method %d ",reusableCells.count);
    
    shaking = YES ;
    for (int section = 0 ; section < reusableCells.count ; section ++)
    {
        [(MyBooksCell *)[self.reusableCells  objectAtIndex:section] shakeAnimation];
        
    }
}

-(void)stopShake
{
    [self stopShaking];
}

-(void)deleteCell
{
    [self refreshBooks];
    
    
    [self performSelector:@selector(shakeCell) withObject:nil afterDelay:0.05];
}



-(void)stopShaking
{
    
    shaking = NO ;
    for (int section = 0 ; section < reusableCells.count ; section ++)
    {
        [(MyBooksCell *)[self.reusableCells  objectAtIndex:section] stopShaking];
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [_activityView release];
    [_indicatorView release];
    [_collectionTableView release];
    [super dealloc];
}
@end
