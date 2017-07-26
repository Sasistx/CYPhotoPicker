//
//  PhotoScrollPreviewController.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/20.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

typedef void (^PhotoPreviewBackBlock)(void);

@interface PhotoScrollPreviewController : UIViewController
@property (nonatomic, copy) NSMutableArray* assets;
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@property (nonatomic, copy) NSIndexPath* indexPath;
@property (nonatomic, assign) NSInteger maxCount;

- (void)setPreviewBackBlock:(PhotoPreviewBackBlock)backBlock;

@end
