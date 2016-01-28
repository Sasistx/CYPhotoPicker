//
//  PhotoBaseListItem.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/27.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoItemCellProtocol.h"

@interface PhotoBaseListItem : NSObject
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIImage* thumbImage;
@property (nonatomic, weak) id <PhotoItemCellProtocol> delegate;
@end
