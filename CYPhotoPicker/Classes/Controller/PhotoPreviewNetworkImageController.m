//
//  PhotoPreviewNetworkImageController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/7/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoPreviewNetworkImageController.h"
#import "PhotoPreviewLayout.h"
#import "PhotoNetworkPreviewCell.h"

#define PRE_NETWORK_CELL_IDENTIFIER @"PRE_NETWORK_CELL_IDENTIFIER"

@interface PhotoPreviewNetworkImageController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@end

@implementation PhotoPreviewNetworkImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self.navigationController setNavigationBarHidden:YES];
    [self createCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
       
        _collectionView.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCollectionView
{
    PhotoPreviewLayout* photoLayout = [[PhotoPreviewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:photoLayout];
    _collectionView.pagingEnabled = YES;
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PhotoNetworkPreviewCell class] forCellWithReuseIdentifier:PRE_NETWORK_CELL_IDENTIFIER];
    [self.view addSubview:_collectionView];
    
    [_collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    _collectionView.alpha = 0;
}

#pragma mark -
#pragma mark - collection view delegate & datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_images count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoNetworkPreviewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:PRE_NETWORK_CELL_IDENTIFIER forIndexPath:indexPath];
    [cell setPlaceHolderImage:_placeholderImage];
    [cell setItemToZoomView:_images[indexPath.item]];
    cell.currentController = self;
    return cell;
}

@end
