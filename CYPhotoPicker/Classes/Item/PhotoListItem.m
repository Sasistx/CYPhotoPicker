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
            
            [[PhotoPickerManager sharedManager] syncTumbnailWithSize:CGSizeMake(40, 40) asset:item.asset completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
                
                _self.thumbImageView.image = resultImage;
                item.thumbImage = resultImage;
            }];
        }
    }
    
    self.selectedIcon.hidden = !item.isSelected;
    self.blackCoverView.hidden = !item.isSelected;
}

@end