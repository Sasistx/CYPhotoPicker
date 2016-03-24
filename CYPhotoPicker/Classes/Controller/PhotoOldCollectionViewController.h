//
//  PhotoOldCollectionViewController.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

@interface PhotoOldCollectionViewController : UIViewController

@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@property (nonatomic, assign) BOOL isOne;               //default is NO
@property (nonatomic, assign) BOOL showPreview;         //default is NO  多选照片功能赞不支持预览功能
@property (nonatomic, assign) BOOL showCamera;          //default is NO
@property (strong, nonatomic) ALAssetsGroup* assetGroup;
@property (nonatomic, assign) NSInteger imageMaxCount;
@end
