//
//  MainViewController.m
//  Kalimat
//
//  Created by Staff on 3/24/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import "MainViewController.h"
#import "NetworkService.h"
#import "UIImageView+AFNetworking.h"
#import "HorizontalTableCell.h"
#import "Constants.h"
#import "CollectionViewController.h"
#import "UserDefaults.h"
#import "UnvalidViewController.h"
#import "UIDdocument.h"
#import "UsageData.h"
@interface MainViewController ()

@end

#define CATEGORIES @"categories"



@implementation MainViewController
@synthesize categoriesArray,reusableCells,selectedCategoryIndex,booksInDownloading,token,htmlMessage,doc= _doc,query=_query;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudIDChanged) name:AddDeviceNotification object:nil];
    [[UsageData getObject] setNotificationType:AddDevice] ;
    [[UsageData getObject] getiCloudID];

    [self.startIndicator startAnimating];
    if (![self isAppValid]) {
        UnvalidViewController *viewController = [[UnvalidViewController alloc] init];
        viewController.html=self.htmlMessage;
        [self presentModalViewController:viewController animated:YES];
        [viewController release];
        
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBooks) name:BOOKISDOWNLODED object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewBooks) name:UPDATEBOOKS object:nil];
        [NSThread detachNewThreadSelector:@selector(getScreenData) toTarget:self withObject:nil];
        self.reusableCells=[NSMutableArray array];
    }
    
   // [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
  //  [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    

    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.activityView.hidden = YES ;
    [self.indicatorView stopAnimating];
    [self reload];
    
    if ([UserDefaults getStringWithKey:ISNEWBOOKS]) {
        [self getNewBooks];
    }
   // [self usageTask];
    //[NSThread detachNewThreadSelector:@selector(usageTask) toTarget:self withObject:nil];
    
    
    // [self.categoryTableView reloadS];
    
    if([UsageData getiOSVersion] == 7)
    {
        self.tabBarController.tabBar .hidden = NO ;
        self.hidesBottomBarWhenPushed = NO ;
        self.tabBarController.tabBar.backgroundColor = [UIColor blackColor];
    }
}


////////////////////////////////////////////
-(void)getNewBooks{
    self.startIndicator.hidden=YES;
    [self.startIndicator stopAnimating];
    [NSThread detachNewThreadSelector:@selector(showIndicator) toTarget:self withObject:nil];
    [self getScreenData];
    //[NSThread detachNewThreadSelector:@selector(getScreenData) toTarget:self withObject:nil];
    
}
-(BOOL)isAppValid{
    NSDictionary *versionDict=nil;
    if ([[NetworkService getObject] checkInternetWithData]) {
        versionDict=[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andWithoutBaseURL:[NSString stringWithFormat:@"http://api.hindawi.org/v1/app/%@/status/ipad/",APP_ID]];
        [UserDefaults addObject:versionDict withKey:APP_STATUS ifKeyNotExists:NO];
    }else
        versionDict=[UserDefaults getDictionaryWithKey:APP_STATUS];
    
    if (!versionDict) {
        return YES;
        
    }else{
        NSString *statusId=[[versionDict objectForKey:@"validation"] objectForKey:@"id"];
        switch (statusId.intValue) {
                
            case 1:   // valid
                return YES;
                break;
            case 2:  // unvalid
                self.htmlMessage=[[versionDict objectForKey:@"validation"] objectForKey:@"message"];
                return NO;
                break;
            
        }
    }
    return YES;
    
}
-(IBAction)refreshClicked{
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
}
-(void)refreshBooks{
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
}
-(void)reload{
    for (int i = 0; i < [self.reusableCells count]; i++)
    {
        HorizontalTableCell *cell=(HorizontalTableCell *)[self.reusableCells objectAtIndex:i];
       // id currentBook=[[[self.categoriesArray objectAtIndex:i] objectForKey:@"books"] objectForKey:@"book"];
      //  if ([currentBook isKindOfClass:[NSArray class]]) {
      //      cell.booksArray=[[[self.categoriesArray objectAtIndex:i] objectForKey:@"books"] objectForKey:@"book"];
     //   }else
      //      cell.booksArray=[NSArray arrayWithObject:[[[self.categoriesArray objectAtIndex:i] objectForKey:@"books"] objectForKey:@"book"]];
        [cell.horizontalTableView reloadData];
    }
}
-(void)iCloudIDChanged
{
    /*
     NSLog(@"iCLoud %@",[[UserDefaults getDictionaryWithKey:@"userID"] objectForKey:@"userID"]) ;
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"iCLoud %@",[[UserDefaults getDictionaryWithKey:@"userID"] objectForKey:@"userID"]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] ;
     [alert show];
     */
    
    
    [self addDeviceToServer];
    //  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addDeviceToServer) userInfo:nil repeats:NO];
    
}
-(void)addDeviceToServer{
    
    
    
    if ([NetworkService getObject].connected) {
        
        
        
        NSMutableDictionary *devcieDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UsageData getVendorID],@"vendor" ,[UsageData getDeviceType],@"devicetype", nil];  //
        
        [devcieDictionary setObject:[UsageData getOSVersion] forKey:@"iosversion"];
        if(![NO_ID isEqualToString:[[UserDefaults getDictionaryWithKey:@"userID"] objectForKey:@"userID"] ])
        {
            [ devcieDictionary setObject:[[UserDefaults getDictionaryWithKey:@"userID"] objectForKey:@"userID"] forKey:@"icloud"];
        }
        
        if([UserDefaults getDictionaryWithKey:@"token"] )
        {
            [ devcieDictionary setObject:[[UserDefaults getDictionaryWithKey:@"token"] objectForKey:@"token"]  forKey:@"token"];
        }
        
        
        
        
        
        
        NSDictionary *Response =   [NetworkService getDataInDictionaryWithBody:devcieDictionary methodIsPost:YES andWithoutBaseURL:@"http://beta.api.hindawi.org/v1/device.add/9/1/"];
        
        NSLog(@"%@",devcieDictionary);
        
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"data %@", devcieDictionary] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] ;
         [alert show];
         
         
         UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"data %@", Response] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] ;
         [alert2 show];
         */
    }
}
-(void)sendTokenToServer{
    
    if ([NetworkService getObject].connected) {
        [NetworkService getDataInDictionaryWithBody:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",token],@"token", nil] methodIsPost:YES andWithoutBaseURL:[NSString stringWithFormat:@"http://api.hindawi.org/v1/device.add/%@/",APP_ID]];
    }
}

-(void)getScreenData{
    NSDictionary *categoriesDict=nil;
    if ([[NetworkService getObject] checkInternetWithData]){
        categoriesDict=[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"list/categories/books/%@/fields/cover.1536x2048,thumb.304x406,title/",API_TYPE]];
        [UserDefaults addObject:categoriesDict withKey:CATEGORIES ifKeyNotExists:NO];
    }
    else
        categoriesDict=[UserDefaults getDictionaryWithKey:CATEGORIES];
    
    if (!categoriesDict) {
        
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
        self.startIndicator.hidden=YES;
        [self.startIndicator stopAnimating];
        return;
    }else{
        self.reusableCells=[NSMutableArray array];
    }
    
    id object =[[[categoriesDict objectForKey:@"list"] objectForKey:@"categories"] objectForKey:@"category.item"];
    if ([object isKindOfClass:[NSDictionary class]]) {
        self.categoriesArray=[NSMutableArray arrayWithObject:object];
    }else
        self.categoriesArray=[NSMutableArray arrayWithArray:object];
    
    for (int i = 0; i < [self.categoriesArray count]; i++)
    {
        BOOL isLast=NO;
        if (i== [self.categoriesArray count]-1) {
            isLast=YES;
        }
        id currentBook=[[[self.categoriesArray objectAtIndex:i] objectForKey:@"books"] objectForKey:@"book"];
        NSMutableArray *books=nil;
        if ([currentBook isKindOfClass:[NSArray class]]) {
            books=[[[self.categoriesArray objectAtIndex:i] objectForKey:@"books"] objectForKey:@"book"];
        }else
            books=[NSMutableArray arrayWithObject:[[[self.categoriesArray objectAtIndex:i] objectForKey:@"books"] objectForKey:@"book"]];

        NSMutableArray * reverseArray = [NSMutableArray arrayWithCapacity:[books count]];
        
        for (id element in [books reverseObjectEnumerator]) {
            [reverseArray addObject:element];
        }

        HorizontalTableCell *cell = [[HorizontalTableCell alloc] initWithIsLastCategory:isLast withBook:reverseArray];
        cell.viewController=self;
        cell.styleUrl=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.url"];
        cell.CSSId=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"];
        cell.horizontalTableView.contentOffset=CGPointMake(0, [self.categoriesArray count]*189);
        cell.categoryIndex=i;
        cell.categoryName=[[self.categoriesArray objectAtIndex:i] objectForKey:@"name"];
        [self.reusableCells addObject:cell];
        
        [cell release];
    }
    [self refreshBooks];
    [self.categoryTableView reloadData];
    
    self.startIndicator.hidden=YES;
   //  [NSThread detachNewThreadSelector:@selector(hideIndicator) toTarget:self withObject:nil];
    [self.startIndicator stopAnimating];
    [UserDefaults addObject:nil withKey:ISNEWBOOKS ifKeyNotExists:NO];
    
    // NSLog(@"%@",categoriesArray);
    
}
-(void)showAlert{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"معذرة لا يمكنك تحميل الصفحة في الوقت الحالي؛ نظرًا لتعذر الاتصال بالإنترنت" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
}
-(void)showIndicator{
    // [self.activityView bringSubviewToFront:self.view];
    self.activityView.hidden = NO ;
    [self.indicatorView startAnimating];
}
-(void)hideIndicator{
    self.activityView.hidden = YES ;
    [self.indicatorView stopAnimating];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HorizontalTableCell *cell = [self.reusableCells objectAtIndex:indexPath.section];
    //[cell.horizontalTableView reloadData];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.reusableCells count];
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 UIView *titleView = nil;
 
 titleView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 25)] autorelease];
 titleView.backgroundColor=[UIColor clearColor];
 // UIImageView *bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(24, 0, 722, 33)];
 // [bgImageView setImage:[UIImage imageNamed:@"white_bar.png"]];
 
 
 UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(619, 0, 125, 25)];
 titleLabel.backgroundColor=[UIColor clearColor];
 titleLabel.font=[UIFont boldSystemFontOfSize:18];
 titleLabel.textAlignment=NSTextAlignmentRight;
 titleLabel.text=[[self.categoriesArray objectAtIndex:section] objectForKey:@"name"];
 
 UIButton *seeMoreButton=[UIButton buttonWithType:UIButtonTypeCustom];
 
 seeMoreButton.tag= [[[self.categoriesArray objectAtIndex:section] objectForKey:@"item.number"] intValue];
 [seeMoreButton setTitle:@"مشاهدة الكل" forState:UIControlStateNormal];
 seeMoreButton.frame=CGRectMake(24, 0, 95, 25);
 //  seeMoreButton.titleLabel.textAlignment=NSTextAlignmentRight;
 seeMoreButton.titleLabel.font=[UIFont boldSystemFontOfSize:18];
 [seeMoreButton setTitleColor:[UIColor colorWithRed:122.0/255 green:120.0/255 blue:5.0/255 alpha:1.0] forState:UIControlStateNormal];
 [seeMoreButton setTitleColor:[UIColor colorWithRed:50.0/255 green:100.0/255 blue:5.0/255 alpha:1.0] forState:UIControlStateHighlighted];
 [seeMoreButton addTarget:self action:@selector(openCategory:) forControlEvents:UIControlEventTouchUpInside];
 //[titleView addSubview:bgImageView];
 [titleView addSubview:seeMoreButton];
 [titleView addSubview:titleLabel];
 
 
 [titleLabel release];
 //[bgImageView release];
 
 return titleView;
 }
 
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section !=0) {
        return 32;
    }
    return 0;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)] autorelease];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == [self.categoriesArray count]-1) {
        return 281;
    }
    return 273;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor blackColor]];

}

-(void)openCategory:(UIButton *)sender{
    
    [NSThread detachNewThreadSelector:@selector(showIndicator) toTarget:self withObject:nil];
    CollectionViewController *categoryBooksViewController2=[[CollectionViewController alloc] init];
    categoryBooksViewController2.categoryId=[[self.categoriesArray objectAtIndex:sender.tag] objectForKey:@"item.number"];
    categoryBooksViewController2.categoryName=[[self.categoriesArray objectAtIndex:sender.tag] objectForKey:@"name"];
    categoryBooksViewController2.classType=category;
    [self.navigationController pushViewController:categoryBooksViewController2 animated:YES];
  //  [NSThread detachNewThreadSelector:@selector(hideIndicator) toTarget:self withObject:nil];
    [categoryBooksViewController2 autorelease];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_activityView release];
    [_indicatorView release];
    [_categoryTableView release];
    [_startIndicator release];
    [_logoImageView release];
    [super dealloc];
}
@end
