//
//  PhotoOldCollectionViewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoOldCollectionViewController.h"
#import "PhotoCollectionViewLayout.h"
#import "PhotoOldListItem.h"
#import "PhotoPreviewController.h"

#define OLD_CELL_IDENTIFIER @"Old_PhotoPickerCell"

@interface PhotoOldCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger imageMaxCount;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* dataItems;
@property (nonatomic, strong) UIButton* sendButton;
@end

@implementation PhotoOldCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"全部照片";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCollectionView
{
    PhotoCollectionViewLayout *layout = [[PhotoCollectionViewLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[PhotoOldListItem class]
        forCellWithReuseIdentifier:OLD_CELL_IDENTIFIER];
    [self.view addSubview:self.collectionView];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataItems count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoOldListItemCell *cell =
    (PhotoOldListItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:OLD_CELL_IDENTIFIER
                                                                   forIndexPath:indexPath];
    [cell shouldUpdateItemCellWithObject:_dataItems[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PH_WEAK_VAR(self);
    if (_isOne && _showPreview) {
        PhotoPreviewController* controller = [[PhotoPreviewController alloc] init];
        [controller setChoosedAssetImageBlock:^(UIImage *photo) {
            
            if (_self.dissmissBlock) {
                
                _self.dissmissBlock(@[photo]);
            }
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        PhotoOldListItem* item = _dataItems[indexPath.item];
//        if ([self updateSelectedImageListWithItem:item]) {
//            [self.collectionView performBatchUpdates:^{
//                
//                [_self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
//            } completion: NULL];
//        }
    }
}

@end
