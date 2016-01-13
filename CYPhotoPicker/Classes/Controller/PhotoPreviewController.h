//
//  PhotoPreviewController.h
//  ChunyuClinic
//
//  Created by 高天翔 on 15/9/11.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"
#import "PhotoOldListItem.h"

//typedef void(^ChooseImage)(ChunyuPhoto* photo);
typedef void(^ChoosePHAssetImage)(UIImage* photo);

@interface PhotoPreviewController : UIViewController

@property(nonatomic, strong) PhotoOldListItem* item;
@property(nonatomic, strong) PHAsset* asset;

- (void)setChoosedAssetImageBlock:(ChoosePHAssetImage)chooseBlock;

@end
