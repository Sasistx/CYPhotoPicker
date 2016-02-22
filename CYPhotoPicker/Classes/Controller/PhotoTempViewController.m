//
//  PhotoTempViewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/15.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoTempViewController.h"

@interface PhotoTempViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PhotoTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (_dissmissBlock) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _dissmissBlock(@[image]);
    }
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (_dissmissBlock) {
        _dissmissBlock(nil);
    }
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}

@end
