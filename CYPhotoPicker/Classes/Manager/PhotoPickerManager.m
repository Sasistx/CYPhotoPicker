//
//  PhotoPickerManager.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import "PhotoPickerManager.h"
#import "CYPhotoPickerDefines.h"
#import "PhotoOldListItem.h"
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

- (void)asyncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion
{
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    phImageRequestOptions.synchronous = YES;
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
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

- (void)asyncGetAllSelectedOriginImages:(void (^)(NSArray* images))completion
{
    PH_WEAK_VAR(self);
    __block NSMutableArray* imageAssets = [self.selectedArray copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        __block NSMutableArray* images = [NSMutableArray array];
        [imageAssets enumerateObjectsUsingBlock:^(PHAsset* asset, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [_self asyncTumbnailWithSize:PHImageManagerMaximumSize asset:asset completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
                
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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            PHAsset* innerAsset = ((PhotoListItem*)asset).asset;
            
            [self asyncTumbnailWithSize:PHImageManagerMaximumSize asset:innerAsset completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (completion) {
                        
                        completion(resultImage);
                    }
                });
            }];
        });
        
    }else if ([asset isKindOfClass:[PhotoOldListItem class]]){
    
        [PhotoUtility loadChunyuPhoto:asset success:^(UIImage *image) {
            
            if (completion) {
                completion(image);
            }
        } failure:^(NSError *error) {
            if (completion) {
                completion(nil);
            }
        }];
    }else{
        if (completion) {
            completion(nil);
        }
    }
}

- (void)saveImage:(nonnull UIImage*)image toAlbum:(nonnull NSString*)album completion:(SaveImageCompletion)completion
{
    if (PH_IOSOVER(8)) {
        
        PH_WEAK_VAR(self);
        PHAssetCollection* albumCollection = [self checkCollectionWithAlbumName:album];
        
        if (albumCollection) {
            
            [_self saveImage:image toCollection:albumCollection completion:completion];
        }else {
        
            __block PHAssetCollectionChangeRequest* request = nil;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
                request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:saveAlbumName];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if (success) {
                    
                    __block PHFetchResult* result = nil;
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                       
                        result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[request.placeholderForCreatedAssetCollection] options:nil];
                        
                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        
                        
                        if (result.count > 0) {
                            [_self saveImage:image toCollection:result.firstObject completion:completion];
                        }
                    }];
                
                }else {
                    
                    if (completion) {
                        
                        completion(error);
                    }
                }
            }];
        }
        
    }else {
        
        //Old API
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library saveImage:image toAlbum:album withCompletionBlock:^(NSError *error) {
            
            if (completion) {
                completion(error);
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
        
        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
         
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
                PHAssetCollectionChangeRequest* request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                
                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
                [request addAssets:@[asset]];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if (completion) {
                    
                    completion(error);
                }
            }];
        }
    }];
}

@end
