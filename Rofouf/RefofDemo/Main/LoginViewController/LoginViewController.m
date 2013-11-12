//
//  HomeViewController.m
//  Refof
//
//  Created by Mohamed Alaa El-Din on 11/6/13.
//  Copyright (c) 2013 Mohamed Alaa El-Din. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize restClient;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToLogin) name:@"failedToLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succeedToLogin) name:@"succeedToLogin" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)succeedToLogin
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"تم بنجاح انشاء فولدر في حسابك ، برجاء نقل الملفات اليه!" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    HomeViewController *homeViewController = [[[HomeViewController alloc] init] autorelease];
    [self.navigationController pushViewController:homeViewController animated:YES];
}

-(void)failedToLogin
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"فشل في الدخول، يرجى اعادة المحاولة!" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (IBAction)login:(id)sender {
    if (![[DBSession sharedSession] isLinked])
    {
        [[DBSession sharedSession] linkFromController:self];
    }
}

// Dropbox delegates

- (DBRestClient *)restClient {
    if (!restClient)
    {
        restClient          = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}
@end
