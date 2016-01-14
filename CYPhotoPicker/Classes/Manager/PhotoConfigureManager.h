//
//  PhotoConfigureManager.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoConfigureManager : NSObject

@property (nonatomic, strong) UIColor* sendButtonColor; //default is white
@property (nonatomic, strong) UIColor* sendButtontextColor; //default is black

+ (PhotoConfigureManager*)sharedManager;

- (void)clearColor;

@end
