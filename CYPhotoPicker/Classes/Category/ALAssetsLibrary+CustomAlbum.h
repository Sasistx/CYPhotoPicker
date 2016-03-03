//
//  ALAssetsLibrary+CustomAlbum.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/2/24.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

@interface ALAssetsLibrary (CustomAlbum)
- (void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
@end
