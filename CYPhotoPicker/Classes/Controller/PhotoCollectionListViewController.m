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
#import "PHButton.h"

#define CELL_IDENTIFIER @"PhotoPickerCell"

@interface PhotoCollectionListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PhotoItemCellProtocol>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* dataItems;
@property (nonatomic, strong) PHButton* sendButton;
@property (nonatomic, strong) PHButton* previewButton;
@property (nonatomic, assign) BOOL isOne;
@end

@implementation PhotoCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = _collection.localizedTitle;
    
    _isOne = (_imageMaxCount == 1);
    
    if ([PhotoConfigureManager sharedManager].naviStyle == PhotoNaviButtonStyleCYStyle) {
        [self createNaviButton];
    }
    
    [self createCollectionView];
    [self bottomView];
    [self loadPhotoAsset];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updatePreviewButton];
    [self updateImageCountView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"didReceiveMemoryWarning");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_dataItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PhotoListItem* item = obj;
            item.thumbImage = nil;
        }];
    });
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
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIColor* buttonColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor;
    UIColor* textColor = [PhotoConfigureManager sharedManager].sendButtontextColor;
    
    NSString* sendTitle = ([PhotoConfigureManager sharedManager].sendButtonTitle && ![[PhotoConfigureManager sharedManager].sendButtonTitle isEqualToString:@""]) ? [PhotoConfigureManager sharedManager].sendButtonTitle : @"发送";
    _sendButton = [PHButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(bottomView.frame.size.width - 80, 10, 70, 31)];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_sendButton setTitle:sendTitle forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(onSendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_sendButton];
    
    if (_showPreview) {
        _previewButton = [PHButton buttonWithType:UIButtonTypeCustom];
        [_previewButton setFrame:CGRectMake(10, 10, 70, 31)];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(preButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:_previewButton];
    }

    if (buttonColor) {
        
        [_sendButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
        [_previewButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
    }
    
    if (textColor) {
        [_sendButton setTitleColor:textColor forState:UIControlStateNormal];
        [_previewButton setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    [self.view addSubview:bottomView];
    
    [_collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomView.frame.size.height)];
    
    [self updatePreviewButton];
}

- (void)loadPhotoAsset
{
    if (!_dataItems) {
        _dataItems = [NSMutableArray array];
    }else {
        [_dataItems removeAllObjects];
    }
    
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block NSMutableArray *dataItems = [NSMutableArray array];
        [_fetchResult enumerateObjectsUsingBlock:^(PHAsset* asset, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (asset.mediaType == PHAssetMediaTypeImage) {
                PhotoListItem* item = [[PhotoListItem alloc] init];
                item.asset = asset;
                item.delegate = self;
                NSMutableArray* selectArray = [NSMutableArray arrayWithArray:[PhotoPickerManager sharedManager].selectedArray];
                
                [selectArray enumerateObjectsUsingBlock:^(PhotoListItem* innerItem, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([innerItem.asset.localIdentifier isEqualToString:item.asset.localIdentifier]) {
                        item.isSelected = YES;
                        [[PhotoPickerManager sharedManager].selectedArray replaceObjectAtIndex:idx withObject:innerItem];
                    }
                }];
                [dataItems addObject:item];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @strongify(self);
            [self.dataItems addObjectsFromArray:dataItems];
            
            [self didFinishLoadItem];
        });
    });
}

- (void)didFinishLoadItem
{
    [_collectionView reloadData];
    if ([_dataItems count] != 0) {
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:([_dataItems count] - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

- (BOOL) updateSelectedImageListWithItem:(PhotoListItem*)item
{
    NSMutableArray* selectArray = [PhotoPickerManager sharedManager].selectedArray;
    
    if (_isOne) {
        
        if (selectArray.count > 0) {
            
            PhotoListItem* innerItem = selectArray.firstObject;
            innerItem.isSelected = NO;
        }
        [selectArray removeAllObjects];
        item.isSelected = YES;
        [selectArray addObject:item];
        [self updateImageCountView];
        
    }else {
    
        if (!item.isSelected) {
            
            if (selectArray.count >= _imageMaxCount) {
                
                [self alertMaxSelection];
                return NO;
            }
        }
        
        __block NSInteger index = -1;
        [selectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PhotoListItem* innerItem = obj;
            if ([innerItem.asset.localIdentifier isEqualToString:item.asset.localIdentifier]) {
                
                index = idx;
                *stop = YES;
            }
        }];
        
        if (index >= 0) {
            
            [selectArray removeObjectAtIndex:index];
        }else {
            [selectArray addObject:item];
        }
        
        item.isSelected = !item.isSelected;
        [self updateImageCountView];
    }
    
    return YES;
}

- (void)alertMaxSelection
{
    [SVProgressHUD showErrorWithStatus:@"选择照片数已达上限"];
}

- (void)updateImageCountView
{
    NSString* sendTitle = ([PhotoConfigureManager sharedManager].sendButtonTitle && ![[PhotoConfigureManager sharedManager].sendButtonTitle isEqualToString:@""]) ? [PhotoConfigureManager sharedManager].sendButtonTitle : @"发送";
    [_sendButton setTitle:[NSString stringWithFormat: @"%@ %zi/%zi", sendTitle, [PhotoPickerManager sharedManager].selectedArray.count, _imageMaxCount] forState:UIControlStateNormal];
}

- (void)updatePreviewButton
{
    if ([PhotoPickerManager sharedManager].selectedArray.count > 0) {
        
        _previewButton.enabled = YES;
    }else {
        _previewButton.enabled = NO;
    }
}

#pragma mark -
#pragma mark - button event

- (void)onSendBtnPressed:(UIButton*)sender
{
    if (_dissmissBlock) {
        
        NSArray* array = [[NSArray alloc] initWithArray:[PhotoPickerManager sharedManager].selectedArray];
        
        if (array && array.count > 0) {
            if (self.dissmissBlock) {
                self.dissmissBlock(array);
            }
            [[PhotoPickerManager sharedManager] clearSelectedArray];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
        }else {
            return;
        }

    }else{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    }
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}

- (void)preButtonClicked:(id)sender
{
    @weakify(self);
    PhotoScrollPreviewController* controller = [[PhotoScrollPreviewController alloc] init];
    controller.assets = [[PhotoPickerManager sharedManager].selectedArray copy];
    controller.dissmissBlock = _dissmissBlock;
    controller.maxCount = _imageMaxCount;
    [controller setPreviewBackBlock:^{
        
        @strongify(self);
        [self.collectionView reloadData];
        [self updatePreviewButton];
    }];
    [self.navigationController pushViewController:controller animated:YES];
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
    @weakify(self);
    if (_showPreview) {
        PhotoScrollPreviewController* controller = [[PhotoScrollPreviewController alloc] init];
        controller.assets = _dataItems;
        controller.dissmissBlock = _dissmissBlock;
        controller.indexPath = indexPath;
        controller.maxCount = _imageMaxCount;
        [controller setPreviewBackBlock:^{
            
            @strongify(self);
            [self.collectionView reloadData];
            [self updatePreviewButton];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        
        [self didTapImageInCell:[collectionView cellForItemAtIndexPath:indexPath] object:_dataItems[indexPath.item]];
    }
}

- (void)didTapImageInCell:(UICollectionViewCell *)cell object:(id)obj
{
    @weakify(self);
    NSIndexPath* indexPath = [_collectionView indexPathForCell:cell];
    __block PhotoListItem* item = obj;
    [[PhotoPickerManager sharedManager] checkOriginalImageExistWithAsset:item.asset completion:^(UIImage *image, NSDictionary *info, BOOL exist) {
        
        @strongify(self);
        if (exist) {
            
            //存在选中
            NSMutableArray* selectArray = [PhotoPickerManager sharedManager].selectedArray;
            
            __block NSInteger row = -1;
            if (_isOne && selectArray.count > 0) {
                PhotoListItem* item = selectArray.firstObject;
                
                if ([item isEqual:obj]) {
                    
                    return ;
                }
                row = [self.dataItems indexOfObject:item];
            }
            
            if ([self updateSelectedImageListWithItem:item]) {
                [self.collectionView performBatchUpdates:^{
                    
                    if (self.isOne && row >= 0) {
                        
                        NSMutableArray* indexArray = [NSMutableArray array];
                        if (indexPath) {
                            
                            [indexArray addObject:indexPath];
                        }
                        NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
                        [indexArray addObject:path];
                        [self.collectionView reloadItemsAtIndexPaths:indexArray];
                    }else {
                        [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
                    }
                    
                } completion: NULL];
            }
            
            [self updatePreviewButton];
        }else {
            
            //不存在下载
            item.isLoading = YES;
            [self.collectionView performBatchUpdates:^{
                
                [self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
            } completion: NULL];
            [self downloadImageWithAsset:item.asset];
        }
    }];
}

- (void)downloadImageWithAsset:(PHAsset*)asset
{
    @weakify(self);
    [[PhotoPickerManager sharedManager] asyncTumbnailWithSize:PHImageManagerMaximumSize asset:asset allowNetwork:YES multyCallBack:NO completion:^(UIImage *resultImage, NSDictionary *resultInfo) {
       
        @strongify(self);
        if (!resultImage) {
            
            [SVProgressHUD showErrorWithStatus:@"图片下载失败"];
        }else {
            
        }
        
        [self updateCollectionItemWithPHAsset:asset];
    }];
}

- (void)updateCollectionItemWithPHAsset:(PHAsset*)asset
{
    
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        __block NSInteger row = -1;
        
        @strongify(self);
        [self.dataItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PhotoListItem* item = obj;
            if ([item.asset.localIdentifier isEqualToString:asset.localIdentifier]) {
                
                item.isLoading = NO;
                row = idx;
                *stop = YES;
            }
        }];
        
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @strongify(self);
            if (row >= 0) {
                @weakify(self);
                [self.collectionView performBatchUpdates:^{
                    @strongify(self);
                    [self.collectionView reloadItemsAtIndexPaths: @[[NSIndexPath indexPathForRow:row inSection:0]]];
                } completion: NULL];
            }
        });
    });
}

@end
