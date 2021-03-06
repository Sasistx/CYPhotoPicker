//
//  PhotoCollectionBaseCell.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoCollectionBaseCell.h"
#import "PhotoUtility.h"
#import "PhotoBaseListItem.h"

@implementation PhotoCollectionBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _thumbImageView = [[UIImageView alloc] initWithFrame: CGRectMake(2.5, 5, self.frame.size.width-5, self.frame.size.height-5)];
        _thumbImageView.backgroundColor = PH_RGBCOLOR_HEX(0xdddddd);
        [self.contentView addSubview:_thumbImageView];
        [_thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_thumbImageView setClipsToBounds:YES];
        
        _blackCoverView = [[UIView alloc] initWithFrame:CGRectMake(2.5, 5, self.frame.size.width - 5, self.frame.size.height - 5)];
        [_blackCoverView setBackgroundColor:[UIColor blackColor]];
        [_blackCoverView setAlpha:0.3];
        [self.contentView addSubview:_blackCoverView];
        _blackCoverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _blackCoverView.hidden = YES;
        
        UIColor* selectColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor;
        if (selectColor) {
            [_selectButton setButtonSelectBackgroundColor:selectColor];
        }
        _selectButton = [PHSelectButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setFrame:CGRectMake(self.frame.size.width - 35, 7, 30, 30)];
        [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
    }
    return self;
}

- (void)shouldUpdateItemCellWithObject:(id)obj
{
    self.item = obj;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (self.item) {
        ((PhotoBaseListItem*)self.item).thumbImage = nil;
    }
    self.thumbImageView.image = nil;
}

- (void)selectButtonClicked:(id)sender
{
    //need override
}

@end
