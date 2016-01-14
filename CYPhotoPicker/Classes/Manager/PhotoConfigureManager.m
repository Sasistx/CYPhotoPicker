//
//  PhotoConfigureManager.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoConfigureManager.h"

@implementation PhotoConfigureManager

static PhotoConfigureManager* sharedManager = nil;

+ (PhotoConfigureManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PhotoConfigureManager alloc] init];
    });
    return sharedManager;
}

- (void)clearColor
{
    self.rightItemColor = nil;
    self.naviItemColor = nil;
    self.sendButtonColor = nil;
    self.sendButtontextColor = nil;
}

@end
