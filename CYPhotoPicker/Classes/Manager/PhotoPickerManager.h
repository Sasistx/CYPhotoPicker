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
 *  同步获取相册图片ios8.0之后的api
 *
 *  @param size       图片尺寸
 *  @param asset      所持有的PHAsset对象
 *  @param completion 获取结果
 */
- (void)syncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;

/**
 *  同步获取相册图片ios8.0之后的api
 *
 *  @param size         图片尺寸
 *  @param asset        所持有的PHAsset对象
 *  @param allowCache   是否允许缓存
 *  @param completion   获取结果
 */
- (void)syncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset allowCache:(BOOL)allowCache completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;

/**
 *  从相册获取图片ios8.0之后的api，completion会被回掉多次
 *
 *  @param size         图片尺寸
 *  @param asset        所持有的PHAsset对象
 *  @param allowNetwork 是否允许网络请求
 *  @param multyCallBack    是否多次回调结果
 *  @param completion   获取结果
 */
- (void)asyncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset allowNetwork:(BOOL)allowNetwork multyCallBack:(BOOL)multiCallback completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;

/**
 *  从相册获取图片ios8.0之后的api，completion会被回掉多次
 *
 *  @param size         图片尺寸
 *  @param asset        所持有的PHAsset对象
 *  @param allowNetwork 是否允许网络请求
 *  @param allowCache   是否允许缓存
 *  @param multyCallBack    是否多次回调结果
 *  @param completion   获取结果
 */
- (void)asyncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset allowNetwork:(BOOL)allowNetwork allowCache:(BOOL)allowCache multyCallBack:(BOOL)multiCallback completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;

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


/**
 *  检查当前Asset是否包含原始图片
 *
 *  @param asset      当前PHAsset对象
 *  @param completion 返回结果，若不包含，则image为nil，info为nil，exist为NO
 */
- (void)checkOriginalImageExistWithAsset:(PHAsset*)asset completion:(CheckOriginalImageResult)completion;

@end
