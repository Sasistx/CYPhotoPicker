//
//  PhotoScrollPreviewController.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/20.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

@interface PhotoScrollPreviewController : UIViewController
@property (nonatomic, strong) NSMutableArray* assets;
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@property (nonatomic, strong) NSIndexPath* indexPath;
@end
