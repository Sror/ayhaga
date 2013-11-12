//
//  GeneralWebViewController.m
//  CMA
//
//  Created by Ahmed Aly on 1/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GeneralWebViewController.h"


@implementation GeneralWebViewController

@synthesize webView,url,backBarButton;


-(id)initWithUrl:(NSString *)urlString{
    [self init];
    if (self) {
        self.url=urlString;
    }
    return self;
}

- (void)viewDidLoad
{
  
    self.webView.backgroundColor=[UIColor clearColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [super viewDidLoad];
}

- (IBAction)closeView:(UIBarButtonItem *)sender{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	BOOL loadRequest = YES;
	
	NSString *recipient = [[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
	if ([recipient rangeOfString:@"^.+@.+\\..{2,}$" options:NSRegularExpressionSearch].location != NSNotFound) {
		loadRequest = NO;
		if ([MFMailComposeViewController canSendMail]) {
          
                MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                mailViewController.mailComposeDelegate = self;
                [mailViewController setToRecipients:[NSArray arrayWithObject:recipient]];
                
                [self presentModalViewController:mailViewController animated:YES];
                [mailViewController release];
       
	} 
	}
	return loadRequest;
}



- (void)webViewDidStartLoad:(UIWebView *)webView{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 
	return YES;
}


- (void)dealloc {
    [webView release];
    [backBarButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [backBarButton release];
    backBarButton = nil;
    [super viewDidUnload];
}
@end
