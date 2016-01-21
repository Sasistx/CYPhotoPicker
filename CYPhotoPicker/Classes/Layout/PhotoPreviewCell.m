//
//  PhotoPreviewCell.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/20.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoPreviewCell.h"
#import "PhotoPreviewZoomScrollView.h"

@interface PhotoPreviewCell ()
@property (nonatomic, strong) PhotoPreviewZoomScrollView* zoomView;
@end

@implementation PhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createZoomView];
    }
    return self;
}

- (void)createZoomView
{
    _zoomView = [[PhotoPreviewZoomScrollView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:_zoomView];
}

- (void)setAssetToZoomView:(id)asset
{
    [_zoomView setAsset:asset];
}

@end
