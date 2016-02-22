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

+ (PhotoConfigureManager*)sharedManager;

- (void)clearColor;

@end
