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
        
        _blackCoverView = [[UIView alloc] initWithFrame:CGRectMake(2.5, 5, self.frame.size.width - 5, self.frame.size.height - 5)];
        [_blackCoverView setBackgroundColor:[UIColor blackColor]];
        [_blackCoverView setAlpha:0.3];
        [self.contentView addSubview:_blackCoverView];
        _blackCoverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _blackCoverView.hidden = YES;
        
        _selectedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, 7, 25, 25)];
        
        UIColor* backColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor ? [PhotoConfigureManager sharedManager].buttonBackgroundColor : [UIColor blackColor];
        UIImage* originImage = [UIImage imageNamed:@"ph_photo_selected_round"];
        UIImage* currentImage = [PhotoUtility originImage:originImage tintColor:backColor blendMode:kCGBlendModeDestinationIn];
        [_selectedIcon setImage:currentImage];
        _selectedIcon.hidden = YES;
        _selectedIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        UIImageView* upperImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _selectedIcon.frame.size.width, _selectedIcon.frame.size.height)];
        [upperImageView setImage:[UIImage imageNamed:@"ph_photo_selected_arrow"]];
        [_selectedIcon addSubview:upperImageView];
        
        UIButton* selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setFrame:CGRectMake(_selectedIcon.frame.origin.x - 5, _selectedIcon.frame.origin.y - 5, _selectedIcon.frame.size.width + 10, _selectedIcon.frame.size.height + 10)];
        [selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectButton];
        
        [self.contentView insertSubview:_selectedIcon aboveSubview:_blackCoverView];
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
