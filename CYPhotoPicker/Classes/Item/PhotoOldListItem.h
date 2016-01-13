//
//  PhotoOldListItem.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoCollectionBaseCell.h"

@interface PhotoOldListItem : NSObject

@property (nonatomic, copy) NSURL* url;
@property (nonatomic, strong) UIImage* thumbImage;
@property (nonatomic, strong) UIImage* originImage;
@property (nonatomic, assign) BOOL isSelected;

@end


@interface PhotoOldListItemCell : PhotoCollectionBaseCell

@end