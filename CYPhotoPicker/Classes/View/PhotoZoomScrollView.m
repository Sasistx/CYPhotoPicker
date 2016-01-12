//
//  PhotoZoomScrollView.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoZoomScrollView.h"

@implementation PhotoZoomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}

- (void)setZoomImageView:(UIImage*)image
{
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
