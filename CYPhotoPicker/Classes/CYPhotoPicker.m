//
//  CYPhotoPicker.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "CYPhotoPicker.h"
#import "PhotoAlbumListController.h"
#import "PhotoOldAlbumViewController.h"

@interface CYPhotoPicker ()
@property (nonatomic, weak) UIViewController* currentController;
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@end

@implementation CYPhotoPicker

- (instancetype)initWithCurrentController:(UIViewController*)controller isOne:(BOOL)isOne showPreview:(BOOL)showPreview
{
    self = [super init];
    if (self) {
        
        _one = isOne;
        _showPreview = showPreview;
        _currentController = controller;
        [self clearManager];
    }
    return self;
}

- (void)setSendButtonColor:(UIColor *)sendButtonColor
{
    if (_sendButtonColor && _sendButtonColor != sendButtonColor) {
        
        _sendButtonColor = nil;
    }
    _sendButtonColor = sendButtonColor;
    [PhotoConfigureManager sharedManager].sendButtonColor = sendButtonColor;
}

- (void)setSendButtonTextColor:(UIColor *)sendButtonTextColor
{
    if (_sendButtonTextColor && _sendButtonTextColor != sendButtonTextColor) {
        
        _sendButtonTextColor = nil;
    }
    
    _sendButtonTextColor = sendButtonTextColor;
    [PhotoConfigureManager sharedManager].sendButtontextColor = sendButtonTextColor;
}

#pragma mark - 
#pragma mark - public method

- (void)setPhotoCompeletionBlock:(PhotoPickerDismissBlock)dissmissBlock
{
    self.dissmissBlock = dissmissBlock;
}

- (void)show
{
    if (PH_IOSOVER(8)) {
        
        PhotoAlbumListController* controller = [[PhotoAlbumListController alloc] init];
        controller.isOne = _one;
        controller.showPreview = _showPreview;
        controller.dissmissBlock = self.dissmissBlock;
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:controller];
        [_currentController presentViewController:navi animated:YES completion:^{
            
        }];
    }else {
    
        PhotoOldAlbumViewController* controller = [[PhotoOldAlbumViewController alloc] init];
        controller.isOne = _one;
        controller.showPreview = _showPreview;
        controller.dissmissBlock = self.dissmissBlock;
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:controller];
        [_currentController presentViewController:navi animated:YES completion:^{
            
        }];
    }
}

#pragma mark -
#pragma mark - private method

- (void)clearManager
{
    [[PhotoConfigureManager sharedManager] clearColor];
    [[PhotoPickerManager sharedManager] clearSelectedArray];
}

@end