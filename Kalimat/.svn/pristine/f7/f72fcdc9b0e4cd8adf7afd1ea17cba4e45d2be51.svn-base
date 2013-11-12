//
//  FontViewController.m
//  AePubReader
//
//  Created by Ahmed Aly on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FontViewController.h"
#import "Constants.h"


@interface FontViewController ()

@end

@implementation FontViewController
@synthesize delegate;
@synthesize smallZoomButton;
@synthesize mediumZoomButton;
@synthesize largeZoomButton,fontSize,background_color_tag;

@synthesize transitionArray;
- (void)viewDidLoad
{
     self.title=@"الخط";
    self.transitionArray=[NSArray arrayWithObjects:_pushButton,_fadeButton,_revealButton,_rippleButton,_cupeButton,_flipButton,_rotateButton, nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self drawFontButtons];
    [self drawColorsButtons];
    _brightnessSlider.value= [UIScreen mainScreen].brightness;
}
- (IBAction) changeTextSizeClicked:(UIButton *)sender{
	
    switch (sender.tag) {
        case 1:
            fontSize=SMALL_SIZE;
            break;
        case 2:
            fontSize=NORMAL_SIZE;
            break;
        case 3:
            fontSize=LARGE_SIZE;
            break;
        default:
            break;
    }
    [self drawFontButtons];
    [delegate changeTextSizeClickedWithTag:sender.tag];
    
}

-(void)drawFontButtons{
    switch (fontSize) {
        case SMALL_SIZE:
            smallZoomButton.userInteractionEnabled=NO;
            mediumZoomButton.userInteractionEnabled=YES;
            largeZoomButton.userInteractionEnabled=YES;
            [smallZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-hover"] forState:UIControlStateNormal];
            [mediumZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-normal"] forState:UIControlStateNormal];
            [largeZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-normal"] forState:UIControlStateNormal];
            
            [smallZoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [mediumZoomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [largeZoomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            //smallZoomButton.backgroundColor=[UIColor blueColor];
            //mediumZoomButton.backgroundColor=[UIColor darkGrayColor];
            //largeZoomButton.backgroundColor=[UIColor darkGrayColor];
            break;
        case NORMAL_SIZE:
            smallZoomButton.userInteractionEnabled=YES;
            mediumZoomButton.userInteractionEnabled=NO;
            largeZoomButton.userInteractionEnabled=YES;
            [smallZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-normal"] forState:UIControlStateNormal];
            [mediumZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-hover"] forState:UIControlStateNormal];
            [largeZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-normal"] forState:UIControlStateNormal];
           
            [smallZoomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [mediumZoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [largeZoomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            //smallZoomButton.backgroundColor=[UIColor darkGrayColor];
            //mediumZoomButton.backgroundColor=[UIColor blueColor];
            //largeZoomButton.backgroundColor=[UIColor darkGrayColor];
            break;
        case LARGE_SIZE:
            smallZoomButton.userInteractionEnabled=YES;
            mediumZoomButton.userInteractionEnabled=YES;
            largeZoomButton.userInteractionEnabled=NO;
            [smallZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-normal"] forState:UIControlStateNormal];
            [mediumZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-normal"] forState:UIControlStateNormal];
            [largeZoomButton setBackgroundImage:[UIImage imageNamed:@"btn-hover"] forState:UIControlStateNormal];
          
            [smallZoomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [mediumZoomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [largeZoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
           // smallZoomButton.backgroundColor=[UIColor darkGrayColor];
           // mediumZoomButton.backgroundColor=[UIColor darkGrayColor];
           // largeZoomButton.backgroundColor=[UIColor blueColor];
            break;
        default:
            break;
    }
    
}


- (IBAction) changeBackgroundColorClicked:(UIButton *)sender{
    background_color_tag=sender.tag;
    [self drawColorsButtons];
    [delegate changeBackgroundColorClickedWithTag:sender.tag];
    
}
-(void)drawColorsButtons{
    switch (background_color_tag) {
        case 1:
            _whiteButton.userInteractionEnabled=NO;
            _blackButton.userInteractionEnabled=YES;
            _sepiaButton.userInteractionEnabled=YES;
           // _whiteButton.backgroundColor=[UIColor blueColor];
           // _blackButton.backgroundColor=[UIColor darkGrayColor];
           // _sepiaButton.backgroundColor=[UIColor darkGrayColor];
            
            break;
        case 2:
            _whiteButton.userInteractionEnabled=YES;
            _blackButton.userInteractionEnabled=NO;
            _sepiaButton.userInteractionEnabled=YES;
          //  _whiteButton.backgroundColor=[UIColor darkGrayColor];
          //  _blackButton.backgroundColor=[UIColor blueColor];
          //  _sepiaButton.backgroundColor=[UIColor darkGrayColor];
            break;
        case 3:
            _whiteButton.userInteractionEnabled=YES;
            _blackButton.userInteractionEnabled=YES;
            _sepiaButton.userInteractionEnabled=NO;
          //  _whiteButton.backgroundColor=[UIColor darkGrayColor];
          //  _blackButton.backgroundColor=[UIColor darkGrayColor];
          //  _sepiaButton.backgroundColor=[UIColor blueColor];
            break;
        default:
            break;
    }

}


- (IBAction) changeTransitionClicked:(UIButton *)sender{
    for (int i=0; i<[transitionArray count]; i++) {
        UIButton *selectedButton=[transitionArray objectAtIndex:i];
        if (sender.tag == i+1) {
            selectedButton.enabled=NO;
            selectedButton.backgroundColor=[UIColor blueColor];
        }else{
            selectedButton.enabled=YES;
            selectedButton.backgroundColor=[UIColor darkGrayColor];
        }
    }
    [delegate setTranstionWithIndex:sender.tag];    
}


-(IBAction)brightnessClicked:(UISlider *)sender{
    [delegate setBrightnessWithRate:sender.value];
}

- (void)viewDidUnload
{
    [self setSmallZoomButton:nil];
    [self setMediumZoomButton:nil];
    [self setLargeZoomButton:nil];
    [self setWhiteButton:nil];
    [self setBlackButton:nil];
    [self setSepiaButton:nil];
    [self setPushButton:nil];
    [self setFadeButton:nil];
    [self setRevealButton:nil];
    [self setRippleButton:nil];
    [self setCupeButton:nil];
    [self setFlipButton:nil];
    [self setRotateButton:nil];
    [self setBrightnessSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [smallZoomButton release];
    [mediumZoomButton release];
    [largeZoomButton release];
    [_whiteButton release];
    [_blackButton release];
    [_sepiaButton release];
    [_pushButton release];
    [_fadeButton release];
    [_revealButton release];
    [_rippleButton release];
    [_cupeButton release];
    [_flipButton release];
    [_rotateButton release];
    [_brightnessSlider release];
    [super dealloc];
}
@end
