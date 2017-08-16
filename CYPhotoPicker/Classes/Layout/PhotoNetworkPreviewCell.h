//
//  PhotoNetworkPreviewCell.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/7/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoNetworkItem.h"
#import "PhotoPreviewNetworkImageController.h"

@interface PhotoNetworkPreviewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* networkImageView;
@property (nonatomic, strong) PhotoNetworkItem* item;
@property (nonatomic, strong) UIImage* placeHolderImage;
@property (nonatomic, weak) PhotoPreviewNetworkImageController* currentController;
- (void)setItemToZoomView:(PhotoNetworkItem *)item;
@end
