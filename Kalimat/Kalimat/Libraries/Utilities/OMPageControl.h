//
//  OMPageControl.h
//  AePubReader
//
//  Created by Ahmed Aly on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMPageControl : UIPageControl {
    UIImage* mImageNormal;
    UIImage* mImageCurrent;
}

@property (nonatomic, readwrite, retain) UIImage* imageNormal;
@property (nonatomic, readwrite, retain) UIImage* imageCurrent;

@end