//
//  HomeViewController.m
//  RefofDemo
//
//  Created by Mohamed Alaa El-Din on 11/6/13.
//  Copyright (c) 2013 Mohamed Alaa El-Din. All rights reserved.
//

#import "HomeViewController.h"
#import "XMLReader.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "NetworkService.h"
#import "CacheManager.h"
#import "UserDefaults.h"
#import "UIDevice.h"
#import <AdSupport/AdSupport.h>
#import "ArabicConverter.h"
#import "UsageData.h"
#import <CommonCrypto/CommonDigest.h>


@interface HomeViewController ()
@property (nonatomic, strong) LoginViewController *loginViewController;
@end

@implementation HomeViewController
@synthesize loginViewController, reusableCells, issuesFileNamesArray, restClient, mainTableView, articlesStillDownloading, loadMoreBtn, moreIssuesArray, indicatorBgView, indicatorView , activityView, refofLabel, issuesFileUrlsArray, issuesThumbinalArray;
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
    [super viewDidLoad];
    
    count = 1;
    // rofouf Label
    ArabicConverter *converter = [[ArabicConverter alloc] init] ;
    refofLabel.text = [converter convertArabic:@"رفوف"];
    refofLabel.font =  [UIFont fontWithName:Font size:72];
    
    self.issuesFileNamesArray     = [NSMutableArray array];
    self.issuesFileUrlsArray      = [NSMutableArray array];
    self.issuesThumbinalArray     = [NSMutableArray array];
    self.articlesStillDownloading = [NSMutableArray array];
    
    [[self restClient] loadMetadata:@"/"];
    
    
    
    issuesCount      = 0 ;
    issuePagingIndex = 1 ;
    sectionSize      = 4;
    [self getIssues:issuePagingIndex withPageSize:1000];
    
    [self.view bringSubviewToFront:indicatorView];
    indicatorView.hidden = NO ;
    [self.activityView startAnimating];
    UITapGestureRecognizer *Tapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopShaking)];
    Tapped.numberOfTapsRequired    = 2;
    Tapped.delegate                = self;
    [self.view addGestureRecognizer:Tapped];
}


////////////////////////////// metadata deleget////////////////////////////
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    if (metadata.isDirectory)
    {
        for (DBMetadata *file in metadata.contents)
        {
            [self.issuesFileNamesArray addObject:file.filename];
        }
    }
    if(self.issuesFileNamesArray.count > 0)
    {
        [self loadUrls];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"لاتوجد ملفات برجاء نقل الملفات الى الفولدر المضاف الى حسابك!" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    NSLog(@"Error loading metadata: %@", error);
}
/////////////////////////////// load Streamable URL//////////////////////

-(void)restClient:(DBRestClient *)restClient loadedStreamableURL:(NSURL *)url forFile:(NSString *)path
{
    [issuesFileUrlsArray addObject:[url absoluteURL]];
    if(count == issuesFileNamesArray.count)
        [self getReusableCells];
    count++;
}

- (void)restClient:(DBRestClient*)restClient loadStreamableURLFailedWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"خطأ في تحميل الملفات يرجى معاودة التحميل!" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
   // NSLog(@"%@", [error localizedDescription]);
}


-(void)getIssues:(int)pageIndex withPageSize:(int)pageSize
{
    int noOfSections  = self.issuesFileNamesArray.count / sectionSize;
    if( ([self.issuesFileNamesArray count] % sectionSize)!= 0 )
        noOfSections ++;
    
    if( [self.issuesFileNamesArray count] >= issuesCount )
    {
        loadMoreBtn.hidden = YES ;
        thereMoreIssues    = NO;
    }
    else
    {
        loadMoreBtn.hidden = NO ;
        thereMoreIssues    = YES;
    }
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata {
    
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}


-(void) restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath
{
    NSLog(@"destination name = %@",destPath);
}


-(void)loadUrls
{
    for (int i = 0 ; i != issuesFileNamesArray.count ; i++)
       [[self restClient] loadStreamableURLForFile:[NSString stringWithFormat:@"/%@",[issuesFileNamesArray objectAtIndex:i]]];
}

-(void) loadThumbinals
{
     for (int i = 0 ; i != issuesFileNamesArray.count ; i++)
         [issuesThumbinalArray addObject:@"sample.jpg"];
    
    
    NSString *DropBoxpath = [issuesFileNamesArray objectAtIndex:4];
   // [[self restClient] loadFile:[NSString stringWithFormat:@"/%@",DropBoxpath] intoPath:[NSHomeDirectory() stringByAppendingPathComponent:([NSString stringWithFormat:@"Documents/%@",[issuesFileNamesArray objectAtIndex:4]]) ]];
    
    [self.restClient loadThumbnail:[NSString stringWithFormat:@"/%@",DropBoxpath] ofSize:@"large" intoPath:[NSHomeDirectory() stringByAppendingPathComponent:([NSString stringWithFormat:@"Documents/%@",[issuesFileNamesArray objectAtIndex:4]]) ]];
}
-(void)getReusableCells
{
    [self loadThumbinals];
    
    NSMutableArray *issuesContents = [NSMutableArray array];
    for (int i = 0 ; i != issuesFileNamesArray.count ; i++) {
        [issuesContents addObject: @{
                                     @"name"  : [[issuesFileNamesArray[i] componentsSeparatedByString:@"."] objectAtIndex:0]
                                    ,@"image" : issuesThumbinalArray[i]
                                    ,@"url"   : issuesFileUrlsArray[i]
                                    }];
    }
    
    self.reusableCells=[NSMutableArray array];
    if ([issuesContents count] == 1)
    {
        HorizontalTableCell *cell              = [[HorizontalTableCell alloc] initWithIsLastCategory:NO];
        cell.viewController                    = self;
        cell.horizontalTableView.contentOffset = CGPointMake(0, [self.issuesFileNamesArray count]*189);
        cell.issuesContents              = issuesContents;
        cell.delegate = self ;
        [self.reusableCells addObject:cell];
        [cell release];
    }
    else
    {
        for (int i = 1; i <= [issuesContents count]; i++)
        {
            i--;
            BOOL isStart = YES;
            HorizontalTableCell *cell = [[HorizontalTableCell alloc] initWithIsLastCategory:NO];
            cell.viewController       = self;
            cell.horizontalTableView.contentOffset=CGPointMake(0, [issuesContents count]*189);
            NSMutableArray *rowBooks = [NSMutableArray array];
            while (i % sectionSize !=0 || isStart)
            {
                isStart = NO;
                if (i < [self.issuesFileNamesArray count])
                {
                    [rowBooks addObject:[issuesContents objectAtIndex:i]];
                    i++;
                }
                else
                    break;
            }
            
            cell.issuesContents = [NSArray arrayWithArray:rowBooks];
            cell.delegate             = self ;
            [self.reusableCells addObject:cell];
            [cell release];
        }
    }
    
    [self.mainTableView reloadData];
    indicatorView.hidden = YES ;
    [self.activityView stopAnimating];
    [activityView stopAnimating];
}


- (DBRestClient *)restClient
{
    if (!restClient)
    {
        restClient          = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}


- (IBAction)logout:(id)sender
{
    [[DBSession sharedSession] unlinkAll];
    loginViewController = [[[LoginViewController alloc] init] autorelease];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

// MD5

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

// Main TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HorizontalTableCell *cell = [self.reusableCells objectAtIndex:indexPath.section];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  240 ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [mainTableView release];
    [super dealloc];
}
@end
