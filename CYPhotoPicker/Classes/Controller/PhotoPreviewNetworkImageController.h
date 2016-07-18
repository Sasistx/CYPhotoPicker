//
//  PhotoPreviewNetworkImageController.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/7/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoNetworkItem.h"

@interface PhotoPreviewNetworkImageController : UIViewController
@property (nonatomic, strong) NSArray <PhotoNetworkItem *> * images;
@property (nonatomic, strong) NSIndexPath* indexPath;
@end
