//
//  PhotoPreviewImageViewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/18.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoPreviewImageViewController.h"
#import "PhotoUtility.h"
#import "PhotoZoomScrollView.h"

@interface PhotoPreviewImageViewController ()
{
    UIView* _backView;
}
@property (nonatomic, copy) ChoosePHAssetImage choosePHAssetImageBlock;
@property (nonatomic, strong) UIImage* pickImage;
@property (nonatomic, strong) UIScrollView* scrollView;
@end

@implementation PhotoPreviewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_scrollView];
    _scrollView.autoresizesSubviews = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [_scrollView setBackgroundColor:[UIColor blackColor]];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width , 60)];
    [_backView setBackgroundColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]];
    _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _backView.autoresizesSubviews = YES;
    [self.view addSubview:_backView];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, _backView.frame.size.height)];
    [cancelButton setImage:[UIImage imageNamed:@"ph_imagePicker_close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:cancelButton];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(_backView.frame.size.width / 2 - 0.5, ((_backView.frame.size.height - 30) / 2), 1, 30)];
    [lineView setBackgroundColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]];
    [_backView addSubview:lineView];
    
    UIButton* chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setFrame:CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width, 0, self.view.frame.size.width / 2, _backView.frame.size.height)];
    [chooseButton setImage:[UIImage imageNamed:@"ph_imagePicker_choose"] forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:chooseButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    @weakify(self);
    
    [[PhotoPickerManager sharedManager] asyncTumbnailWithSize:PHImageManagerMaximumSize asset:_phItem.asset allowNetwork:YES  multiCallback:NO completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
        @strongify(self);
        [self createZoomScrollViewWithImage:resultImage];
    }];
    
    [_backView setFrame:CGRectMake(_backView.frame.origin.x, self.view.frame.size.height - _backView.frame.size.height, _backView.frame.size.width, _backView.frame.size.height)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewSafeAreaInsetsDidChange {
    
    [super viewSafeAreaInsetsDidChange];
    NSLog(@"%@", NSStringFromCGRect(self.view.safeAreaLayoutGuide.layoutFrame));
}

#pragma mark - set block

- (void)setChoosedAssetImageBlock:(ChoosePHAssetImage)chooseBlock
{
    self.choosePHAssetImageBlock = chooseBlock;
}

#pragma mark - create zoom scroll view

- (void)createZoomScrollViewWithImage:(UIImage*)image
{
    PhotoZoomScrollView* zoomView = [[PhotoZoomScrollView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [zoomView setZoomImageView:image];
    [self.scrollView addSubview:zoomView];
    self.pickImage = image;
}

#pragma mark -
#pragma mark - button event

- (void)cancelButtonClicked:(id)sender
{
    [[PhotoPickerManager sharedManager] clearSelectedArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseButtonClicked:(id)sender
{
    [[PhotoPickerManager sharedManager] clearSelectedArray];
    if (_choosePHAssetImageBlock) {
        _choosePHAssetImageBlock(@[_phItem]);
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
}

@end
