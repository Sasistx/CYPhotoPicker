//
//  PhotoOldAlbumViewController.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

@interface PhotoOldAlbumViewController : UIViewController
@property (nonatomic, assign) BOOL isOne;
@property (nonatomic, assign) BOOL showPreview;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@end
