
//
//  PhotoPreviewZoomScrollView.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/20.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoPreviewZoomScrollView.h"
#import "CYPhotoPickerDefines.h"
#import "PhotoListItem.h"
#import "PhotoOldListItem.h"
#import "PhotoPickerManager.h"

@interface PhotoPreviewZoomScrollView () <UIScrollViewDelegate>

/**
 *  default is hidden
 */
@property (nonatomic, strong) UIView* loadingBackView;
@property (nonatomic, strong) UIActivityIndicatorView* loadingView;
@property (nonatomic, strong) UIImageView* thumbImageView;

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

- (void)loadOriginImage
{
    __block id innerAsset = _asset;
    
    PH_WEAK_VAR(self);
    
    [[PhotoPickerManager sharedManager] asyncGetOriginImageWithAsset:_asset completion:^(UIImage *image) {
        
        if ([innerAsset isEqual:_self.asset]) {
            
            [_self hideLoadingView];
            [_self setZoomImageView:image];
        }
    }];
}

- (void)showThumbImage:(UIImage*)image
{
    if (_thumbImageView) {
        
        return;
    }
    
    _thumbImageView = [self zoomViewWithImage:image];
    [self addSubview:_thumbImageView];
    [_thumbImageView setCenter:self.center];
}

- (void)hideThumbImage
{
    [self bringSubviewToFront:_thumbImageView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        if (_thumbImageView) {
            
            [_thumbImageView setAlpha:0];
        }
    } completion:^(BOOL finished) {
        if (_thumbImageView) {
            
            [_thumbImageView removeFromSuperview];
            _thumbImageView = nil;
        }
    }];
}

- (void)getZoomImage
{
    PH_WEAK_VAR(self);
    
    __block id innerAsset = _asset;
    
    if (PH_IOSOVER(8)) {
        
        [self showLoadingView];
        
        PHAsset* phAsset = ((PhotoListItem*)_asset).asset;
        [[PhotoPickerManager sharedManager] asyncTumbnailWithSize:CGSizeMake(150, 150) asset:phAsset allowNetwork:YES allowCache:YES multyCallBack:NO completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
        
            if ([innerAsset isEqual:_self.asset]) {
                
                [_self showThumbImage:resultImage];
            }
        }];
    }else {
    
        [self showLoadingView];
        [[PhotoPickerManager sharedManager] asyncGetOriginImageWithAsset:_asset completion:^(UIImage *image) {
            
            if ([innerAsset isEqual:_self.asset]) {
                
                [_self hideLoadingView];
                [_self setZoomImageView:image];
            }
        }];
    }
}

- (void)setZoomImageView:(UIImage*)image
{
    if (_imageView) {
        
        return;
    }
    
    _imageView = [self zoomViewWithImage:image];
    [self addSubview:_imageView];
    [self hideThumbImage];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [_imageView addGestureRecognizer:doubleTapGesture];
    [self setMinimumZoomScale:0.7];
    [self setMaximumZoomScale:1.5];
    [self setZoomScale:1];
    [self updateZoomCenter];
    [self layoutIfNeeded];
}

- (UIImageView*)zoomViewWithImage:(UIImage*)image
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat factor = self.frame.size.width / self.frame.size.height;
    
    CGFloat imageFactor = image.size.width / image.size.height;
    
    CGFloat imageViewWidth = 0;
    CGFloat imageViewHeight = 0;
    
    if (imageFactor >= factor) {
        
        imageViewWidth = self.frame.size.width;
        imageViewHeight = imageView.frame.size.height / imageView.frame.size.width * self.frame.size.width;
    }else {
        imageViewHeight = self.frame.size.height;
        imageViewWidth = imageView.frame.size.width / imageView.frame.size.height * self.frame.size.height;
    }
    imageView.userInteractionEnabled = YES;
    [imageView setFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    
    return imageView;
}

- (void)clearZoomView
{
    if (self.zoomScale != 1) {
        CGRect zoomRect = [self zoomRectForScale:1 withCenter:self.center];
        [self zoomToRect:zoomRect animated:NO];
    }
    
    if (_imageView) {
        
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
    
    if (_thumbImageView) {
        
        [_thumbImageView removeFromSuperview];
        _thumbImageView = nil;
    }
}

#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    CGFloat newScale = self.zoomScale != 1 ? 1 : 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:self.center];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
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
    [self updateZoomCenter];
}

- (void)updateZoomCenter
{
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                    self.contentSize.height * 0.5 + offsetY);
}

#pragma mark - Loading view

- (UIView*)loadingBackView
{
    if (!_loadingBackView) {
        
        _loadingBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_loadingBackView];
        [_loadingBackView setHidden:YES];
        
        _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_loadingView setCenter:_loadingBackView.center];
        [_loadingBackView addSubview:_loadingView];
        [_loadingView stopAnimating];
    }
    return _loadingBackView;
}

- (UIImageView*)thumbImageView
{
    if (!_thumbImageView) {
        
        _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _thumbImageView;
}

- (void)showLoadingView
{
    [self.loadingBackView setHidden:NO];
    [self.loadingView startAnimating];
    [self bringSubviewToFront:self.loadingBackView];
}

- (void)hideLoadingView
{
    [self.loadingBackView setHidden:YES];
    [self.loadingView stopAnimating];
}

- (BOOL)isImageLoading
{
    return !self.loadingBackView.hidden;
}

@end
