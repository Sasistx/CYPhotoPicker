//
//  PhotoCollectionListViewController.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import "PhotoCollectionListViewController.h"
#import "PhotoPickerManager.h"
#import "PhotoPreviewImageViewController.h"
#import "PhotoScrollPreviewController.h"
#import "PhotoCollectionViewLayout.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoListItem.h"
#import "PhotoUtility.h"
#import "PHNaviButton.h"
#import "PhotoScrollPreviewController.h"

#define CELL_IDENTIFIER @"PhotoPickerCell"

@interface PhotoCollectionListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PhotoItemCellProtocol>
@property (nonatomic, assign) NSInteger imageMaxCount;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* dataItems;
@property (nonatomic, strong) UIButton* sendButton;
@end

@implementation PhotoCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = _collection.localizedTitle;
    
    if (_isOne) {
        _imageMaxCount = 1;
    }else {
        _imageMaxCount = 9;
    }
    
    if ([PhotoConfigureManager sharedManager].naviStyle == PhotoNaviButtonStyleCYStyle) {
        [self createNaviButton];
    }
    
    [self createCollectionView];
    
    [self bottomView];
    
    [self updateImageCountView];
    [self loadPhotoAsset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

#pragma mark - 
#pragma mark - create UI

- (void)createNaviButton
{
    PHNaviButton* naviButton = [PHNaviButton buttonWithType:UIButtonTypeCustom];
    [naviButton setImage:[UIImage imageNamed:@"ph_navi_white_left_arrow"] forState:UIControlStateNormal];
    naviButton.frame = CGRectMake(0, 0, 38, 30);
    [naviButton       addTarget: self
                         action: @selector(backToLastController:)
               forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:naviButton];
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
    [_collectionView registerClass:[PhotoListItemCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self.view addSubview:self.collectionView];
}

- (void)bottomView
{
    UIColor* textColor = [PhotoConfigureManager sharedManager].sendButtontextColor ? [PhotoConfigureManager sharedManager].sendButtontextColor : [UIColor whiteColor];
    UIColor* buttonColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor ? [PhotoConfigureManager sharedManager].buttonBackgroundColor : [UIColor blackColor];
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(bottomView.frame.size.width - 80, 10, 70, 31)];
    [_sendButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_sendButton setTitleColor:textColor forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(onSendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_sendButton];
    
    UIButton* previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previewButton setFrame:CGRectMake(10, 10, 70, 31)];
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [previewButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
    [previewButton addTarget:self action:@selector(preButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:previewButton];
    
    [self.view addSubview:bottomView];
    
    [_collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _sendButton.frame.size.height)];
}

- (void)loadPhotoAsset
{
    if (!_dataItems) {
        _dataItems = [NSMutableArray array];
    }else {
        [_dataItems removeAllObjects];
    }
    
    PH_WEAK_VAR(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block NSMutableArray *dataItems = [NSMutableArray array];
        [_fetchResult enumerateObjectsUsingBlock:^(PHAsset* asset, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            PhotoListItem* item = [[PhotoListItem alloc] init];
            item.asset = asset;
            item.delegate = self;
            
            NSMutableArray* selectArray = [PhotoPickerManager sharedManager].selectedArray;

            [selectArray enumerateObjectsUsingBlock:^(PhotoListItem* innerItem, NSUInteger idx, BOOL * _Nonnull stop) {
               
                if ([innerItem.asset.localIdentifier isEqualToString:item.asset.localIdentifier]) {
                    item.isSelected = YES;
                }
            }];
            [dataItems addObject:item];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_self.dataItems addObjectsFromArray:dataItems];
            
            [_self didFinishLoadItem];
        });
    });
}

- (void)didFinishLoadItem
{
    [_collectionView reloadData];
}

- (BOOL) updateSelectedImageListWithItem:(PhotoListItem*)item
{
    NSMutableArray* selectArray = [PhotoPickerManager sharedManager].selectedArray;
    if (!item.isSelected) {
        
        if (selectArray.count >= _imageMaxCount) {
            
            [self alertMaxSelection];
            return NO;
        }
    }
    
    if (!_isOne) {
        if ([selectArray containsObject:item]) {
            
            [selectArray removeObject:item];
        }else {
            [selectArray addObject:item];
        }
        
        item.isSelected = !item.isSelected;
        [self updateImageCountView];
    }else {
        [selectArray removeAllObjects];
        [selectArray addObject:item];
    }
    
    return YES;
}

- (void)alertMaxSelection
{
    [SVProgressHUD showErrorWithStatus:@"选择照片数已达上限"];
}

- (void)updateImageCountView
{
    [_sendButton setTitle:[NSString stringWithFormat: @"发送 %zi/%zi", [PhotoPickerManager sharedManager].selectedArray.count, _imageMaxCount] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - button event

- (void)onSendBtnPressed:(UIButton*)sender
{
    if (_dissmissBlock) {
        PH_WEAK_VAR(self);
        
        NSArray* array = [[NSArray alloc] initWithArray:[PhotoPickerManager sharedManager].selectedArray];
        if (self.dissmissBlock) {
            self.dissmissBlock(array);
        }
        [[PhotoPickerManager sharedManager] clearSelectedArray];
        [_self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    }else{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    }
}

- (void)preButtonClicked:(id)sender
{
    if ([PhotoPickerManager sharedManager].selectedArray.count > 0) {
        
        PH_WEAK_VAR(self);
        PhotoScrollPreviewController* controller = [[PhotoScrollPreviewController alloc] init];
        controller.assets = [PhotoPickerManager sharedManager].selectedArray;
        [controller setPreviewBackBlock:^{
            
            [_self.collectionView reloadData];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)backToLastController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    PhotoListItemCell *cell =
    (PhotoListItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                  forIndexPath:indexPath];
    [cell shouldUpdateItemCellWithObject:_dataItems[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PH_WEAK_VAR(self);
    if (_isOne) {
        PhotoPreviewImageViewController* controller = [[PhotoPreviewImageViewController alloc] init];
        [controller setChoosedAssetImageBlock:^(NSArray *photos) {
            
            if (_self.dissmissBlock) {
                
                _self.dissmissBlock(photos);
            }
        }];
        controller.item = _dataItems[indexPath.item];
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        PhotoScrollPreviewController* controller = [[PhotoScrollPreviewController alloc] init];
        controller.assets = _dataItems;
        controller.dissmissBlock = _dissmissBlock;
        controller.indexPath = indexPath;
        [controller setPreviewBackBlock:^{
            
            [_self.collectionView reloadData];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didTapImageInCell:(UICollectionViewCell *)cell object:(id)obj
{
    PH_WEAK_VAR(self);
    NSIndexPath* indexPath = [_collectionView indexPathForCell:cell];
    PhotoListItem* item = obj;
    if ([self updateSelectedImageListWithItem:item]) {
        [self.collectionView performBatchUpdates:^{
            
            [_self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
        } completion: NULL];
    }
}

@end
