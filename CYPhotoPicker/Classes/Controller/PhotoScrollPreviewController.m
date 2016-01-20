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
    // Do any additional setup after loading the view.
    [self createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - create UI

- (void)createNaviView
{
    UIView* naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height - 50, 50)];
    [naviView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:naviView];
    
    UIButton* naviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [naviButton setTitle:@"返回" forState:UIControlStateNormal];
    [naviButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviButton];
}

- (void)createCollectionView
{
//    _collectionView = [UICo]
    PhotoPreviewLayout* photoLayout = [[PhotoPreviewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:photoLayout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:PRE_CELL_IDENTIFIER];
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
}

- (void)createBottomView
{
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [bottomView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:bottomView];
}

#pragma mark - 
#pragma mark - button event

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    return cell;
}

@end
