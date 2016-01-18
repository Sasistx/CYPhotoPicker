//
//  PHNaviButton.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/18.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PHNaviButton.h"

@implementation PHNaviButton

- (UIEdgeInsets)alignmentRectInsets {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    // 只处理iOs7.0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        insets = UIEdgeInsetsMake(0, 9.0f, 0, 0);
    }
    return insets;
}

@end
