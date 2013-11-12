

#import "BookCell.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "UsageData.h"
@implementation BookCell

@synthesize thumbnail;
@synthesize progressView,downloadedImage,indicatorView,deleteButton,cellView;
#pragma mark - View Lifecycle

- (NSString *)reuseIdentifier 
{
    return @"BookCell";
}
- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    
    self.cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 152, 203)]; 
    
    self.indicatorView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(66, 91, 20, 20)];
    indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    indicatorView.color=[UIColor blackColor];
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden=YES;
    
    self.thumbnail = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 152, 203)] autorelease];
    //[self.thumbnail.layer setBorderColor: [[UIColor colorWithRed:165.0/255 green:165.0/255 blue:165.0/255 alpha:1] CGColor]];
    //[self.thumbnail.layer setBorderWidth:1.0];
    self.thumbnail.opaque = YES;
    
    self.downloadedImage = [[[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 32, 22)] autorelease];
    [self.downloadedImage setImage:[UIImage imageNamed:@"Cloud.png"]];
    self.downloadedImage.opaque = YES;
    self.downloadedImage.hidden=YES;
    self.downloadedImage.tag=1;
    
    self.progressView=[[UIProgressView alloc] initWithFrame:CGRectMake(12, 182, 128, 9)];
   // [self.progressView set]
    
    if([UsageData getiOSVersion] == 7)
    {
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.44f);
        progressView.transform =  CGAffineTransformRotate(transform, 3.14);
    }
    else
        progressView.transform = CGAffineTransformMakeRotation(3.14);
    
    self.progressView.tag=2;
    self.progressView.hidden=YES;

    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateHighlighted];
    deleteButton.frame = CGRectMake(-8, -8, 46, 46);
    self.deleteButton.tag = 4 ;
    [deleteButton setImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
    deleteButton.hidden = YES ;
    
    [self.contentView addSubview:self.cellView];
    
    [self.cellView addSubview:self.indicatorView];
    [self.cellView addSubview:self.thumbnail];
    [self.cellView addSubview:self.progressView];
    [self.cellView addSubview:self.downloadedImage];
    [self.cellView addSubview:self.indicatorView];
    
    [self.thumbnail release];
    [self.downloadedImage release];
    [self.progressView release];
    //[self.deleteButton release];
    [self.cellView release];
    [self.indicatorView release];
    
    [self.cellView addSubview:self.deleteButton];
    self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
    self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.thumbnail.frame] autorelease];
    
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    return self;
}


#pragma mark - Memory Management

- (void)dealloc
{
    /*
    [self.thumbnail release];
    [self.downloadedImage release];
    [self.progressView release];
    [self.deleteButton release];
    [self.cellView release];
    [self.indicatorView release];
     */
    self.thumbnail = nil;
    self.downloadedImage=nil;
    self.progressView=nil;
    self.deleteButton = nil ;
    self.cellView =nil;
    [super dealloc];
    
}

@end
