//
//  PhotoCollectionViewCell.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/8.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

#pragma mark - Accessors
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        
        _cellImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _cellImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _cellImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _cellImageView;
}


#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.cellImageView];
    }
    return self;
}

@end
