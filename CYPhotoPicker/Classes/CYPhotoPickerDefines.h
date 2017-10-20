//
//  CYPhotoPickerDefines.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/7.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#ifndef CYPhotoPickerDefines_h
#define CYPhotoPickerDefines_h

#define PH_RGBCOLOR_HEX(hexColor) [UIColor colorWithRed: (((hexColor >> 16) & 0xFF))/255.0f         \
green: (((hexColor >> 8) & 0xFF))/255.0f          \
blue: ((hexColor & 0xFF))/255.0f                 \
alpha: 1]

#define PH_IOSOVER(v) ([[UIDevice currentDevice].systemVersion floatValue] >= v)

#define kPHSendBtnColor [UIColor colorWithRed:27/255.0 green:125/255.0 blue:174/255.0 alpha:1]
#define kPHSendBtnBorderColor [UIColor clearColor]

#define kCYAlbumItemCellHeight 60

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#import <Photos/Photos.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "PhotoPickerManager.h"
#import "PhotoConfigureManager.h"

typedef NS_ENUM(NSInteger, PhotoPickerOption)
{
    PhotoPickerOptionAlbum            =   1 << 0,
    PhotoPickerOptionCamera           =   1 << 1,
};

typedef NS_ENUM(NSInteger, PhotoPickerDenyType)
{
    PhotoPickerDenyTypeAlbum            =   1 << 0,
    PhotoPickerDenyTypeCamera           =   1 << 1,
};

typedef void (^PhotoPickerDismissBlock)(NSArray *imageAssets);

typedef void (^PhotoPickerPermissionDeniedBlock)(PhotoPickerDenyType denyType);

#endif /* CYPhotoPickerDefines_h */


