//
//  PhotoPreviewZoomScrollView.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/20.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPreviewZoomScrollView : UIScrollView
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) id asset;
- (void)clearZoomView;
- (BOOL)isImageLoading;
@end
