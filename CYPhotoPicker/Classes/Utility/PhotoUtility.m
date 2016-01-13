//
//  PhotoUtility.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoUtility.h"
#import "PhotoOldListItem.h"

@implementation PhotoUtility

+ (void)loadChunyuPhoto:(PhotoOldListItem *)item success:(void(^)(UIImage *image))success failure:(PhotoFailureBlock)failure
{
    if (item.url) {
        // 如果是相册的照片
        ALAssetsLibrary  *lib = [[ALAssetsLibrary alloc] init];
        NSURL *url = item.url;
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

@end
