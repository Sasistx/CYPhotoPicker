//
//  PhotoPickerManager.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import "PhotoPickerManager.h"
#import "CYPhotoPickerDefines.h"
#import "PhotoUtility.h"
#import "PhotoListItem.h"
#import "ALAssetsLibrary+CustomAlbum.h"

static NSString* saveAlbumName = @"春雨";

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
    [self syncTumbnailWithSize:size asset:asset allowCache:NO completion:completion];
}

- (void)syncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset allowCache:(BOOL)allowCache completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion
{
    [self getImageWithSize:size asset:asset allowNetwork:NO allowCache:allowCache synchronous:YES multyCallBack:NO completion:completion];
}

- (void)asyncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset allowNetwork:(BOOL)allowNetwork multyCallBack:(BOOL)multiCallback completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion
{
    [self asyncTumbnailWithSize:size asset:asset allowNetwork:allowNetwork allowCache:YES multyCallBack:multiCallback completion:completion];
}

- (void)asyncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset allowNetwork:(BOOL)allowNetwork allowCache:(BOOL)allowCache multyCallBack:(BOOL)multiCallback completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion
{
    [self getImageWithSize:size asset:asset allowNetwork:allowNetwork allowCache:allowCache synchronous:NO multyCallBack:multiCallback completion:completion];
}

- (void)getImageWithSize:(CGSize)size asset:(PHAsset*)asset allowNetwork:(BOOL)allowNetwork allowCache:(BOOL)allowCache synchronous:(BOOL)synchronous multyCallBack:(BOOL)multiCallback completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion
{
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    if (!synchronous) {
        
        phImageRequestOptions.deliveryMode = multiCallback ? PHImageRequestOptionsDeliveryModeOpportunistic : PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    phImageRequestOptions.synchronous = synchronous;
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    phImageRequestOptions.networkAccessAllowed = synchronous ? NO : allowNetwork;
    //    phImageRequestOptions.progressHandler = ^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info) {
    //
    //
    //    };
    if (allowCache) {
        
        [imageManager startCachingImagesForAssets:@[asset] targetSize:size contentMode:PHImageContentModeDefault options:phImageRequestOptions];
    }
    
    [imageManager requestImageForAsset:asset
                            targetSize:size
                           contentMode:PHImageContentModeAspectFit
                               options:phImageRequestOptions
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             
                             if (completion) {
                                 
                                 completion(result, info);
                             }
                         }];
}


- (void)getImageDataWithSize:(CGSize)size asset:(PHAsset*)asset allowNetwork:(BOOL)allowNetwork allowCache:(BOOL)allowCache synchronous:(BOOL)synchronous multyCallBack:(BOOL)multiCallback completion:(void (^)(NSData* imageData,NSString * dataUTI, UIImageOrientation orientation ,NSDictionary *resultInfo))completion{

    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    if (!synchronous) {
        
        phImageRequestOptions.deliveryMode = multiCallback ? PHImageRequestOptionsDeliveryModeOpportunistic : PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    phImageRequestOptions.synchronous = synchronous;
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    phImageRequestOptions.networkAccessAllowed = synchronous ? NO : allowNetwork;
    if (allowCache) {
        
        [imageManager startCachingImagesForAssets:@[asset] targetSize:size contentMode:PHImageContentModeDefault options:phImageRequestOptions];
    }
    
    [imageManager requestImageDataForAsset:asset options:phImageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        if (completion) {
            
            completion(imageData, dataUTI, orientation, info);
        }
    }];
}

- (void)asyncGetAllSelectedOriginImages:(void (^)(NSArray* images))completion
{
    @weakify(self);
    __block NSMutableArray* imageAssets = [self.selectedArray copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        __block NSMutableArray* images = [NSMutableArray array];
        [imageAssets enumerateObjectsUsingBlock:^(PHAsset* asset, NSUInteger idx, BOOL * _Nonnull stop) {
           
            @strongify(self);
            [self syncTumbnailWithSize:PHImageManagerMaximumSize asset:asset  completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
                
                [images addObject:resultImage];
            }];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            completion(images);
        });
    });
}

- (void)asyncGetOriginImageWithAsset:(id)asset completion:(void (^)(UIImage* image))completion
{
    if (((PhotoBaseListItem*)asset).originImage) {
        
        if (completion) {
            
            completion(((PhotoBaseListItem*)asset).originImage);
        }
        
        return;
    }
    
    if ([asset isKindOfClass:[PhotoListItem class]]) {
        
        PHAsset* innerAsset = ((PhotoListItem*)asset).asset;
        
        [self asyncTumbnailWithSize:PHImageManagerMaximumSize asset:innerAsset allowNetwork:YES allowCache:YES multyCallBack:NO completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
            if (completion) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(resultImage);
                });
            }
        }];
        
    } else if ([asset isKindOfClass:[PHAsset class]]){
    
        
    } else {
        
        if (completion) {
            completion(nil);
        }
    }
}

- (void)saveImage:(nonnull UIImage*)image toAlbum:(nonnull NSString*)album completion:(SaveImageCompletion)completion
{
    @weakify(self);
    PHAssetCollection* albumCollection = [self checkCollectionWithAlbumName:album];
    
    if (albumCollection) {
        
        [self saveImage:image toCollection:albumCollection completion:completion];
    }else {
        
        __block PHAssetCollectionChangeRequest* request = nil;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:album ? album : saveAlbumName];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                
                __block PHFetchResult* result = nil;
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    
                    result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[request.placeholderForCreatedAssetCollection.localIdentifier] options:nil];
                    
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    
                    @strongify(self);
                    if (result.count > 0) {
                        [self saveImage:image toCollection:result.firstObject completion:completion];
                    }
                }];
                
            }else {
                
                if (completion) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        completion(error);
                    });
                }
            }
        }];
    }
}

- (PHAssetCollection*)checkCollectionWithAlbumName:(NSString*)albumName
{
    __block PHAssetCollection* albumCollection = nil;
    
    PHFetchResult* result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[PHAssetCollection class]]) {
            
            PHAssetCollection* collection = obj;
            if ([collection.localizedTitle isEqualToString:albumName]) {
                
                albumCollection = collection;
                *stop = YES;
            }
        }
    }];
    
    return albumCollection;
}

- (void)saveImage:(UIImage*)image toCollection:(PHAssetCollection*)collection completion:(SaveImageCompletion)completion
{
    __block NSString* assetId = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHAssetChangeRequest* request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        assetId = request.placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (assetId) {
            
            if (success) {
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    
                    PHAssetCollectionChangeRequest* request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                    
                    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
                    [request addAssets:@[asset]];
                    
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    
                    if (completion) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            completion(error);
                        });
                    }
                }];
            }
        }else {
            completion(error);
        }
    }];
}


- (void)checkOriginalImageExistWithAsset:(PHAsset*)asset completion:(CheckOriginalImageResult)completion
{
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    phImageRequestOptions.synchronous = YES;
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    phImageRequestOptions.networkAccessAllowed = NO;
    [imageManager requestImageForAsset:asset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeAspectFill
                               options:phImageRequestOptions
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             
                             // 获得UIImage
                             if (completion) {
                                 
                                 BOOL exist = result ? YES : NO;
                                 completion(result, info, exist);
                             }
                         }];
}

- (void)cancelRequestByRequestId:(PHImageRequestID)requestId
{
    
}

@end
