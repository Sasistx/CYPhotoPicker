//
//  PhotoOldListItem.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoBaseListItem.h"
#import "PhotoCollectionBaseCell.h"

@interface PhotoOldListItem : PhotoBaseListItem
@property (nonatomic, copy) NSURL* url;
@end


@interface PhotoOldListItemCell : PhotoCollectionBaseCell

@end