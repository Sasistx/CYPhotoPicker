//
//  PhotoNetworkPreviewCell.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/7/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoNetworkPreviewCell.h"
#import "PhotoNetworkZoomScrollView.h"

@interface PhotoNetworkPreviewCell ()
@property (nonatomic, strong) PhotoNetworkZoomScrollView* zoomView;
@end

@implementation PhotoNetworkPreviewCell

- (void)setCurrentController:(PhotoPreviewNetworkImageController *)currentController
{
    if (_currentController) {
        
        _currentController = nil;
    }
    _currentController = currentController;
    _zoomView.currentController = currentController;
}


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
    _zoomView = [[PhotoNetworkZoomScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _zoomView.scrollEnabled = YES;
    _zoomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_zoomView];
}

- (void)setItemToZoomView:(PhotoNetworkItem*)item
{
    [_zoomView setItem:item];
}

- (void)prepareForReuse
{
    [_zoomView clearZoomView];
}

@end
