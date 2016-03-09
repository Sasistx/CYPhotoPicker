//
//  PHSelectButton.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/3/9.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PHSelectButton.h"
#import "PhotoUtility.h"

@implementation PHSelectButton

- (void)setButtonSelectBackgroundColor:(UIColor *)buttonSelectBackgroundColor
{
    _buttonSelectBackgroundColor = buttonSelectBackgroundColor;
    
    UIImage* arrowImage = [UIImage imageNamed:@"ph_photo_selected_arrow"];
    
    UIImage* selectBackImage = [PhotoUtility originImage:[UIImage imageNamed:@"ph_photo_selected_round"] tintColor:buttonSelectBackgroundColor blendMode:kCGBlendModeDestinationIn];

    UIImage* deselectBackImage = [PhotoUtility originImage:[UIImage imageNamed:@"ph_photo_selected_round"] tintColor:[UIColor colorWithWhite:0.7 alpha:0.2] blendMode:kCGBlendModeDestinationIn];
    
    UIImage* currentSelectImage = [PhotoUtility combineSameSizeImageWithContextImage:selectBackImage headerImage:arrowImage];
    
    UIImage* currentDeselectedImage = [PhotoUtility combineSameSizeImageWithContextImage:deselectBackImage headerImage:arrowImage];
    
    [self setBackgroundImage:currentSelectImage forState:UIControlStateSelected];
    [self setBackgroundImage:currentDeselectedImage forState:UIControlStateNormal];
}

- (void)setButtonBackgroundColor:(UIColor*)backgroundColor selectColor:(UIColor*)selectColor
{

}

@end
