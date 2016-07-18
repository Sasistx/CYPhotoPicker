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
    _zoomView = [[PhotoPreviewZoomScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _zoomView.scrollEnabled = YES;
    [self.contentView addSubview:_zoomView];
}

- (void)setAssetToZoomView:(id)asset
{
    [_zoomView setAsset:asset];
}

- (BOOL)isOriginImageLoading
{
    return [_zoomView isImageLoading];
}

- (void)loadOriginImage
{
    [_zoomView loadOriginImage];
}

- (void)prepareForReuse
{
    [_zoomView clearZoomView];
}

@end
