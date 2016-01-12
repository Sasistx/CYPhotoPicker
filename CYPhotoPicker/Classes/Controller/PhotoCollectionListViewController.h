//
//  PhotoCollectionListViewController.h
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "CYPhotoPickerDefines.h"

@interface PhotoCollectionListViewController : UIViewController
@property (nonatomic, strong) PHFetchResult* fetchResult;
@property (nonatomic, strong) PHAssetCollection* collection;
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@property (nonatomic, assign) BOOL isOne;               //default is NO
@property (nonatomic, assign) BOOL showPreview;         //default is NO  多选照片功能赞不支持预览功能
@end
