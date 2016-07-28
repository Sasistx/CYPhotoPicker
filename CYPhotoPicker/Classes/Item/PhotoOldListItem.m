//
//  PhotoOldListItem.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoOldListItem.h"

@implementation PhotoOldListItem

@end


@implementation PhotoOldListItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)shouldUpdateItemCellWithObject:(id)obj
{
    [super shouldUpdateItemCellWithObject:obj];
    
    __block PhotoOldListItem *item = obj;
    ALAssetsLibrary  *lib = [[ALAssetsLibrary alloc] init];
    @weakify(self);
    [lib assetForURL:item.url resultBlock:^(ALAsset *asset) {
        
        @strongify(self);
        PhotoOldListItem *innerItem = self.item;
        if ([[innerItem.url absoluteString] isEqualToString:[asset.defaultRepresentation.url absoluteString]]) {
            self.thumbImageView.image = [UIImage imageWithCGImage: asset.aspectRatioThumbnail];
            ((PhotoBaseListItem*)self.item).thumbImage = self.thumbImageView.image;
        }
    } failureBlock:^(NSError *error) {
        
    }];
    self.selectButton.selected = item.isSelected;
    self.blackCoverView.hidden = !item.isSelected;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.thumbImageView.image = nil;
}

- (void)selectButtonClicked:(id)sender
{
    PhotoOldListItem* item = self.item;
    if ([item.delegate respondsToSelector:@selector(didTapImageInCell:object:)]) {
        
        [item.delegate didTapImageInCell:self object:item];
    }
}

@end