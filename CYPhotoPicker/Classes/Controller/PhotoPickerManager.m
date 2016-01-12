//
//  PhotoPickerManager.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import "PhotoPickerManager.h"
#import "CYPhotoPickerDefines.h"

@interface PhotoPickerManager ()

@end

@implementation PhotoPickerManager

static PhotoPickerManager* sharedManager = nil;

+ (PhotoPickerManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PhotoPickerManager alloc] init];
        
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _selectedArray = [NSMutableArray array];
    }
    return self;
}

- (void)clearSelectedArray
{
    [self.selectedArray removeAllObjects];
}

- (void)syncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion
{
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
//    phImageRequestOptions.progressHandler = ^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info) {
//        
//        
//    };
    
    [imageManager requestImageForAsset:asset
                            targetSize:size
                           contentMode:PHImageContentModeAspectFill
                               options:phImageRequestOptions
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             
                             // 获得UIImage
                             if (completion) {
                                 
                                 completion(result, info);
                             }
                        }];
}

- (void)syncGetAllSelectedOriginImages:(void (^)(NSArray* images))completion
{
    PH_WEAK_VAR(self);
    __block NSMutableArray* imageAssets = self.selectedArray;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        __block NSMutableArray* images = [NSMutableArray array];
        [imageAssets enumerateObjectsUsingBlock:^(PHAsset* asset, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [_self syncTumbnailWithSize:PHImageManagerMaximumSize asset:asset completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
                
                [images addObject:resultImage];
            }];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            completion(images);
        });
    });
}

@end
