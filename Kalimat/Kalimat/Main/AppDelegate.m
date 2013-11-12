//
//  AppDelegate.m
//  Kalimat
//
//  Created by Staff on 3/14/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import "AppDelegate.h"
#import "EPubViewController.h"
#import "MainViewController.h"
#import "MyBookViewController.h"
#import "Constants.h"
#import "UserDefaults.h"
#import "CollectionViewController.h"
#import "NetworkService.h"
#import "UsageData.h"
@implementation AppDelegate
@synthesize token,mainViewController;
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
   
    [UserDefaults addObject:nil withKey:BADGE ifKeyNotExists:NO];
    [UserDefaults addObject:nil withKey:StillDOWNLOADED_BOOKS ifKeyNotExists:NO];

    UITabBarController *tabBarController=[[UITabBarController alloc] init];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    mainViewController=[[MainViewController alloc] init];
    MyBookViewController *myBooksViewController=[[MyBookViewController alloc] init];
    CollectionViewController *booksSearchViewController=[[CollectionViewController alloc] init];
    
    mainViewController.title=@"المكتبة";
    NSString *name=[[NSBundle mainBundle] pathForResource:@"libraryBar" ofType:@"png"];
    NSString *nameSelcted=[[NSBundle mainBundle] pathForResource:@"libraryBar_sel" ofType:@"png"];
   
    UIImage *image=[UIImage imageWithContentsOfFile:name ];
    UIImage *imageSelected=[UIImage imageWithContentsOfFile:nameSelcted ];
    [mainViewController.tabBarItem setFinishedSelectedImage:imageSelected withFinishedUnselectedImage:image];
   
    
    myBooksViewController.title=@"مكتبتي";
    name=[[NSBundle mainBundle] pathForResource:@"my_books" ofType:@"png"];
    nameSelcted=[[NSBundle mainBundle] pathForResource:@"my_books_sel" ofType:@"png"];
    image=[UIImage imageWithContentsOfFile:name ];
    imageSelected=[UIImage imageWithContentsOfFile:nameSelcted ];
    [myBooksViewController.tabBarItem setFinishedSelectedImage:imageSelected withFinishedUnselectedImage:image];
      
   
    booksSearchViewController.title=@"البحث";
    booksSearchViewController.classType=search;
    name=[[NSBundle mainBundle] pathForResource:@"searchBar" ofType:@"png"];
     nameSelcted=[[NSBundle mainBundle] pathForResource:@"searchBar_sel" ofType:@"png"];
    image=[UIImage imageWithContentsOfFile:name ];
    imageSelected=[UIImage imageWithContentsOfFile:nameSelcted ];
    
    [booksSearchViewController.tabBarItem setFinishedSelectedImage:imageSelected withFinishedUnselectedImage:image];
      
    UINavigationController *mainController=[[UINavigationController alloc] initWithRootViewController:mainViewController];
    mainController.navigationBarHidden=YES;
   
    
    UINavigationController *myBooksController=[[UINavigationController alloc] initWithRootViewController:myBooksViewController];
    myBooksController.navigationBarHidden=YES;
    
    UINavigationController *booksSearchController=[[UINavigationController alloc] initWithRootViewController:booksSearchViewController];
    booksSearchController.navigationBarHidden=YES;
    
    if ([UsageData getiOSVersion]==7) {
       
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
   // [[UITabBar appearance] setTranslucent:NO];
    [tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    [tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
    [tabBarController.tabBar setBackgroundColor:[UIColor blackColor]];

    [tabBarController.tabBar setTranslucent:NO];
    }
    tabBarController.viewControllers = [NSArray arrayWithObjects:booksSearchController,myBooksController,mainController, nil];
    tabBarController.selectedIndex = 2;
    self.window.rootViewController = tabBarController;
    
    
    [mainViewController release];
    [myBooksViewController release];
    [booksSearchViewController release];
    
    [mainController release];
    [myBooksController release];
    [booksSearchController release];
    [tabBarController release];
    
    [UserDefaults saveData:nil withName:@"aa" inRelativePath:@"/books" inDocument:YES];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:@"/books"];
    NSURL *pathURL= [NSURL fileURLWithPath:folder];
    [self addSkipBackupAttributeToItemAtURL:pathURL];
    
  //  NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:@"/books"];
   
  //  [self addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:folder]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
   // assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if([[NetworkService getObject] checkInternetWithData])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendUsageToServer) name:SendUsageNotification object:nil];
        [[UsageData getObject] setNotificationType:SendUsage] ;
        [[UsageData getObject] getiCloudID];
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
   // NSLog(@"%d",application.applicationIconBadgeNumber);
    if (application.applicationIconBadgeNumber >0) {
        [UserDefaults addObject:@"1" withKey:ISNEWBOOKS ifKeyNotExists:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEBOOKS object:nil];
    }
    application.applicationIconBadgeNumber = 0;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
   
    
    NSMutableDictionary *tokenID = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",deviceToken],@"token",nil];
    [UserDefaults addObject:tokenID withKey:@"token" ifKeyNotExists:NO];

   // self.token=deviceToken;
   
    //  NSString *tokenIsSend=[UserDefaults getStringWithKey:IS_TOKEN_SEND];
    //if (!tokenIsSend){
   // ViewController *currentViewController=[[self.navController viewControllers] objectAtIndex:0];
   // mainViewController.token=self.token;
  //  [NSTimer scheduledTimerWithTimeInterval:0.3 target:mainViewController selector:@selector(sendTokenToServer) userInfo:nil repeats:NO];
    // }
    
    // [NSThread detachNewThreadSelector:@selector(sendTokenToServer) toTarget:currentViewController withObject:currentViewController];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NSLog(@"%@",userInfo);
    [UserDefaults addObject:@"1" withKey:ISNEWBOOKS ifKeyNotExists:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEBOOKS object:nil];
     application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
    
    
    NSString *deleteFilePath = [documentsDirectory stringByAppendingPathComponent:@"deletedBooks.plist"];
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
    
    
    NSString *downloadFilePath = [documentsDirectory stringByAppendingPathComponent:@"downloadedBooks.plist"];
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
        NSString *URL = @"http://beta.api.hindawi.org/v1/kalimat/usage/1/" ;
        NSDictionary *Response =  [NetworkService getDataInDictionaryWithBody:usageDictionary methodIsPost:YES andWithoutBaseURL:URL];
        /*
         UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Response usage  %@", Response] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] ;
         [alert2 show];
         
         */
        
        
          NSLog(@"%@",usageDictionary);
        
          NSLog(@"Rsponse  %@",Response);
        
        
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
    
    [usageDictionary release] ;
    
}



- (void)applicationWillTerminate:(UIApplication *)application
{
   
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
