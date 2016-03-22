//
//  PhotoAlbumListController.h
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

@interface PhotoAlbumListController : UIViewController
@property (nonatomic, assign) BOOL isOne;               //default is NO
@property (nonatomic, assign) BOOL showPreview;         //default is NO
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@end
