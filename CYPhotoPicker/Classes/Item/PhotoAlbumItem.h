//
//  PhotoAlbumItem.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/11.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYPhotoPickerDefines.h"

@interface PhotoAlbumItem : NSObject
@property (nonatomic, strong) PHAssetCollection* collection;
@property (nonatomic, strong) PHAsset* asset;
@property (nonatomic, strong) PHFetchResult* assetsFetchResult;
@property (nonatomic, strong) UIImage* thumbImage;
@end


@interface PhotoAlbumItemCell : UITableViewCell
- (void)phCellShouldUpdateWithObject:(id)obj;
@end