

#import <UIKit/UIKit.h>

@class ArticleTitleLabel;

@interface BookCell : UITableViewCell 
{
    UIImageView *_thumbnail;
    UIProgressView *progressView;
    
    UIImageView *downloadedImage;
    
    UIButton *deleteButton ; 
    
    UIActivityIndicatorView *indicatorView;
}


@property (nonatomic, retain) UIButton *deleteButton ; 
@property (nonatomic, retain) UIImageView *thumbnail;
@property (nonatomic, retain) UIProgressView *progressView;

@property (nonatomic, retain) UIImageView *downloadedImage;
@property (nonatomic, retain) UIView *cellView ; 

@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@end
