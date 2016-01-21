//
//  PhotoScrollPreviewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/20.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoScrollPreviewController.h"
#import "PhotoPreviewLayout.h"
#import "PhotoPreviewCell.h"
#import "PhotoPickerManager.h"

#define PRE_CELL_IDENTIFIER @"prePhotoPickerCell"

@interface PhotoScrollPreviewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UIButton* selectButton;
@property (nonatomic, strong) UIButton* originImageButton;
@property (nonatomic, strong) UIButton* sendButton;
@end

@implementation PhotoScrollPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [self createCollectionView];
    [self createNaviView];
    [self createBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark -
#pragma mark - create UI

- (void)createNaviView
{
    UIView* naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height - 50, 50)];
    [naviView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
    [self.view addSubview:naviView];
    
    UIButton* naviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [naviButton setTitle:@"返回" forState:UIControlStateNormal];
    [naviButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviButton];
}

- (void)createCollectionView
{
    PhotoPreviewLayout* photoLayout = [[PhotoPreviewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:photoLayout];
//    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.pagingEnabled = YES;
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:PRE_CELL_IDENTIFIER];
    [self.view addSubview:_collectionView];
}

- (void)createBottomView
{
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
    [self.view addSubview:bottomView];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(bottomView.frame.size.width - 80, 10, 70, 30)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [bottomView addSubview:_sendButton];
    
    [self updateSendButtonText];
}

- (void)updateSendButtonText
{
    NSString* buttonTitle = nil;
    if ([PhotoPickerManager sharedManager].selectedArray.count > 0) {
        buttonTitle = [NSString stringWithFormat:@"发送 %zi/9", [PhotoPickerManager sharedManager].selectedArray.count];
    }else {
        buttonTitle = @"发送";
    }
    [_sendButton setTitle:buttonTitle forState:UIControlStateNormal];
}

#pragma mark - 
#pragma mark - button event

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendButtonClicked:(id)sender
{
    
}

#pragma mark - 
#pragma mark - collection view delegate & datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_assets count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPreviewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:PRE_CELL_IDENTIFIER forIndexPath:indexPath];
    [cell setAssetToZoomView:_assets[indexPath.item]];
    return cell;
}

@end
