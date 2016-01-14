//
//  PhotoOldAlbumItem.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoOldAlbumItem.h"

@implementation PhotoOldAlbumItem

@end


@implementation PhotoOldAlbumItemCell

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
    PhotoOldAlbumItem* item = obj;
    [item.group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [item.group numberOfAssets];
    
    self.textLabel.text = [NSString stringWithFormat:@"%@ (%zi)",[item.group valueForProperty:ALAssetsGroupPropertyName], gCount];
    [self.imageView setImage:[UIImage imageWithCGImage:[item.group posterImage]]];
}

@end