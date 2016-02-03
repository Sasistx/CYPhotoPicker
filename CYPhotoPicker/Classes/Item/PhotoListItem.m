//
//  PhotoListItem.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/8.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoListItem.h"
#import "CYPhotoPickerDefines.h"

@implementation PhotoListItem

@end


@interface PhotoListItemCell ()
@end

@implementation PhotoListItemCell

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
    PH_WEAK_VAR(self);
    __block PhotoListItem *item = obj;
    if (item.thumbImage) {
        self.thumbImageView.image = item.thumbImage;
    }else {
        if (item.asset) {
            
            [[PhotoPickerManager sharedManager] asyncTumbnailWithSize:CGSizeMake(200, 200) asset:item.asset completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
                
                _self.thumbImageView.image = resultImage;
                item.thumbImage = resultImage;
            }];
        }
    }
    
    self.selectButton.selected = item.isSelected;
    self.blackCoverView.hidden = !item.isSelected;
}

- (void)selectButtonClicked:(id)sender
{
    PhotoListItem* item = self.item;
    if ([item.delegate respondsToSelector:@selector(didTapImageInCell:object:)]) {
        
        [item.delegate didTapImageInCell:self object:item];
    }
}

@end