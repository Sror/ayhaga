//
//  MYTextField.m
//  AePubReader
//
//  Created by Ahmed Aly on 12/20/12.
//
//

#import <UIKit/UIKit.h>

@interface MYTextField : UITextField

@end


@implementation MYTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    int margin = 10;
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int margin = 10;
    CGRect inset = CGRectMake(bounds.origin.x , bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

@end
