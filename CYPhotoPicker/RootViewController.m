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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked:(id)sender
{
    [UIColor colorWithRed:27/255.0 green:125/255.0 blue:174/255.0 alpha:1];
    if (!_picker) {
        _picker = [[CYPhotoPicker alloc] initWithCurrentController:self option:PhotoPickerOptionAlbum | PhotoPickerOptionCamera isOne:NO showPreview:NO];
    }
    _picker.sendButtonColor = [UIColor colorWithRed:27/255.0 green:125/255.0 blue:174/255.0 alpha:1];
    [_picker setPhotoCompeletionBlock:^(NSArray *images) {
        
    }];
    _picker.sendButtonTextColor = [UIColor whiteColor];
    [_picker show];
    
}



@end
