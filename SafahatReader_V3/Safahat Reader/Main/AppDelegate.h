//
//  AppDelegate.h
//  Safahat Reader
//
//  Created by Ahmed Aly on 1/1/13.
//  Copyright (c) 2013 Ahmed Aly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDdocument.h"
#import "MainScreenViewController.h"

#define kFILENAME @"icloudDocument.dox"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

}
@property (nonatomic, retain) MainScreenViewController *mainViewController;
@property (strong, nonatomic) UIWindow *window;
@property (strong) UIDdocument * doc;
@property (strong) NSMetadataQuery *query;


@end
