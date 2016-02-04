//
//  PhotoCollectionBaseCell.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoCollectionBaseCell.h"
#import "PhotoUtility.h"

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
        
        UIImage* arrowImage = [UIImage imageNamed:@"ph_photo_selected_arrow"];
        
        UIColor* selectColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor;
        
        UIImage* selectBackImage = [PhotoUtility originImage:[UIImage imageNamed:@"ph_photo_selected_round"] tintColor:selectColor blendMode:kCGBlendModeDestinationIn];
        
        UIImage* deselectBackImage = [PhotoUtility originImage:[UIImage imageNamed:@"ph_photo_selected_round"] tintColor:[UIColor clearColor] blendMode:kCGBlendModeDestinationIn];
        
        UIImage* currentSelectImage = [PhotoUtility combineSameSizeImageWithContextImage:selectBackImage headerImage:arrowImage];
        
        UIImage* currentDeselectedImage = [PhotoUtility combineSameSizeImageWithContextImage:deselectBackImage headerImage:arrowImage];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setFrame:CGRectMake(self.frame.size.width - 35, 7, 30, 30)];
        [_selectButton setImage:currentSelectImage forState:UIControlStateSelected];
        [_selectButton setImage:currentDeselectedImage forState:UIControlStateNormal];
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
    self.thumbImageView.image = nil;
}

- (void)selectButtonClicked:(id)sender
{
    //need override
}

@end
