//
//  CYPhotoPicker.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYPhotoPickerDefines.h"

@interface CYPhotoPicker : NSObject

/**
 *  按钮背景颜色
 */
@property (nonatomic, strong, nullable) UIColor* buttonBackgroundColor;

/**
 *  按钮文字颜色
 */
@property (nonatomic, strong, nullable) UIColor* sendButtonTextColor;

/**
 *  是否为单选
 */
@property (nonatomic, getter=isOne) BOOL one;

/**
 *  是否包含预览页面
 */
@property (nonatomic, getter=isShowPreview) BOOL showPreview;

/**
 *  pickerOption
 */
@property (nonatomic, assign) PhotoPickerOption pickerOption;

/**
 *  返回按钮样式
 */
@property (nonatomic, assign) PhotoNaviButtonStyle naviStyle;

/**
 *  拍照后保存至相册的相册名
 */
@property (nonatomic, copy, nullable) NSString* albumName;

/**
 *  CYPicker初始化方法
 *
 *  @param controller    当前controller
 *  @param option        所展示的相册选项，目前支持，PhotoPickerOptionAlbum，PhotoPickerOptionCamera，PhotoPickerOptionAlbum | PhotoPickerOptionCamera 3种
 *  @param isOne         是否只从相册中选择一张
 *  @param showPreview   相册选择是否展示预览
 *  @param dissmissBlock 选择回掉方法
 *
 *  @return CYPicker
 */
+ (instancetype _Nullable)showFromController:(UIViewController* _Nonnull)controller option:(PhotoPickerOption)option isOne:(BOOL)isOne showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock _Nullable)dissmissBlock;

/**
 *  将相册或相机从当前controller展示的方法
 */
- (void)show;

/**
 *  设置预选择的图片
 *
 *  @param items items中的元素必须为PhotoListItem或者PhotoBaseListItem类型
 */
- (void)setSelectedPhotoItem:(nonnull NSArray*)items;

@end
