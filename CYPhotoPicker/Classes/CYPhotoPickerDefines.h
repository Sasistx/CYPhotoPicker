//
//  CYPhotoPickerDefines.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/7.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#ifndef CYPhotoPickerDefines_h
#define CYPhotoPickerDefines_h

#define PH_WEAK_VAR(v) \
__weak typeof(v) _##v = v

#define PH_RGBCOLOR_HEX(hexColor) [UIColor colorWithRed: (((hexColor >> 16) & 0xFF))/255.0f         \
green: (((hexColor >> 8) & 0xFF))/255.0f          \
blue: ((hexColor & 0xFF))/255.0f                 \
alpha: 1]

#define PH_IOSOVER(v) ([[UIDevice currentDevice].systemVersion floatValue] >= v)

#import <Photos/Photos.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "PhotoPickerManager.h"


typedef void (^PhotoPickerDismissBlock)(NSArray *images);

#endif /* CYPhotoPickerDefines_h */