//
//  IssueCell.h
//  Safahat Reader
//
//  Created by Marwa Aman on 8/22/13.
//  Copyright (c) 2013 Ahmed Aly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueCell : UITableViewCell
{
    UIImageView *_thumbnail;
    UIProgressView *progressView;
    
    UIImageView *downloadedImage;
    
    UIButton *deleteButton ;
    
    UIActivityIndicatorView *indicatorView;
    
    UILabel *cellTitle;
}


@property (nonatomic, retain) UIButton *deleteButton ;
@property (nonatomic, retain) UIImageView *thumbnail;
@property (nonatomic, retain) UIProgressView *progressView;

@property (nonatomic, retain) UIImageView *downloadedImage;
@property (nonatomic, retain) UIView *cellView ;

@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) UILabel *cellTitle;
@end
