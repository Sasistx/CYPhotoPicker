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
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat downloadPercent;
@property (nonatomic, strong) UIImage* thumbImage;
@property (nonatomic, strong) UIImage* originImage;
@property (nonatomic, weak) id <PhotoItemCellProtocol> delegate;
@end
