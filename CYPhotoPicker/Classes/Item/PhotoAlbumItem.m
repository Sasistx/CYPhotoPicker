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
@property (nonatomic, strong) UIImageView* thumbImageView;
@property (nonatomic, strong) UILabel* thumbTitle;
@end

@implementation PhotoAlbumItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 60, 60)];
        [self.contentView addSubview:_thumbImageView];
        
        _thumbTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, [UIScreen mainScreen].bounds.size.width - 90 - 20, 30)];
        [_thumbTitle setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_thumbTitle];
    }
    return self;
}

- (void)phCellShouldUpdateWithObject:(id)obj
{
    self.item = obj;
    
    __block PhotoAlbumItem* item = obj;
    __block PHAsset *asset = item.assetsFetchResult[0];
    
    [self.thumbTitle setText:[NSString stringWithFormat:@"%@(%zi)", item.collection.localizedTitle, item.assetsFetchResult.count]];
    
    if (item.thumbImage) {
        
        [self.imageView setImage:item.thumbImage];
    }else {
        
        @weakify(self);
        [[PhotoPickerManager sharedManager] asyncTumbnailWithSize:CGSizeMake(200, 200) asset:asset allowNetwork:YES multyCallBack:NO completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
            
            @strongify(self);
            PhotoAlbumItem* currentItem = self.item;
            
            if (currentItem.assetsFetchResult > 0) {
                
                PHAsset* currentAsset = currentItem.assetsFetchResult[0];
                if ([asset.localIdentifier isEqualToString:currentAsset.localIdentifier]) {
                    
                    [self.thumbImageView setImage:resultImage];
                }
            }

            item.thumbImage = resultImage;
            [self.contentView layoutIfNeeded];
        }];
    }
}


@end