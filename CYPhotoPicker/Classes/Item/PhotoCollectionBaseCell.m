//
//  PhotoCollectionBaseCell.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoCollectionBaseCell.h"

@implementation PhotoCollectionBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _thumbImageView = [[UIImageView alloc] initWithFrame: CGRectMake(2.5, 5, self.frame.size.width-5, self.frame.size.height-5)];
        _thumbImageView.backgroundColor = PH_RGBCOLOR_HEX(0xdddddd);
        [self.contentView addSubview:_thumbImageView];
        
        _blackCoverView = [[UIView alloc] initWithFrame:CGRectMake(2.5, 5, self.frame.size.width - 5, self.frame.size.height - 5)];
        [_blackCoverView setBackgroundColor:[UIColor blackColor]];
        [_blackCoverView setAlpha:0.3];
        [self.contentView addSubview:_blackCoverView];
        _blackCoverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _blackCoverView.hidden = YES;
        
        _selectedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, 7, 25, 25)];
        [_selectedIcon setImage:[UIImage imageNamed:@"ph_photo_selected_arrow"]];
        _selectedIcon.hidden = YES;
        _selectedIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView insertSubview:_selectedIcon aboveSubview:_blackCoverView];
    }
    return self;
}

- (void)shouldUpdateItemCellWithObject:(id)obj
{
    //
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.thumbImageView.image = nil;
}

@end
