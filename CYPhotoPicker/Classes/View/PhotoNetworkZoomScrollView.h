//
//  PhotoNetworkZoomScrollView.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/7/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoNetworkItem.h"
#import "PhotoPreviewNetworkImageController.h"

@interface PhotoNetworkZoomScrollView : UIScrollView

@property (nonatomic, strong) PhotoNetworkItem* item;
@property (nonatomic, weak) PhotoPreviewNetworkImageController* currentController;

- (void)clearZoomView;

@end
