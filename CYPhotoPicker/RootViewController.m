//
//  RootViewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/7.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "RootViewController.h"
#import "CYPhotoPicker.h"

@interface RootViewController () 
@property (nonatomic, strong) CYPhotoPicker* picker;
@property (nonatomic, strong) NSArray* temp;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked:(id)sender
{
    
    CYPhotoPicker* picker = [CYPhotoPicker showFromController:self option:PhotoPickerOptionAlbum | PhotoPickerOptionCamera isOne:NO showPreview:NO compeletionBlock:^(NSArray *imageAssets) {
        
        [[PhotoPickerManager sharedManager] asyncGetOriginImageWithAsset:imageAssets[0] completion:^(UIImage *image) {
           
            
        }];
    }];
    picker.buttonBackgroundColor = [UIColor colorWithRed:34/255.0 green:156/255.0 blue:218/255.0 alpha:1];
    picker.sendButtonTextColor = [UIColor whiteColor];
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

@end
