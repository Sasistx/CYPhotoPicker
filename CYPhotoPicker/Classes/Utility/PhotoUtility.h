//
//  PhotoUtility.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYPhotoPickerDefines.h"
#import "PhotoOldListItem.h"

typedef void (^PhotoFailureBlock)(NSError *error);

@interface PhotoUtility : NSObject

+ (void)loadChunyuPhoto:(PhotoOldListItem *)item success:(void(^)(UIImage *image))success failure:(PhotoFailureBlock)failure;

+ (UIImage*)imageWithColor:(UIColor*)color;

+ (UIImage*)originImage:(UIImage*)originImage tintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end
