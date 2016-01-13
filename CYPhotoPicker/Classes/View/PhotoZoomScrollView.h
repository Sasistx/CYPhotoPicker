//
//  PhotoZoomScrollView.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoZoomScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *imageView;

- (void)setZoomImageView:(UIImage*)image;

@end
