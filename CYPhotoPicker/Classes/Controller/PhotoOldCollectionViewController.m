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
#import "PhotoUtility.h"

#define OLD_CELL_IDENTIFIER @"Old_PhotoPickerCell"

@interface PhotoOldCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger imageMaxCount;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* dataItems;
@property (nonatomic, strong) NSMutableArray* sendingOperationQueue;
@property (nonatomic, strong) NSMutableArray* selectedImages;
@property (nonatomic, strong) UIButton* sendButton;
@end

@implementation PhotoOldCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_isOne) {
        _imageMaxCount = 1;
    }else {
        _imageMaxCount = 9;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"全部照片";
    
    [self createCollectionView];
    
    [self bottomView];
    
    [self updateImageCountView];
    
    [self loadPhotoAsset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bottomView
{
    UIColor* textColor = [PhotoConfigureManager sharedManager].sendButtontextColor ? [PhotoConfigureManager sharedManager].sendButtontextColor : [UIColor whiteColor];
    UIColor* buttonColor = [PhotoConfigureManager sharedManager].sendButtonColor ? [PhotoConfigureManager sharedManager].sendButtonColor : [UIColor blackColor];
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(bottomView.frame.size.width - 80, 10, 70, 31)];
    [_sendButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:textColor forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(onSendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_sendButton];
    
    [self.view addSubview:bottomView];
    
    [_collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _sendButton.frame.size.height)];
}

- (void) updateImageCountView
{
    [_sendButton setTitle:[NSString stringWithFormat: @"发送 %zi/%zi", [PhotoPickerManager sharedManager].selectedArray.count, _imageMaxCount] forState:UIControlStateNormal];
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
        
        [_self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if(result == nil) {
                return;
            }
            PhotoOldListItem *item = [[PhotoOldListItem alloc] init];
            item.url = result.defaultRepresentation.url;
            item.isSelected = [_self itemHasBeenSelected: item];
            UIImage *thumbImage = [UIImage imageWithCGImage: result.thumbnail];
            item.thumbImage = thumbImage;
            [_self.dataItems addObject:item];
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
            [_self didFinishLoadItem];
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

- (void)createCollectionView
{
    PhotoCollectionViewLayout *layout = [[PhotoCollectionViewLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[PhotoOldListItemCell class]
        forCellWithReuseIdentifier:OLD_CELL_IDENTIFIER];
    [self.view addSubview:self.collectionView];
}

- (BOOL) updateSelectedImageListWithItem:(PhotoOldListItem*)item
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

#pragma mark - 
#pragma mark - button event

- (void)onSendBtnPressed:(id)sender
{
    PH_WEAK_VAR(self);
    
    _selectedImages = [NSMutableArray array];
    _sendingOperationQueue = [NSMutableArray array];
    NSMutableArray* tempArray = [PhotoPickerManager sharedManager].selectedArray;
    [tempArray enumerateObjectsUsingBlock:^(PhotoOldListItem* item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            
            [PhotoUtility loadChunyuPhoto:item success:^(UIImage *image) {
                
                [_self.selectedImages addObject:image];
                [_self nextImageTask];
            } failure:^(NSError *error) {
                [_self nextImageTask];
            }];
        }];
        [_self.sendingOperationQueue addObject:op];
    }];
    
    [self nextImageTask];
}

- (void)nextImageTask {
    
    PH_WEAK_VAR(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_self.sendingOperationQueue.count > 0) {
            NSOperation *op = _self.sendingOperationQueue.firstObject;
            [_self.sendingOperationQueue removeObjectAtIndex:0];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [op start];
            });
        }else{
            [_self imageOperationDone];
        }
    });
}

- (void)imageOperationDone
{
    if (self.dissmissBlock) {
        
        self.dissmissBlock(_selectedImages);
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    [[PhotoPickerManager sharedManager] clearSelectedArray];
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
        controller.item = _dataItems[indexPath.item];
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        PhotoOldListItem* item = _dataItems[indexPath.item];
        if ([self updateSelectedImageListWithItem:item]) {
            [self.collectionView performBatchUpdates:^{
                
                [_self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
            } completion: NULL];
        }
    }
}

#pragma mark - 
#pragma mark - private method

//
// 当前的url是否已经在选中的list内
//
- (BOOL)itemHasBeenSelected:(PhotoOldListItem*)item
{
    NSMutableArray* selectedArray = [PhotoPickerManager sharedManager].selectedArray;
    
    for (PhotoOldListItem *existItem in selectedArray) {
        
        if ([existItem.url.absoluteString isEqualToString: item.url.absoluteString]) {
            
            return YES;
        }
    }
    
    return NO;
}

// 当前的url是否重复
- (BOOL)urlHasBeenAdded:(NSArray *)dataItems item:(PhotoOldListItem *)item {
    
    for (PhotoOldListItem *existItem in dataItems) {
        
        if ([existItem.url.absoluteString isEqualToString: item.url.absoluteString]) {
            
            return YES;
        }
    }
    
    return NO;
}

@end
