//
//  PhotoPreviewImageViewController.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/18.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"
#import "PhotoOldListItem.h"
#import "PhotoListItem.h"

typedef void(^ChoosePHAssetImage)(NSArray* photos);

@interface PhotoPreviewImageViewController : UIViewController

@property (nonatomic, strong) PhotoOldListItem* item;
@property (nonatomic, strong) PhotoListItem* phItem;

- (void)setChoosedAssetImageBlock:(ChoosePHAssetImage)chooseBlock;

@end
