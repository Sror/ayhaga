//
//  FontViewController.h
//  AePubReader
//
//  Created by Ahmed Aly on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FontDelegate <NSObject>
@required
- (void) changeTextSizeClickedWithTag:(int)tag;
- (void) changeBackgroundColorClickedWithTag:(int)tag;
- (void) setBrightnessWithRate:(float)rate;
- (void)setTranstionWithIndex:(int)index;
@end
@interface FontViewController : UIViewController
{
    id<FontDelegate> delegate;
    NSArray *transitionArray;
    int fontSize;
    int background_color_tag;
}
@property (nonatomic, assign) id delegate;

@property (retain, nonatomic) IBOutlet UIButton *smallZoomButton;
@property (retain, nonatomic) IBOutlet UIButton *mediumZoomButton;
@property (retain, nonatomic) IBOutlet UIButton *largeZoomButton;

@property (retain, nonatomic) IBOutlet UIButton *whiteButton;
@property (retain, nonatomic) IBOutlet UIButton *blackButton;
@property (retain, nonatomic) IBOutlet UIButton *sepiaButton;

@property (retain, nonatomic) IBOutlet UIButton *pushButton;
@property (retain, nonatomic) IBOutlet UIButton *fadeButton;
@property (retain, nonatomic) IBOutlet UIButton *revealButton;
@property (retain, nonatomic) IBOutlet UIButton *rippleButton;
@property (retain, nonatomic) IBOutlet UIButton *cupeButton;
@property (retain, nonatomic) IBOutlet UIButton *flipButton;
@property (retain, nonatomic) IBOutlet UIButton *rotateButton;

@property (retain, nonatomic)  NSArray *transitionArray;
@property (assign) int fontSize;
@property (assign) int background_color_tag;
@property (retain, nonatomic) IBOutlet UISlider *brightnessSlider;
-(void)drawFontButtons;
@end
