//
//  PhotoConfigureManager.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

@class CYPhotoPicker;

typedef NS_ENUM(NSInteger, PhotoNaviButtonStyle)
{
    PhotoNaviButtonStyleDefault,
    PhotoNaviButtonStyleCYStyle
};

@interface PhotoConfigureManager : NSObject

@property (nonatomic, strong) UIColor* buttonBackgroundColor; //default is white
@property (nonatomic, strong) UIColor* sendButtontextColor; //default is black

@property (nonatomic, assign) PhotoNaviButtonStyle naviStyle;
@property (nonatomic, strong) CYPhotoPicker* currentPicker;

/**
 *  CYPhotoPicker预设方法，必须在Appdelegate中进行预设
 *
 *  @param buttonBackgourndColor 按钮背景色
 *  @param buttonTextColor       文字颜色
 */
+ (void)preConfigureWithButtonBackgourndColor:(UIColor*)buttonBackgourndColor buttonTextColor:(UIColor*)buttonTextColor;

+ (PhotoConfigureManager*)sharedManager;

- (void)clearColor;

@end
