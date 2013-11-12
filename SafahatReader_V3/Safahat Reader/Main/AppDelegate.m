//
//  AppDelegate.m
//  Safahat Reader
//
//  Created by Ahmed Aly on 1/1/13.
//  Copyright (c) 2013 Ahmed Aly. All rights reserved.
//

#import "AppDelegate.h"
#import "MainScreenViewController.h"
#import "NetworkService.h"
#import "UnvalidViewController.h"
#import "UserDefaults.h"
#import "Constants.h"
#import "SplashViewController.h"
#import "UIDevice.h"
#import "UsageData.h"


@implementation AppDelegate



@synthesize doc = _doc;
@synthesize query = _query;
@synthesize mainViewController;
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    //UIViewController *viewController=nil;
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=application.applicationIconBadgeNumber-1;
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    NSDictionary *versionDict=nil;
    if ([[NetworkService getObject] checkInternetWithData]) {
        if([UIDevice deviceType]== iPad||[UIDevice deviceType] == iPadRetina)
            versionDict=[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andWithoutBaseURL:@"http://api.hindawi.org/v1/app/11/status/ipad/"];
        else
            versionDict=[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andWithoutBaseURL:@"http://api.hindawi.org/v1/app/11/status/iphone/"];
        
        [UserDefaults addObject:versionDict withKey:APP_STATUS ifKeyNotExists:NO];
    }else
        versionDict=[UserDefaults getDictionaryWithKey:APP_STATUS];
    
    if (!versionDict) {
        MainScreenViewController *viewController = [[MainScreenViewController alloc] init];
        [navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
        [viewController release];
        
    }else{
        NSString *statusId=[[versionDict objectForKey:@"validation"] objectForKey:@"id"];
        switch (statusId.intValue) {
                
            case 1:   // valid
            {
                SplashViewController *viewController = [[SplashViewController alloc] init];
                [navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
                [viewController release];
            }
                break;
            case 2:  // unvalid
            {
                UnvalidViewController *viewController = [[UnvalidViewController alloc] init];
                viewController.html=[[versionDict objectForKey:@"validation"] objectForKey:@"message"];
                [navigationController setViewControllers:[NSArray arrayWithObject:viewController]];
                [viewController release];
                break;
            }
                
            default:
                break;
        }
    }
    
    
    
    
    
    //self.window.rootViewController = viewController;
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    [navigationController release];
    
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    
    return YES;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // NSLog(@"%d",application.applicationIconBadgeNumber);
    if (application.applicationIconBadgeNumber >0) {
        [UserDefaults addObject:@"1" withKey:NEW_ISSUE ifKeyNotExists:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_LIST object:nil];
    }
    application.applicationIconBadgeNumber = 0;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    
    NSMutableDictionary *token = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",deviceToken],@"token",nil];
    [UserDefaults  addObject:token withKey:@"token" ifKeyNotExists:NO];
    
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    [UserDefaults addObject:@"1" withKey:NEW_ISSUE ifKeyNotExists:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_LIST object:nil];
    application.applicationIconBadgeNumber = 0;
    
    /*
     NSString *message = nil;
     id alert = [userInfo objectForKey:@"update"];
     if ([alert isKindOfClass:[NSString class]]) {
     message = alert;
     } else if ([alert isKindOfClass:[NSDictionary class]]) {
     message = [alert objectForKey:@"update"];
     }
     if (alert) {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title"
     message:@"AThe message."  delegate:self
     cancelButtonTitle:@"button 1"
     otherButtonTitles: nil];
     [alertView show];
     [alertView release];
     }*/
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
        
     /*    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Response usage  %@", Response] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] ;
         [alert2 show];
         */
         
        
        
       //   NSLog(@"%@",usageDictionary);
        
      //    NSLog(@"Rsponse  %@",Response);
        
        
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
    
    //[DataSend release] ;
    
}
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}


@end
