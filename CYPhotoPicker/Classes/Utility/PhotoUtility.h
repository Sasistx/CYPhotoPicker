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

+ (void)loadChunyuPhoto:(id)item success:(void(^)(UIImage *image))success failure:(PhotoFailureBlock)failure;

+ (UIImage*)imageWithColor:(UIColor*)color;

+ (UIImage*)originImage:(UIImage*)originImage tintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

+ (UIImage*)combineSameSizeImageWithContextImage:(UIImage*)contextImage headerImage:(UIImage*)headerImage;

+ (BOOL)isLocalUrlString:(NSString*)urlStr;

+ (void)showAlertWithMsg:(NSString*)msg controller:(UIViewController*)controller;

@end
