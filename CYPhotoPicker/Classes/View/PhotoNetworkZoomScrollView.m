//
//  PhotoNetworkZoomScrollView.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/7/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoNetworkZoomScrollView.h"
#import "UIImageView+WebCache.h"
#import "CYPhotoPickerDefines.h"

@interface PhotoNetworkZoomScrollView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation PhotoNetworkZoomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
    }
    return self;
}

- (void)setItem:(PhotoNetworkItem *)item
{
    if (_item) {
        _item = nil;
    }
    _item = item;
    
    [self setZoomImageView:item];
}

- (void)setZoomImageView:(PhotoNetworkItem*)image
{
    if (_imageView) {
        
        return;
    }
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    if (_item.originImage) {
        
        [self updateZoomImage:_item.originImage];
    }else {
    
        PH_WEAK_VAR(self);
        [_imageView setShowActivityIndicatorView:YES];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                
                [_self updateZoomImage:image];
            }else {
                
            }
            
        }];
    }
    [self addSubview:_imageView];
    
//    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                       action:@selector(handleDoubleTap:)];
//    [doubleTapGesture setNumberOfTapsRequired:2];
//    [_imageView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer* oneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneTap:)];
    [oneTapGesture setNumberOfTapsRequired:1];
    [_imageView addGestureRecognizer:oneTapGesture];
    
    [self setMinimumZoomScale:0.7];
    [self setMaximumZoomScale:1.5];
    [self setZoomScale:1];
    [self updateZoomCenter];
    [self layoutIfNeeded];
}

- (void)updateZoomImage:(UIImage*)image
{
    CGFloat factor = self.frame.size.width / self.frame.size.height;
    
    CGFloat imageFactor = image.size.width / image.size.height;
    
    CGFloat imageViewWidth = 0;
    CGFloat imageViewHeight = 0;
    
    if (imageFactor >= factor) {
        
        imageViewWidth = self.frame.size.width;
        imageViewHeight = _imageView.frame.size.width / imageFactor;
    }else {
        imageViewHeight = self.frame.size.height;
        imageViewWidth = _imageView.frame.size.height * imageFactor;
    }
    _imageView.userInteractionEnabled = YES;
    [_imageView setFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
//    [_imageView setCenter:self.center];
    [_imageView setImage:image];
    CGRect rect = [self zoomRectForScale:1 withCenter:self.center];
    [self zoomToRect:rect animated:YES];
}

#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    CGFloat newScale = self.zoomScale != 1 ? 1 : 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:self.center];
    [self zoomToRect:zoomRect animated:YES];
}

- (void)handleOneTap:(UIGestureRecognizer*)gesture
{
    if (_currentController) {
        
        [_currentController dismissViewControllerAnimated:NO completion:Nil];
    }
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
}

@end
