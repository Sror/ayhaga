//
//  GeneralWebViewController.h
//  CMA
//
//  Created by Ahmed Aly on 1/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface GeneralWebViewController : UIViewController <UIWebViewDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UIWebView *webView;
    NSString *url;
    IBOutlet UIBarButtonItem *backBarButton;
    
}
@property (retain, nonatomic) UIWebView *webView;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic)UIBarButtonItem *backBarButton;

-(id)initWithUrl:(NSString *)urlString;
-(IBAction)closeView:(UIBarButtonItem *)sender;@end
