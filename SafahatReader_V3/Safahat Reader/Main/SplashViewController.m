//
//  SplashViewController.m
//  Safahat Reader
//
//  Created by Ahmed Aly on 2/20/13.
//  Copyright (c) 2013 Ahmed Aly. All rights reserved.
//

#import "SplashViewController.h"
#import "MainScreenViewController.h"
#import "UIDevice.h"
#import "ArabicConverter.h"
#import "UserDefaults.h"

#import "Constants.h"
@interface SplashViewController ()

@end

@implementation SplashViewController

@synthesize safahatLabel ,indicatorLoading;

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
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    ArabicConverter *converter = [[ArabicConverter alloc] init] ;
    safahatLabel.text = [converter convertArabic:@"صفحات"];

    self.navigationController.navigationBar.hidden = YES ;
    if([UIDevice deviceType]==iPhone5)
    {
       /* UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"7.png"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        */
        /*
        UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"iphone_5.png"]];
        self.view.backgroundColor = backgroundColor;
        [backgroundColor release];*/
        //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone_5.png"]]];
        
        safahatLabel.font =  [UIFont fontWithName:Font size:30];
    }
    
    else if([UIDevice deviceType]== iPhone || [UIDevice deviceType]==iPhoneRetina)
    {
        
        safahatLabel.font =  [UIFont fontWithName:Font size:30];
    } //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone.png"]]];
    
    else
        safahatLabel.font =  [UIFont fontWithName:Font size:72];
      //  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad.png"]]];
   
  
    
    [self.indicatorLoading startAnimating];
    [UserDefaults saveData:nil withName:@"aa" inRelativePath:@"Thumbnail" inDocument:YES];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:@"Thumbnail"];
    NSURL *pathURL= [NSURL fileURLWithPath:folder];
    [self addSkipBackupAttributeToItemAtURL:pathURL];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    MainScreenViewController *viewController = [[MainScreenViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:NO];
    //self.indicatorLoading.hidden = YES ;
    [viewController release];

}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL

{
    
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                    
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        
    }
    
    return success;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [indicatorLoading release];
    [super dealloc];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}
@end
