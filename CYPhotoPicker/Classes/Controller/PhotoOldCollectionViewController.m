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
#import "PhotoPreviewImageViewController.h"
#import "PhotoScrollPreviewController.h"
#import "PhotoUtility.h"
#import "PHNaviButton.h"
#import "PHButton.h"

#define OLD_CELL_IDENTIFIER @"Old_PhotoPickerCell"

@interface PhotoOldCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PhotoItemCellProtocol>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray* dataItems;
@property (nonatomic, strong) PHButton* sendButton;
@property (nonatomic, strong) PHButton* previewButton;
@property (nonatomic, assign) BOOL isDataLoading;
@end

@implementation PhotoOldCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_isOne) {
        _imageMaxCount = 1;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"全部照片";
    
    if ([PhotoConfigureManager sharedManager].naviStyle == PhotoNaviButtonStyleCYStyle) {
        [self createNaviButton];
    }
    
    [self createCollectionView];
    
    [self bottomView];
    
    [self updateImageCountView];
    
    [self loadPhotoAsset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (void)bottomView
{
    CGFloat bottomOriY = 0;
    if (PH_IOSOVER(7)) {
        
        bottomOriY = self.view.frame.size.height - 50;
    }else{
        
        bottomOriY = self.view.frame.size.height - 50 - self.navigationController.navigationBar.frame.size.height;
    }
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomOriY, self.view.frame.size.width, 50)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    if (_showPreview) {
        _previewButton = [PHButton buttonWithType:UIButtonTypeCustom];
        [_previewButton setFrame:CGRectMake(10, 10, 70, 31)];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(preButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:_previewButton];
    }
    
    _sendButton = [PHButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(bottomView.frame.size.width - 80, 10, 70, 31)];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(onSendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_sendButton];
    
    [self.view addSubview:bottomView];
    
    UIColor* buttonColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor;
    UIColor* textColor = [PhotoConfigureManager sharedManager].sendButtontextColor;
    
    if (buttonColor) {
        
        [_sendButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
        [_previewButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
    }
    
    if (textColor) {
        [_sendButton setTitleColor:textColor forState:UIControlStateNormal];
        [_previewButton setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    [_collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomView.frame.size.height)];
    
    [self updatePreviewButton];
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
        
        _isDataLoading = YES;
        
        [_self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if(result == nil) {
                return;
            }
            PhotoOldListItem *item = [[PhotoOldListItem alloc] init];
            item.url = result.defaultRepresentation.url;
            item.isSelected = [_self itemHasBeenSelected: item];
            item.delegate = self;
            [_self.dataItems addObject:item];
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            _isDataLoading = NO;
            
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

- (void)updatePreviewButton
{
    if ([PhotoPickerManager sharedManager].selectedArray.count > 0) {
        
        _previewButton.enabled = YES;
    }else {
        _previewButton.enabled = NO;
    }
}

- (void)alertMaxSelection
{
    [SVProgressHUD showErrorWithStatus:@"选择照片数已达上限"];
}

#pragma mark - 
#pragma mark - button event

- (void)preButtonClicked:(id)sender
{
    if ([PhotoPickerManager sharedManager].selectedArray.count > 0) {
        
        PH_WEAK_VAR(self);
        PhotoScrollPreviewController* controller = [[PhotoScrollPreviewController alloc] init];
        controller.assets = [PhotoPickerManager sharedManager].selectedArray;
        controller.dissmissBlock = _dissmissBlock;
        controller.maxCount = _imageMaxCount;
        [controller setPreviewBackBlock:^{
            
            [_self.collectionView reloadData];
            [_self updatePreviewButton];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)onSendBtnPressed:(id)sender
{
    NSArray* array = [[NSArray alloc] initWithArray:[PhotoPickerManager sharedManager].selectedArray];
    if (array && array.count > 0) {
        if (self.dissmissBlock) {
            self.dissmissBlock(array);
        }
        [[PhotoPickerManager sharedManager] clearSelectedArray];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
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
    PhotoOldListItemCell *cell =
    (PhotoOldListItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:OLD_CELL_IDENTIFIER
                                                                   forIndexPath:indexPath];
    [cell shouldUpdateItemCellWithObject:_dataItems[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PH_WEAK_VAR(self);
    
    if (_isDataLoading) {
        
        //防止数据正在加载中，点击之后崩溃
        return;
    }
    
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
        
        if (_showPreview) {
            PhotoScrollPreviewController* controller = [[PhotoScrollPreviewController alloc] init];
            controller.assets = _dataItems;
            controller.dissmissBlock = _dissmissBlock;
            controller.indexPath = indexPath;
            controller.maxCount = _imageMaxCount;
            [controller setPreviewBackBlock:^{
                
                [_self.collectionView reloadData];
                [_self updatePreviewButton];
            }];
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
}

- (void)didTapImageInCell:(UICollectionViewCell *)cell object:(id)obj
{
    PH_WEAK_VAR(self);
    NSIndexPath* indexPath = [_collectionView indexPathForCell:cell];
    PhotoOldListItem* item = obj;
    if ([self updateSelectedImageListWithItem:item]) {
        [self.collectionView performBatchUpdates:^{
            
            [_self.collectionView reloadItemsAtIndexPaths: @[indexPath]];
        } completion: NULL];
    }
    [self updatePreviewButton];
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
