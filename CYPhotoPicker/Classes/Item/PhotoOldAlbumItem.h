//
//  PhotoOldAlbumItem.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

@interface PhotoOldAlbumItem : NSObject
@property (nonatomic, strong) ALAssetsGroup* group;
@property (nonatomic, strong) UIImage* thumbImage;
@end


@interface PhotoOldAlbumItemCell : UITableViewCell
- (void)phCellShouldUpdateWithObject:(id)obj;
@end