//
//  PhotoPreviewController.h
//  ChunyuClinic
//
//  Created by 高天翔 on 15/9/11.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

//typedef void(^ChooseImage)(ChunyuPhoto* photo);
typedef void(^ChoosePHAssetImage)(UIImage* photo);

@interface PhotoPreviewController : UIViewController

//- (void)setChoosedImageBlock:(ChooseImage)chooseBlock;

- (void)setChoosedAssetImageBlock:(ChoosePHAssetImage)chooseBlock;

@end
