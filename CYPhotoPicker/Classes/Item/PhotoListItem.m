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

@property (nonatomic, strong) UIView* cellMaskView;
@property (nonatomic, strong) UIActivityIndicatorView* activityView;

@end

@implementation PhotoListItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _cellMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_cellMaskView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        [self.contentView addSubview:_cellMaskView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width - 30) / 2 , (frame.size.width - 30) / 2, 30, 30)];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [_cellMaskView addSubview:_activityView];
        
        [_cellMaskView setHidden:YES];
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
            
            [[PhotoPickerManager sharedManager] asyncTumbnailWithSize:CGSizeMake(150, 150) asset:item.asset allowNetwork:YES allowCache:YES multyCallBack:NO completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
                
                PhotoListItem *currentItem = _self.item;
                if ([item.asset.localIdentifier isEqualToString:currentItem.asset.localIdentifier]) {
                    _self.thumbImageView.image = resultImage;
                }
            }];
        }
    }
    
    if (item.isLoading) {
        
        self.selectButton.hidden = YES;
        self.blackCoverView.hidden = YES;
        
        _cellMaskView.hidden = NO;
        [_activityView startAnimating];
    }else {
        _cellMaskView.hidden = YES;
        [_activityView stopAnimating];
        self.selectButton.hidden = NO;
        self.selectButton.selected = item.isSelected;
        self.blackCoverView.hidden = !item.isSelected;
    }
}

- (void)selectButtonClicked:(id)sender
{
    PhotoListItem* item = self.item;
    if ([item.delegate respondsToSelector:@selector(didTapImageInCell:object:)]) {
        
        [item.delegate didTapImageInCell:self object:item];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

@end