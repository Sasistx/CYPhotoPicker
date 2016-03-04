//
//  PhotoPickerManager.h
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import <Photos/Photos.h>

typedef void(^SaveImageCompletion)(NSError* error);

typedef void(^CheckOriginalImageResult)(UIImage* image, NSDictionary* info, BOOL exist);

@interface PhotoPickerManager : NSObject

@property (nonatomic, strong) NSMutableArray* selectedArray;

+ (PhotoPickerManager*)sharedManager;

/**
 *  异步从相册获取图片ios8.0之后的api
 *
 *  @param size       图片尺寸
 *  @param asset      所持有的PHAsset对象
 *  @param completion 获取结果
 */
//- (void)asyncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;

- (void)asyncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset allowNetwork:(BOOL)allow completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;


- (void)syncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset allowNetwork:(BOOL)allow completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;

/**
 *  异步从相册获取图片 (通用接口)
 *
 *  @param asset      PhotoBaseListItem 对象
 *  @param completion 获取结果
 */
- (void)asyncGetOriginImageWithAsset:(id)asset completion:(void (^)(UIImage* image))completion;

/**
 *  清除所选图像
 */
- (void)clearSelectedArray;

/**
 *  保存图像
 *
 *  @param image      需要保存的图像
 *  @param album      需要保存到的相册名
 *  @param completion 保存结果
 */
- (void)saveImage:(UIImage*)image toAlbum:(NSString*)album completion:(SaveImageCompletion)completion;


- (void)checkOriginalImageExistWithAsset:(PHAsset*)asset completion:(CheckOriginalImageResult)completion;
@end
