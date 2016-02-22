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
@property (nonatomic, strong) UIColor* buttonBackgroundColor;
@property (nonatomic, strong) UIColor* sendButtonTextColor;
@property (nonatomic, getter=isOne) BOOL one;
@property (nonatomic, getter=isShowPreview) BOOL showPreview;
@property (nonatomic, assign) PhotoPickerOption pickerOption;
@property (nonatomic, assign) PhotoNaviButtonStyle naviStyle;

- (instancetype)initWithCurrentController:(UIViewController*)controller option:(PhotoPickerOption)option isOne:(BOOL)isOne showPreview:(BOOL)showPreview;
- (void)setPhotoCompeletionBlock:(PhotoPickerDismissBlock)dissmissBlock;
- (void)show;
+ (instancetype)showFromController:(UIViewController*)controller option:(PhotoPickerOption)option isOne:(BOOL)isOne showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock)dissmissBlock;
@end
