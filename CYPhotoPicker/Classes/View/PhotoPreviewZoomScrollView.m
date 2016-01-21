
//
//  PhotoPreviewZoomScrollView.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/20.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoPreviewZoomScrollView.h"
#import "CYPhotoPickerDefines.h"
#import "PhotoOldListItem.h"
#import "PhotoPickerManager.h"

@interface PhotoPreviewZoomScrollView () <UIScrollViewDelegate>
@end

@implementation PhotoPreviewZoomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
    }
    return self;
}

- (void)setAsset:(id)asset
{
    if (_asset) {
        _asset = nil;
    }
    _asset = asset;
    [self getZoomImage];
}

- (void)getZoomImage
{
    PH_WEAK_VAR(self);
    __block id innerAsset = _asset;
    [[PhotoPickerManager sharedManager] asyncGetOriginImageWithAsset:_asset completion:^(UIImage *image) {
        
        if ([innerAsset isEqual:_self.asset]) {
            [_self setZoomImageView:image];
        }
    }];
}

- (void)setZoomImageView:(UIImage*)image
{
    if (_imageView) {
        
        return;
    }
    
    _imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat factor = self.frame.size.width / self.frame.size.height;
    
    CGFloat imageFactor = image.size.width / image.size.height;
    
    CGFloat imageViewWidth = 0;
    CGFloat imageViewHeight = 0;
    
    if (imageFactor >= factor) {
        
        imageViewWidth = self.frame.size.width;
        imageViewHeight = self.frame.size.height / _imageView.frame.size.width * self.frame.size.width;
    }else {
        imageViewHeight = self.frame.size.height;
        imageViewWidth = self.frame.size.width / _imageView.frame.size.height * self.frame.size.height;
    }
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [_imageView addGestureRecognizer:doubleTapGesture];
    
    CGFloat minimumScale = self.frame.size.width / _imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
    
    [self layoutIfNeeded];
}

- (void)clearZoomView
{
    if (_imageView) {
        
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    //暂未实现
    /*
     float newScale = self.zoomScale * 1.5;
     CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
     [self zoomToRect:zoomRect animated:YES];
     */
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                    self.contentSize.height * 0.5 + offsetY);
}

@end
