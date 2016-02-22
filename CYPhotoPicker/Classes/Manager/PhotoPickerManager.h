//
//  PhotoPickerManager.h
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

//tag 0.9.1
#import <Photos/Photos.h>

@interface PhotoPickerManager : NSObject

@property (nonatomic, strong) NSMutableArray* selectedArray;

+ (PhotoPickerManager*)sharedManager;
- (void)asyncTumbnailWithSize:(CGSize)size asset:(PHAsset*)asset completion:(void (^)(UIImage* resultImage, NSDictionary *resultInfo))completion;
- (void)asyncGetOriginImageWithAsset:(id)asset completion:(void (^)(UIImage* image))completion;
- (void)clearSelectedArray;
@end
