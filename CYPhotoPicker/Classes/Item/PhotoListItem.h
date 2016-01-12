//
//  PhotoListItem.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/8.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoCollectionBaseCell.h"
#import "CYPhotoPickerDefines.h"

@interface PhotoListItem : NSObject
@property (nonatomic, strong) UIImage* thumbImage;
@property (nonatomic, strong) PHAsset* asset;
@property (nonatomic, strong) ALAsset* alAsset;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface PhotoListItemCell : PhotoCollectionBaseCell

@end
