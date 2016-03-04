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
#import "PhotoTempViewController.h"
#import "PhotoListItem.h"

static NSString* kAlbumTitle = @"从手机相册选择";
static NSString* kCameraTitle = @"拍照";
static NSString* kCancelTitle = @"取消";
static NSString* kAlbumDefaultName = @"CY";

@interface CYPhotoPicker () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIViewController* currentController;
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@end

@implementation CYPhotoPicker

+ (instancetype _Nullable)showFromController:(UIViewController* _Nonnull)controller option:(PhotoPickerOption)option isOne:(BOOL)isOne showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock _Nullable)dissmissBlock
{
    CYPhotoPicker* sharedPicker = [[self alloc] initWithCurrentController:controller option:option isOne:isOne showPreview:showPreview compeletionBlock:dissmissBlock];
    return sharedPicker;
}


- (instancetype)initWithCurrentController:(UIViewController*)controller option:(PhotoPickerOption)option isOne:(BOOL)isOne showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock)dissmissBlock
{
    self = [super init];
    if (self) {
        
        _one = isOne;
        _showPreview = showPreview;
        _pickerOption = option;
        _currentController = controller;
        [self clearManager];
        [PhotoConfigureManager sharedManager].currentPicker = self;
        self.dissmissBlock = dissmissBlock;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor
{
    if (_buttonBackgroundColor && _buttonBackgroundColor != buttonBackgroundColor) {
        
        _buttonBackgroundColor = nil;
    }
    
    _buttonBackgroundColor = buttonBackgroundColor;
    [PhotoConfigureManager sharedManager].buttonBackgroundColor = buttonBackgroundColor;
}

- (void)setSendButtonTextColor:(UIColor *)sendButtonTextColor
{
    if (_sendButtonTextColor && _sendButtonTextColor != sendButtonTextColor) {
        
        _sendButtonTextColor = nil;
    }
    
    _sendButtonTextColor = sendButtonTextColor;
    [PhotoConfigureManager sharedManager].sendButtontextColor = sendButtonTextColor;
}

- (void)setNaviStyle:(PhotoNaviButtonStyle)naviStyle
{
    _naviStyle = naviStyle;
    [PhotoConfigureManager sharedManager].naviStyle = naviStyle;
}

#pragma mark - 
#pragma mark - public method

- (void)setPhotoCompeletionBlock:(PhotoPickerDismissBlock)dissmissBlock
{
    self.dissmissBlock = dissmissBlock;
}

- (void)show
{
    if (_pickerOption == PhotoPickerOptionAlbum) {
        
        [self showAlbum];
    }else if (_pickerOption == PhotoPickerOptionCamera){
    
        [self showCamera];
    }else if (_pickerOption == (PhotoPickerOptionAlbum | PhotoPickerOptionCamera)){

        if (PH_IOSOVER(8)) {
            PH_WEAK_VAR(self);
            UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *albumAction = [UIAlertAction actionWithTitle:kAlbumTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                [_self showAlbum];
                                                            }];
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:kCameraTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {

                                                                [_self showCamera];
                                                            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kCancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [_self showCancel];
            }];
            [actionSheet addAction:albumAction];
            [actionSheet addAction:cameraAction];
            [actionSheet addAction:cancelAction];
            [_currentController presentViewController:actionSheet animated:YES completion:Nil];
        }else{
            UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kCancelTitle destructiveButtonTitle:nil otherButtonTitles:kAlbumTitle,kCameraTitle, nil];
            [sheet showInView:_currentController.view];
        }

    }else{
        [self showCancel];
    }
}

- (void)setSelectedPhotoItem:(nonnull NSArray*)items
{
    [[PhotoPickerManager sharedManager].selectedArray removeAllObjects];
    if (items) {
        [[PhotoPickerManager sharedManager].selectedArray addObjectsFromArray:items];
    }
}

#pragma mark -
#pragma mark - private method

- (void)showCamera
{
    if (PH_IOSOVER(7)) {
        NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusDenied) {
            [SVProgressHUD showErrorWithStatus:@"请在“设置-隐私-相机”中允许访问相机"];
            return;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourcheType;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [_currentController presentViewController:picker animated:YES completion:^{
            
        }];
    } else  {
        
        [SVProgressHUD showErrorWithStatus: @"相机不可用"];
    }
}

- (void)showAlbum
{
    //待icloud下载逻辑处理好之后，使用新api进行相册处理
    if (PH_IOSOVER(8))
    {
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

- (void)showCancel
{
    if (_dissmissBlock) {
        _dissmissBlock(nil);
    }
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}

- (void)clearManager
{
    [[PhotoConfigureManager sharedManager] clearColor];
    [[PhotoPickerManager sharedManager] clearSelectedArray];
}

#pragma mark -
#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //album
            [self showAlbum];
        }
            break;
        case 1:
        {
            //camera
            [self showCamera];
        }
            break;
        case 2:
        {
            //cancel
            [self showCancel];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 
#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (_dissmissBlock) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        PhotoListItem* item = [[PhotoListItem alloc] init];
        item.originImage = image;
        _dissmissBlock(@[item]);
        [[PhotoPickerManager sharedManager] saveImage:image toAlbum:_albumName ? _albumName : kAlbumDefaultName completion:^(NSError *error) {
            
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self showCancel];
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}

@end
