//
//  PhotoUtility.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYPhotoPickerDefines.h"

typedef void (^PhotoFailureBlock)(NSError *error);

@interface PhotoUtility : NSObject

+ (void)loadChunyuPhoto:(ALAsset *)asset success:(void(^)(UIImage *image))success failure:(PhotoFailureBlock)failure;

@end
