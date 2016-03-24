//
//  PhotoUtility.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoUtility.h"
#import "PhotoListItem.h"
#import "PhotoOldListItem.h"
#import "PhotoPickerManager.h"

@implementation PhotoUtility

+ (void)loadChunyuPhoto:(id)item success:(void(^)(UIImage *image))success failure:(PhotoFailureBlock)failure
{
    if ([item isKindOfClass:[PhotoOldListItem class]]) {
        if (((PhotoOldListItem*)item).url) {
            // 如果是相册的照片
            ALAssetsLibrary  *lib = [[ALAssetsLibrary alloc] init];
            NSURL *url = ((PhotoOldListItem*)item).url;
            PH_WEAK_VAR(self);
            PH_WEAK_VAR(lib);
            PH_WEAK_VAR(url);
            [lib assetForURL:url resultBlock:^(ALAsset *asset) {
                //在这里使用asset来获取图片
                if (asset) {
                    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                    CGImageRef imgRef = [assetRep fullResolutionImage];
                    UIImage *img = [UIImage imageWithCGImage:imgRef
                                                       scale:assetRep.scale
                                                 orientation:(UIImageOrientation)assetRep.orientation];
                    if (img) {
                        success(img);
                    }
                    else {
                        failure(nil);
                    }
                } else {
                    // 在iOS 8.1中,[library assetForUrl] Photo Streams 返回是nil. 改用下面这种方式转化
                    
                    [_self getImageWithAssessLibrary:_lib url:_url onCompletion:^(UIImage *image) {
                        if (image) {
                            success(image);
                        }
                        else {
                            failure(nil);
                        }
                    }];
                }
            } failureBlock:^(NSError *error) {
                failure(error);
            }];
        }
    }else {
    
        [[PhotoPickerManager sharedManager] asyncGetOriginImageWithAsset:item completion:^(UIImage *image) {
           
            if (image) {
                success(image);
            }
            else {
                failure(nil);
            }
        }];
    }
}

// get a image or nil
+ (void)getImageWithAssessLibrary:(ALAssetsLibrary *)lib url:(NSURL *)url onCompletion:(void(^)(UIImage *image))completion {
    [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                       usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                           [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                               if([result.defaultRepresentation.url isEqual:url])
                               {
                                   ALAssetRepresentation *assetRep = [result defaultRepresentation];
                                   CGImageRef imgRef = [assetRep fullResolutionImage];
                                   UIImage *img = [UIImage imageWithCGImage:imgRef
                                                                      scale:assetRep.scale
                                                                orientation:(UIImageOrientation)assetRep.orientation];
                                   
                                   completion(img);
                                   *stop = YES;
                               }
                           }];
                       }failureBlock:^(NSError *error) {
                           completion(nil);
                       }];
}

+ (UIImage*)imageWithColor:(UIColor*)color
{
    CGSize imageSize =CGSizeMake(50,50);
    UIGraphicsBeginImageContextWithOptions(imageSize,0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

+ (UIImage*)originImage:(UIImage*)originImage tintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    // keep alpha, set opaque to NO
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, originImage.scale);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, originImage.size.width, originImage.size.height);
    UIRectFill(bounds);
    
    // Draw the tinted image in context
    [originImage drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [originImage drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage* tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage*)combineSameSizeImageWithContextImage:(UIImage*)contextImage headerImage:(UIImage*)headerImage
{
    UIGraphicsBeginImageContext(contextImage.size);
    
    [contextImage drawInRect:CGRectMake(0, 0, contextImage.size.width, contextImage.size.height)];
    [headerImage drawInRect:CGRectMake(0, 0, headerImage.size.width, headerImage.size.height)];
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

@end
