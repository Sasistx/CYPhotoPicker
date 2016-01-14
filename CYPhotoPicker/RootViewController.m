//
//  RootViewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/7.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "RootViewController.h"
#import "PhotoAlbumListController.h"
#import "PhotoOldAlbumViewController.h"

@interface RootViewController ()

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
//    PhotoAlbumListController* controller = [[PhotoAlbumListController alloc] init];
//    controller.isOne = YES;
//    controller.showPreview = YES;
//    [controller setPhotoCompeletionBlock:^(NSArray *images) {
//        
//    }];
//    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:navi animated:YES completion:^{
//        
//    }];
    
    PhotoOldAlbumViewController* controller = [[PhotoOldAlbumViewController alloc] init];
    controller.isOne = NO;
    controller.showPreview = NO;
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
}

@end
