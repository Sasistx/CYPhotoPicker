//
//  PhotoAlbumItem.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/11.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoAlbumItem.h"

@implementation PhotoAlbumItem

@end

@interface PhotoAlbumItemCell()

@end

@implementation PhotoAlbumItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

- (void)phCellShouldUpdateWithObject:(id)obj
{
    PH_WEAK_VAR(self);
    __block PhotoAlbumItem* item = obj;
    PHAsset *asset = item.assetsFetchResult[0];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    [self.textLabel setText:[NSString stringWithFormat:@"%@(%lu)", item.collection.localizedTitle, item.assetsFetchResult.count]];
    
    if (item.thumbImage) {
        
        [_self.imageView setImage:item.thumbImage];
    }else {
        [[PhotoPickerManager sharedManager] syncTumbnailWithSize:CGSizeMake(25 * scale, 25* scale) asset:asset completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
//            [_self.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_self.imageView setImage:resultImage];
//            [_self.imageView layoutIfNeeded];
            item.thumbImage = resultImage;
        }];
    }
    
    
    //        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    //
    //        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    //        phImageRequestOptions.synchronous = YES;
    //
    //        [imageManager requestImageForAsset:asset
    //                                targetSize:CGSizeMake(50, 50)
    //                               contentMode:PHImageContentModeAspectFill
    //                                   options:phImageRequestOptions
    //                             resultHandler:^(UIImage *result, NSDictionary *info) {
    //
    //                                 // 得到一张 UIImage，展示到界面上
    //                                 [_self.imageView setImage:result];
    //                             }];
}


@end