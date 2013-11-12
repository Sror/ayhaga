//
//  UnvalidViewController.h
//  Safahat Reader
//
//  Created by Ahmed Aly on 2/12/13.
//  Copyright (c) 2013 Ahmed Aly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnvalidViewController : UIViewController
{
    NSString *html;
}
@property (retain, nonatomic) IBOutlet UIWebView *unvalidWebView;
@property (retain, nonatomic) NSString *html;
@end
