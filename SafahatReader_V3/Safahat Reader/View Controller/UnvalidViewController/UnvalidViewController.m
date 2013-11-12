//
//  UnvalidViewController.m
//  Safahat Reader
//
//  Created by Ahmed Aly on 2/12/13.
//  Copyright (c) 2013 Ahmed Aly. All rights reserved.
//

#import "UnvalidViewController.h"
#import "UserDefaults.h"
#import "Constants.h"
@interface UnvalidViewController ()

@end

@implementation UnvalidViewController
@synthesize html;
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
    [self.unvalidWebView loadHTMLString:html baseURL:nil];
    self.navigationController.navigationBar.hidden = YES ;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_unvalidWebView release];
    [super dealloc];
}
@end
