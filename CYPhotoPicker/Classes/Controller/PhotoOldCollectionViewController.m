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
@property (nonatomic, strong) UIButton* sendButton;
@end

@implementation PhotoOldCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"全部照片";
    
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
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(bottomView.frame.size.width - 80, 10, 70, 31)];
    [_sendButton setBackgroundImage:[PhotoUtility imageWithColor:kPHSendBtnColor] forState:UIControlStateNormal];
    [_sendButton setBackgroundImage:[PhotoUtility imageWithColor:kPHSendBtnBorderColor] forState:UIControlStateHighlighted];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *dataItems = [NSMutableArray array];
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        // 获取图片
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    
                    PhotoOldListItem *item = [[PhotoOldListItem alloc] init];
                    item.url = result.defaultRepresentation.url;
                    item.isSelected = [self itemHasBeenSelected: item];
                    
                    UIImage *thumbImage = [UIImage imageWithCGImage: result.thumbnail];
                    item.thumbImage = thumbImage;
                    
                    [dataItems addObject:item];
                }
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            
            NSString* name = [group valueForProperty:ALAssetsGroupPropertyName];
            NSLog(@"---name:%@", name);
            if (group!=nil) {
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
            
            // 获取完数据
            NSMutableArray *resultData = [[[dataItems reverseObjectEnumerator] allObjects] mutableCopy];
            
            // 添加拍的照片（在相册中没有）
            for (NSInteger i = [PhotoPickerManager sharedManager].selectedArray.count - 1; i >= 0; --i) {
                
                PhotoOldListItem* findItem = [PhotoPickerManager sharedManager].selectedArray[i];
                if (findItem.originImage) {
                    
                    PhotoOldListItem* item = [[PhotoOldListItem alloc] init];
                    item.isSelected = YES;
                    
                    // 过滤重复
                    if ([self urlHasBeenAdded:[dataItems copy] item:item]) {
                        
                    } else {
                        
                        [resultData insertObject:item atIndex:0];
                    }
                }
            }
            
            if (_showCamera) {
                // 添加拍照的按钮
                PhotoOldListItem* cameraItem = [[PhotoOldListItem alloc] init];
                cameraItem.thumbImage = [UIImage imageNamed:@"photo_list_camera.png"];
                [resultData insertObject: cameraItem atIndex: 0];
            }
            
            // 告诉collectionModel数据加载已经完成
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataItems = resultData;
                [self didFinishLoadItem];
            });
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
}

- (void)didFinishLoadItem
{
    [_collectionView reloadData];
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
    
}

#pragma mark - 
#pragma mark - button event

- (void)onSendBtnPressed:(id)sender
{
    
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
