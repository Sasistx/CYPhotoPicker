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

@property (nonatomic, copy) NSString* urlStr;
@property (nonatomic, strong) UIImage* thumbImage;

@end


@interface PhotoOldListItemCell : PhotoCollectionBaseCell

@end