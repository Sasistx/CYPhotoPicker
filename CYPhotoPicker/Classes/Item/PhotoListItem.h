//
//  PhotoListItem.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/8.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoBaseListItem.h"
#import "PhotoCollectionBaseCell.h"
#import "CYPhotoPickerDefines.h"

@interface PhotoListItem : PhotoBaseListItem
@property (nonatomic, strong) PHAsset* asset;
@end

@interface PhotoListItemCell : PhotoCollectionBaseCell

@end
