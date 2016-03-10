//
//  PhotoConfigureManager.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoConfigureManager.h"
#import "PHSelectButton.h"
#import "PHButton.h"
#import "PhotoUtility.h"

@implementation PhotoConfigureManager

static PhotoConfigureManager* sharedManager = nil;

+ (PhotoConfigureManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PhotoConfigureManager alloc] init];
    });
    return sharedManager;
}

+ (void)preConfigureWithButtonBackgourndColor:(UIColor*)buttonBackgourndColor buttonTextColor:(UIColor*)buttonTextColor
{
    [[PHButton appearance] setBackgroundImage:[PhotoUtility imageWithColor:buttonBackgourndColor] forState:UIControlStateNormal];
    [[PHButton appearance] setTitleColor:buttonTextColor forState:UIControlStateNormal];
    [[PHSelectButton appearance] setButtonSelectBackgroundColor:buttonBackgourndColor];
}

- (void)clearColor
{
    self.buttonBackgroundColor = nil;
    self.sendButtontextColor = nil;
    self.naviStyle = PhotoNaviButtonStyleDefault;
}

@end
