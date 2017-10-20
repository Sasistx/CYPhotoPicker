//
//  CYPhotoPicker.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "CYPhotoPicker.h"
#import "PhotoAlbumListController.h"
#import "PhotoListItem.h"
#import "PhotoPreviewNetworkImageController.h"
#import "PhotoUtility.h"

static NSString* kAlbumTitle = @"从手机相册选择";
static NSString* kCameraTitle = @"拍照";
static NSString* kCancelTitle = @"取消";
static NSString* kAlbumDefaultName = @"CY";
static NSString* kSendButtonTitle = @"发送";
static NSInteger kDefaultMax = 9;


@interface CYPhotoPicker () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIViewController* currentController;
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@property (nonatomic, copy) PhotoPickerPermissionDeniedBlock denyBlock;
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
        
        _showPreview = showPreview;
        _pickerOption = option;
        _currentController = controller;
        _maxCount = isOne ? 1 : kDefaultMax;
        [self clearManager];
        [PhotoConfigureManager sharedManager].currentPicker = self;
        self.dissmissBlock = dissmissBlock;
    }
    return self;
}

+ (instancetype _Nullable)showFromController:(UIViewController* _Nonnull)controller option:(PhotoPickerOption)option showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock _Nullable)dissmissBlock
{
    return [CYPhotoPicker showFromController:controller option:option showPreview:showPreview compeletionBlock:dissmissBlock denyBlock:nil];
}

+ (instancetype _Nullable)showFromController:(UIViewController* _Nonnull)controller option:(PhotoPickerOption)option showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock _Nullable)dissmissBlock denyBlock:(PhotoPickerPermissionDeniedBlock _Nullable)denyBlock {
    
    CYPhotoPicker* sharedPicker = [[self alloc] initWithCurrentController:controller option:option showPreview:showPreview compeletionBlock:dissmissBlock denyBlock:denyBlock];
    return sharedPicker;
}

- (instancetype)initWithCurrentController:(UIViewController*)controller option:(PhotoPickerOption)option showPreview:(BOOL)showPreview compeletionBlock:(PhotoPickerDismissBlock)dissmissBlock denyBlock:(PhotoPickerPermissionDeniedBlock)denyBlock
{
    self = [super init];
    if (self) {
        _showPreview = showPreview;
        _pickerOption = option;
        _currentController = controller;
        _maxCount = kDefaultMax;
        [self clearManager];
        [PhotoConfigureManager sharedManager].currentPicker = self;
        [PhotoConfigureManager sharedManager].sendButtonTitle = kSendButtonTitle;
        self.dissmissBlock = dissmissBlock;
        self.denyBlock = denyBlock;
    }
    return self;
}

+ (instancetype _Nullable)showFromeController:(UIViewController* _Nonnull)controller imageList:(NSArray<PhotoNetworkItem * > * _Nonnull)imageList currentIndex:(NSUInteger)index
{
    return [CYPhotoPicker showFromeController:controller imageList:imageList currentIndex:index placeholderImage:nil];
}

+ (instancetype _Nullable)showFromeController:(UIViewController* _Nonnull)controller imageList:(NSArray<PhotoNetworkItem * > * _Nonnull)imageList currentIndex:(NSUInteger)index placeholderImage:(UIImage *_Nullable)image {

    CYPhotoPicker* picker = [[CYPhotoPicker alloc] initWithCurrentController:controller imageList:imageList currentIndex:index placeholderImage:image];
    return picker;
}

- (instancetype)initWithCurrentController:(UIViewController*)controller imageList:(NSArray*)imageList currentIndex:(NSUInteger)index placeholderImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        
        NSUInteger currentIndex = index < imageList.count ? index : 0;
        PhotoPreviewNetworkImageController* previewController = [[PhotoPreviewNetworkImageController alloc] init];
        previewController.indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        previewController.images = imageList;
        previewController.placeholderImage = image;
        [controller presentViewController:previewController animated:NO completion:Nil];
    }
    return self;
}

- (void)dealloc
{
}

- (void)setButtonBackgroundColor:(UIColor*)buttonBackgroundColor
{
    if (_buttonBackgroundColor && _buttonBackgroundColor != buttonBackgroundColor) {

        _buttonBackgroundColor = nil;
    }

    _buttonBackgroundColor = buttonBackgroundColor;
    [PhotoConfigureManager sharedManager].buttonBackgroundColor = buttonBackgroundColor;
}

- (void)setSendButtonTextColor:(UIColor*)sendButtonTextColor
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

- (void)setSendButtonTitle:(NSString *)sendButtonTitle
{
    if (_sendButtonTitle && [_sendButtonTitle isEqualToString:sendButtonTitle]) {
        
        _sendButtonTitle = nil;
    }
    _sendButtonTitle = sendButtonTitle;
    [PhotoConfigureManager sharedManager].sendButtonTitle = sendButtonTitle;
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
    }
    else if (_pickerOption == PhotoPickerOptionCamera) {

        [self showCamera];
    }
    else if (_pickerOption == (PhotoPickerOptionAlbum | PhotoPickerOptionCamera)) {

        @weakify(self);
        UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* albumAction = [UIAlertAction actionWithTitle:kAlbumTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction* action) {
                                                                
                                                                @strongify(self);
                                                                [self showAlbum];
                                                            }];
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:kCameraTitle
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction* action) {
                                                                 
                                                                 @strongify(self);
                                                                 [self showCamera];
                                                             }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:kCancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action) {
            
            @strongify(self);
            [self showCancel];
        }];
        [actionSheet addAction:albumAction];
        [actionSheet addAction:cameraAction];
        [actionSheet addAction:cancelAction];
        [_currentController presentViewController:actionSheet animated:YES completion:Nil];
    }
    else {
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
    NSString* mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusDenied) {
        
        if (self.denyBlock) {
            
            self.denyBlock(PhotoPickerDenyTypeCamera);
        } else {
            
            [PhotoUtility showAlertWithMsg:@"请在“设置-隐私-相机”中允许访问相机" controller:_currentController];
        }
        return;
    }

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourcheType;
        picker.delegate = self;
        picker.allowsEditing = NO;
        [_currentController presentViewController:picker animated:YES completion:^{

        }];
    }
    else {
        [PhotoUtility showAlertWithMsg:@"相机不可用" controller:_currentController];
    }
}

- (void)showAlbum
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        
        if (self.denyBlock) {
            
            self.denyBlock(PhotoPickerDenyTypeAlbum);
        } else {
            
            [PhotoUtility showAlertWithMsg:@"请在“设置-隐私-相册”中允许访问相册" controller:_currentController];
        }
        
        return;
    }
    
    PhotoAlbumListController* controller = [[PhotoAlbumListController alloc] init];
    controller.showPreview = _showPreview;
    controller.dissmissBlock = self.dissmissBlock;
    controller.maxCount = _maxCount;
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [_currentController presentViewController:navi animated:YES completion:^{
        
    }];
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

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
    case 0: {
        //album
        [self showAlbum];
    } break;
    case 1: {
        //camera
        [self showCamera];
    } break;
    case 2: {
        //cancel
        [self showCancel];
    } break;
    default:
        break;
    }
}

#pragma mark -
#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString*, id>*)info
{
    if (_dissmissBlock) {

        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        PhotoListItem* item = [[PhotoListItem alloc] init];
        item.originImage = image;
        _dissmissBlock(@[ item ]);
        [[PhotoPickerManager sharedManager] saveImage:image toAlbum:_albumName ? _albumName : kAlbumDefaultName completion:^(NSError* error){

        }];
    }
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self showCancel];
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}

@end
