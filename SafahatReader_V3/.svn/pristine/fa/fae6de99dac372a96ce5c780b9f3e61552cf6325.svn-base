//
//  MainScreenViewController.m
//  Safahat Reader
//
//  Created by Ahmed Aly on 12/4/12.
//  Copyright (c) 2012 Ahmed Aly. All rights reserved.
//

#import "MainScreenViewController.h"

#import "XMLReader.h"
#import "ArticleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "NetworkService.h"
#import "CacheManager.h"
#import "UserDefaults.h"
#import "CustomWebView.h"
#import "UIDevice.h"
#import <AdSupport/AdSupport.h>
#import "ArabicConverter.h"
#import "UsageData.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 0.5
#define kAnimationTranslateX 1.0
#define kAnimationTranslateY 1.0

@implementation MainScreenViewController


@synthesize issuesArray,moreIssuesArray,reusableCells;
@synthesize articlesStillDownloading,articlesArray,loadMoreBtn,validUntill,indicatorView,activityView;
@synthesize safahatLabel ;
//@synthesize token ;



- (void)viewDidLoad
{
    [UserDefaults addObject:@"0" withKey:Downlaod_Count ifKeyNotExists:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDeviceToServer) name:AddDeviceNotification object:nil];
    [[UsageData getObject] setNotificationType:AddDevice] ;
    [[UsageData getObject] getiCloudID];
    
    
    // Safahaat label
    ArabicConverter *converter = [[ArabicConverter alloc] init] ;
    safahatLabel.text = [converter convertArabic:@"صفحات"];
    
    
    //NEW Issue Added
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateList) name:UPDATE_LIST object:nil];
    
    
    // Remove shake animation
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopShaking)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    // Find version
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    Version = [[vComp objectAtIndex:0] floatValue];
    
    self.navigationController.navigationBar.hidden = YES ;
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [loadMoreBtn.layer setBorderColor: [[UIColor colorWithRed:165.0/255 green:165.0/255 blue:165.0/255 alpha:1] CGColor]];
    [loadMoreBtn.layer setBorderWidth:1.0];
    
    
    self.issuesArray = [NSMutableArray array];
    self.articlesStillDownloading=[NSMutableArray array];
    
    
    issuesCount = 0 ;
    issuePagingIndex = 1 ;
    
    
    if([UIDevice deviceType]== iPad||[UIDevice deviceType] == iPadRetina)
    {
        safahatLabel.font =  [UIFont fontWithName:Font size:72];
        sectionSize = 4 ;
        
    }
    
    else if([UIDevice deviceType]== iPhone  || [UIDevice deviceType] == iPhoneRetina)
    {
        safahatLabel.font =  [UIFont fontWithName:Font size:30];
        sectionSize = 2 ;
        loadMoreBtn.frame = CGRectMake(65, 440, 190, 40);
        
    }
    
    else if( [UIDevice deviceType]== iPhone5)
    {
        safahatLabel.font =  [UIFont fontWithName:Font size:30];
        sectionSize = 2 ;
        loadMoreBtn.frame = CGRectMake(65, 528, 190, 40);
    
    }
    
    
    
    
    [self getIssues:issuePagingIndex withPageSize:1000];
    
    [self.view bringSubviewToFront:indicatorView];
    indicatorView.hidden = YES ;
    
    
    UITapGestureRecognizer *Tapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopShaking)];
    Tapped.numberOfTapsRequired = 2;
    Tapped.delegate = self;
    [self.view addGestureRecognizer:Tapped];
    
    
    [super viewDidLoad];
}





- (void)viewWillAppear:(BOOL)animated {
    //   issuesCount = 0 ;
    
    
    //  [_articlesCollectionView reloadData];
    
    if ([[UserDefaults getStringWithKey:NEW_ISSUE] integerValue] ==1)
    {
        [self UpdateList];
    }
}



-(void)addDeviceToServer{
    
    
    
    if ([NetworkService getObject].connected) {
        
        
        
        NSMutableDictionary *devcieDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UsageData getVendorID] , @"vendor",[UsageData getOSVersion],@"iosversion" ,[UsageData getDeviceType],@"devicetype", nil];
        
        
        if(![NO_ID isEqualToString:[[UserDefaults getDictionaryWithKey:@"userID"] objectForKey:@"userID"] ])
        {
            [ devcieDictionary setObject:[[UserDefaults getDictionaryWithKey:@"userID"] objectForKey:@"userID"] forKey:@"icloud"];
        }
        
        if([UserDefaults getDictionaryWithKey:@"token"] )
        {
            
            
            [ devcieDictionary setObject:[[UserDefaults getDictionaryWithKey:@"token"] objectForKey:@"token"]  forKey:@"token"];
        }
        
        [NetworkService getDataInDictionaryWithBody:devcieDictionary methodIsPost:YES andWithoutBaseURL:@"http://api.hindawi.org/v1/device.add/11/"];
        
        [self SendUsageToServer];
        
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"data %@", devcieDictionary] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] ;
         [alert show];
         
         
         UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"data %@", Response] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] ;
         [alert2 show];*/
        
    }
}


-(void)UpdateList
{
    [UserDefaults addObject:@"1" withKey:NEW_ISSUE ifKeyNotExists:NO];
    
    if([[UserDefaults getStringWithKey:Downlaod_Count] integerValue ] == 0)
    {
        [self showIndicator];
      [self.issuesArray removeAllObjects];
      [self getIssues:1 withPageSize:1000];
      [UserDefaults addObject:nil withKey:NEW_ISSUE ifKeyNotExists:NO];
    }

}


//////////////////////////////////////////////iCloud & Usage/////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewDidAppear:(BOOL)animated
{
    
    
}

////////////////////////////////////////////// iCloud /////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(IBAction)loadMoreIssues:(id)sender
{
    if (![[NetworkService getObject] checkInternetWithData]) {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"معذرة لا يمكنك تحميل المزيد من الأعداد في الوقت الحالي؛ نظرًا لتعذر الاتصال بالإنترنت" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return ;
    }
    
    [NSThread detachNewThreadSelector:@selector(showIndicator) toTarget:self withObject:nil];
    issuePagingIndex ++ ;
    
    if([UIDevice deviceType ]== iPad || [UIDevice deviceType]==iPadRetina)
        [self getIssues:issuePagingIndex withPageSize:8];
    else
        [self getIssues:issuePagingIndex withPageSize:4];
    
    
    
    int noOfSections  = self.issuesArray.count/sectionSize;
    if( ([self.issuesArray count] % sectionSize)!= 0 )
        noOfSections ++;
  
}


-(void)showIndicator{
    [self.view bringSubviewToFront:indicatorView];
    indicatorView.hidden = NO ;
    [activityView startAnimating];
    
    
}







-(void)downloadThumsIssues :(NSArray *)issueArray{
    for (int i=0; i<[issueArray count]; i++) {
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[[issueArray objectAtIndex:i] objectForKey:@"issue.thumb.url"]];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ]]];
        NSData *thumbImg=[NSData dataWithContentsOfURL:url];
        if (thumbImg) {
            if(i < issueArray.count)
                [CacheManager saveData:thumbImg withName:[NSString stringWithFormat:@"%@.png",[[issueArray objectAtIndex:i] objectForKey:@"issue.id"]] inRelativePath:@"Thumbnail"];
        }
    }
}








-(void)getIssues:(int)pageIndex withPageSize:(int)pageSize
{
    if ([[NetworkService getObject] checkInternetWithData]) {
        
        NSDictionary *countObject =[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"count/issues/%@/",APP_TYPE]];
        issuesCount = [[countObject objectForKey:@"count"] intValue];
        [UserDefaults addObject:countObject withKey:@"issuesCount" ifKeyNotExists:NO];
        
        
        NSDictionary *issueDictionary=nil;
        if([UIDevice deviceType]== iPad)
            issueDictionary = [NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"list/issues/%@/index.start/%d/page.size/%d/fields/thumb.162x216",APP_TYPE,pageIndex,pageSize]];
        
        else if ([UIDevice deviceType]== iPadRetina)
            issueDictionary = [NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"list/issues/%@/index.start/%d/page.size/%d/fields/thumb.324x432",APP_TYPE,pageIndex,pageSize]];
        else if ([UIDevice deviceType]== iPhone)
            issueDictionary = [NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"list/issues/%@/index.start/%d/page.size/%d/fields/thumb.142x213",APP_TYPE,pageIndex,pageSize]];
        else if ([UIDevice deviceType]== iPhoneRetina)
            issueDictionary = [NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"list/issues/%@/index.start/%d/page.size/%d/fields/thumb.284x426",APP_TYPE,pageIndex,pageSize]];
        else
            issueDictionary = [NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"list/issues/%@/index.start/%d/page.size/%d/fields/thumb.284x426",APP_TYPE,pageIndex,pageSize]];
        
        
        
        if (issueDictionary) {
            id issueObject = [[[issueDictionary objectForKey:@"list"] objectForKey:@"issues" ] objectForKey:@"issue"];
            if([issueObject isKindOfClass:[NSArray class]])
                self.moreIssuesArray =issueObject ;
            else
                self.moreIssuesArray = [NSMutableArray arrayWithObjects:issueObject,nil];
            
            
            [self.issuesArray addObjectsFromArray:moreIssuesArray];
            
            [UserDefaults addObject:self.issuesArray withKey:ISSUE_LIST ifKeyNotExists:NO];
            //  [NSThread detachNewThreadSelector:@selector(downloadThumsIssues:) toTarget:self withObject:moreIssuesArray];
        }
        else{
            issuesCount =  [[[UserDefaults getDictionaryWithKey:@"issuesCount"] objectForKey:@"count"] integerValue];
            self.issuesArray=[NSMutableArray arrayWithArray:[UserDefaults getArrayWithKey:ISSUE_LIST]];
            
        }
        

        
        
    }else{
        
        issuesCount =  [[[UserDefaults getDictionaryWithKey:@"issuesCount"] objectForKey:@"count"] integerValue];
        
        self.issuesArray=[NSMutableArray arrayWithArray:[UserDefaults getArrayWithKey:ISSUE_LIST]];
        if ([self.issuesArray count]==0)
        {
            UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"معذرة لا يمكنك مشاهدة الأعداد في الوقت الحالي؛ نظرًا لتعذر الاتصال بالإنترنت" delegate:nil cancelButtonTitle:@"إلغاء" otherButtonTitles: nil];
            [newAlert show ];
            [newAlert release];
            return ;
        }
        if(self.issuesArray.count >= issuesCount)
            loadMoreBtn.hidden = YES ;
    }
    
    
    int noOfSections  = self.issuesArray.count/sectionSize;
    if( ([self.issuesArray count] % sectionSize)!= 0 )
        noOfSections ++;
    
    if( [self.issuesArray count] >= issuesCount )
    {
        loadMoreBtn.hidden = YES ;
        thereMoreIssues=NO;
     
    }
    else{
        
        loadMoreBtn.hidden = NO ;
        thereMoreIssues=YES;
        
    }
    [self getReusableCells];
}


-(void)getReusableCells{
    
    
    
    self.reusableCells=[NSMutableArray array];
    
    if ([self.issuesArray count] == 1)
    {
        HorizontalTableCell *cell = [[HorizontalTableCell alloc] initWithIsLastCategory:NO];
        cell.viewController=self;
        cell.horizontalTableView.contentOffset=CGPointMake(0, [self.issuesArray count]*189);
        cell.issuesArray=[NSArray arrayWithArray:issuesArray];
        cell.delegate = self ;
        [self.reusableCells addObject:cell];
        [cell release];
    }
    else{
        
        for (int i = 1; i <= [self.issuesArray count]; i++)
        {
            i--;
            BOOL isStart=YES;
            HorizontalTableCell *cell = [[HorizontalTableCell alloc] initWithIsLastCategory:NO];
            cell.viewController=self;
            cell.horizontalTableView.contentOffset=CGPointMake(0, [self.issuesArray count]*189);
            NSMutableArray *rowBooks=[NSMutableArray array];
            while (i % sectionSize !=0 || isStart) {
                isStart=NO;
                if (i < [self.issuesArray count]) {
                    [rowBooks addObject:[self.issuesArray objectAtIndex:i]];
                    i++;
                }else
                    break;
            }
            
            cell.issuesArray=[NSArray arrayWithArray:rowBooks];
            
            cell.delegate = self ;
            [self.reusableCells addObject:cell];
            [cell release];
        }
    }
    
    [self.collectionTableView reloadData];
    indicatorView.hidden = YES ;
    [activityView stopAnimating];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HorizontalTableCell *cell = [self.reusableCells objectAtIndex:indexPath.section];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
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
    return [self.reusableCells count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    /*
    int sections=[self.issuesArray count]/sectionSize;
    if( ([self.issuesArray count] % sectionSize)!= 0 )
        sections++;
    if (indexPath.section == sections-1) {
        return 235;
    }
    return 235;*/
    
    
    if([UIDevice deviceType]==iPad ||[UIDevice deviceType]==iPadRetina)
    return  240 ;
    
    else
        return 225;
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
    shaking = YES ;
    for (int section = 0 ; section < reusableCells.count ; section ++)
    {
        [(HorizontalTableCell *)[self.reusableCells  objectAtIndex:section] shakeAnimation];
        
    }
}

-(void)stopShake
{
    [self stopShaking];
}

-(void)updateListDelegate
{
    if([[UserDefaults getStringWithKey:NEW_ISSUE] integerValue]==1)
    [self UpdateList];
}

-(void)deleteCell
{
    
    
    [self performSelector:@selector(shakeCell) withObject:nil afterDelay:0.05];
}



-(void)stopShaking
{
    
    shaking = NO ;
    for (int section = 0 ; section < reusableCells.count ; section ++)
    {
        [(HorizontalTableCell *)[self.reusableCells  objectAtIndex:section] stopShaking];
        
    }
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}




-(void)SendUsageToServer
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL sendDataBool = NO ;
    
    NSMutableDictionary *usageDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UsageData getVendorID] , @"vendor",[UsageData getOSVersion],@"iosversion" ,[UsageData getDeviceType],@"devicetype", nil];
    if(![NO_ID isEqualToString:[[UserDefaults getDictionaryWithKey:@"userID"] objectForKey:@"userID"] ])
    {
        [ usageDictionary setObject:[[UserDefaults getDictionaryWithKey:@"userID"] objectForKey:@"userID"] forKey:@"icloud"];
    }
    
    
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"plist.plist"];
    if ([fileManager fileExistsAtPath: path])
    {
        NSArray*  usageData = [[NSArray alloc] initWithContentsOfFile: path];
        
        if(usageData.count>0)
        {
            
            NSString *xmlString =   [NSString stringWithContentsOfFile:path encoding:[NSString defaultCStringEncoding] error:nil] ;
            [usageDictionary setObject:xmlString forKey:@"usagefile"];
            sendDataBool = YES ;
            
        }
        [usageData release];
    }
    
    
    NSString *deleteFilePath = [documentsDirectory stringByAppendingPathComponent:@"deletedIssues.plist"];
    if ([fileManager fileExistsAtPath: deleteFilePath])
    {
        NSArray*  deleteArray = [[NSArray alloc] initWithContentsOfFile: deleteFilePath];
        if(deleteArray.count>0)
        {
            NSString *deleteXML = [NSString stringWithContentsOfFile:deleteFilePath encoding:[NSString defaultCStringEncoding] error:nil] ;
            [usageDictionary setObject:deleteXML forKey:@"deletedfile"];
            sendDataBool = YES ;
            
        }
        [deleteArray release];
        
    }
    
    
    NSString *downloadFilePath = [documentsDirectory stringByAppendingPathComponent:@"downloadedIssues.plist"];
    if ([fileManager fileExistsAtPath: downloadFilePath])
    {
        NSArray*  downloadArray = [[NSArray alloc] initWithContentsOfFile: downloadFilePath];
        if(downloadArray.count>0)
        {
            NSString *downloadXML = [NSString stringWithContentsOfFile:downloadFilePath encoding:[NSString defaultCStringEncoding] error:nil] ;
            [usageDictionary setObject:downloadXML forKey:@"downloadedfile"];
            sendDataBool = YES ;
            
        }
        [downloadArray release];
    }
    
    
    
    if(sendDataBool)
    {
        NSString *URL = @"http://api.hindawi.org/v1/safahat/usage/" ;
        NSDictionary *Response =  [NetworkService getDataInDictionaryWithBody:usageDictionary methodIsPost:YES andWithoutBaseURL:URL];
        /*
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Response usage  %@", Response] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] ;
         [alert2 show];
         
        
        */
        
        if(Response)
        {
            NSArray *data = [[NSArray alloc] init];
            if([[[Response  objectForKey:@"result"] objectForKey:@"usage.file"] integerValue] ==1)
                [data writeToFile:path atomically:YES];
            
            if([[[Response  objectForKey:@"result"] objectForKey:@"delete.file"] integerValue] ==1)
                [data writeToFile:deleteFilePath atomically:YES];
            
            if([[[Response  objectForKey:@"result"] objectForKey:@"download.file"] integerValue] ==1)
                [data writeToFile:downloadFilePath atomically:YES];
            
            [data release];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]  removeObserver:self] ;
    [_indicatorBgView release];
    [super dealloc];
}




-(IBAction)actionUpdatelist :(id)sender

{
    [self UpdateList] ;
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}

@end
