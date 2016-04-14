//
//  RootViewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/7.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "RootViewController.h"
#import "CYPhotoPicker.h"
#import "PhotoBaseListItem.h"

@interface RootViewController () 
@property (nonatomic, strong) CYPhotoPicker* picker;
@property (nonatomic, strong) NSArray* temp;
@property (nonatomic, assign) NSInteger count;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"弹出相册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, 100, 100, 30)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton* testbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testbutton setTitle:@"测试数组" forState:UIControlStateNormal];
    [testbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testbutton setFrame:CGRectMake(100, 300, 100, 30)];
    [testbutton addTarget:self action:@selector(testbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testbutton];
    
    UIButton* albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumButton setTitle:@"创建相册" forState:UIControlStateNormal];
    [albumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [albumButton setFrame:CGRectMake(100, 400, 100, 30)];
    [albumButton addTarget:self action:@selector(albumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumButton];
    
    UIButton* addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPhotoButton setTitle:@"保存200次照片" forState:UIControlStateNormal];
    [addPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addPhotoButton setFrame:CGRectMake(100, 500, 200, 30)];
    [addPhotoButton addTarget:self action:@selector(addPhotoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhotoButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked:(id)sender
{
    CYPhotoPicker* picker = [CYPhotoPicker showFromController:self option:PhotoPickerOptionAlbum | PhotoPickerOptionCamera isOne:NO showPreview:YES compeletionBlock:^(NSArray *imageAssets) {
        
        [[PhotoPickerManager sharedManager] asyncGetOriginImageWithAsset:imageAssets[0] completion:^(UIImage *image) {
           
            
        }];
    }];
    picker.maxCount = 3;
    
    [picker show];
}

- (void)testbuttonClicked:(id)sender
{
    NSLog(@"=----%@", _temp);
}

- (void)albumButtonClicked:(id)sender
{
    [[PhotoPickerManager sharedManager] saveImage:[UIImage imageNamed:@"0.jpg"] toAlbum:@"春雨" completion:^(NSError *error) {
        
    }];
}

- (void)addPhotoButtonClicked:(id)sender
{
    PH_WEAK_VAR(self);
    
    CYPhotoPicker* picker = [CYPhotoPicker showFromController:self option:PhotoPickerOptionAlbum | PhotoPickerOptionCamera isOne:NO showPreview:NO compeletionBlock:^(NSArray *imageAssets) {
        
//        PhotoBaseListItem* temp = imageAssets[0];
//        [_self savePhoto:temp.originImage];
    }];
    [picker show];
}

- (void)savePhoto:(UIImage*)image
{
    PH_WEAK_VAR(self);
    
    [[PhotoPickerManager sharedManager] saveImage:image toAlbum:@"春雨" completion:^(NSError* error){
        
        _self.count ++;
        
        NSLog(@"%-----zi", _self.count);
        if (_self.count > 1200) {
            
            [SVProgressHUD showSuccessWithStatus:@"保存完成"];
        }else {
            [_self savePhoto:image];
        }
    }];
}

@end
