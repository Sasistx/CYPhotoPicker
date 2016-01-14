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
@property (nonatomic, strong) UIColor* buttonColor;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, getter=isOne) BOOL one;
@property (nonatomic, getter=isShowPreview) BOOL showPreview;

- (instancetype)initWithCurrentController:(UIViewController*)controller isOne:(BOOL)isOne showPreview:(BOOL)showPreview;
- (void)setPhotoCompeletionBlock:(PhotoPickerDismissBlock)dissmissBlock;
- (void)show;
@end
