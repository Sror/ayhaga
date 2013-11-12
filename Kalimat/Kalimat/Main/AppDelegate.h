//
//  AppDelegate.h
//  Kalimat
//
//  Created by Staff on 3/14/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//  tttttttttttttttttttttt

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSData *token;
    MainViewController *mainViewController;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSData *token;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (strong) UIDdocument * doc;
@property (strong) NSMetadataQuery *query;
@end
