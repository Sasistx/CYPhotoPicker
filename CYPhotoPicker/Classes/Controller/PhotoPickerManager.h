//
//  PhotoPickerManager.h
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import <Photos/Photos.h>

@interface PhotoPickerManager : NSObject

@property (nonatomic, strong) NSMutableArray* selectedArray;

+ (PhotoPickerManager*)sharedManager;
- (void)syncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;
- (void)syncGetAllSelectedOriginImages:(void (^)(NSArray* images))completion;
- (void)clearSelectedArray;
@end
