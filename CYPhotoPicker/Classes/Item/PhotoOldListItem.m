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
    if (item.thumbImage) {
        self.thumbImageView.image = item.thumbImage;
    }
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