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
#import "PhotoConfigureManager.h"
#import "PhotoBaseListItem.h"
#import "PhotoUtility.h"
#import "PHButton.h"
#import "PHSelectButton.h"

#define PRE_CELL_IDENTIFIER @"prePhotoPickerCell"

@interface PhotoScrollPreviewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) PHSelectButton* selectButton;
@property (nonatomic, strong) UIButton* originImageButton;
@property (nonatomic, strong) PHButton* sendButton;
@property (nonatomic, strong) UIImageView* selectedImageView;
@property (nonatomic, strong) UIImageView* deselectedImageView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, strong) UIView* naviView;
@property (nonatomic, copy) PhotoPreviewBackBlock backBlock;
@property (nonatomic) BOOL isFirstShowOrigin;
@end

@implementation PhotoScrollPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    _isFirstShowOrigin = YES;
    // Do any additional setup after loading the view.
    [self createCollectionView];
    [self createNaviView];
    [self createBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewSafeAreaInsetsDidChange {
    
    [super viewSafeAreaInsetsDidChange];
    
    CGFloat bottomViewTop = self.view.frame.size.height - self.view.safeAreaInsets.bottom - 50;
    CGFloat naviViewTopHeight = self.view.safeAreaInsets.top;
    
    [_naviView setFrame:CGRectMake(0, 0, _naviView.frame.size.width, 60 + naviViewTopHeight)];
    [_bottomView setFrame:CGRectMake(0, bottomViewTop, _bottomView.frame.size.width, _bottomView.frame.size.height)];
}

#pragma mark -
#pragma mark -

- (void)setPreviewBackBlock:(PhotoPreviewBackBlock)backBlock
{
    self.backBlock = backBlock;
}

#pragma mark -
#pragma mark - create UI

- (void)createNaviView
{
    _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height - 60, 60)];
    [_naviView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.3]];
    [self.view addSubview:_naviView];
    
    UIButton* naviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [naviButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    [naviButton setImage:[UIImage imageNamed:@"ph_navi_white_left_arrow"] forState:UIControlStateNormal];
    [naviButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [naviButton setFrame:CGRectMake(10, 25, 30, 20)];
    naviButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    naviButton.autoresizesSubviews = YES;
    [_naviView addSubview:naviButton];
    
    _selectButton = [PHSelectButton buttonWithType:UIButtonTypeCustom];
    [_selectButton setFrame:CGRectMake(self.view.frame.size.width - 45, 20, 30, 30)];
    
    UIColor* selectColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor;
    if (selectColor) {
        [_selectButton setButtonSelectBackgroundColor:selectColor];
    }
    
    [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _selectButton.autoresizesSubviews = YES;
    _selectButton.selected = NO;
    [_naviView addSubview:_selectButton];
    
    [self updateCurrentImageSelectState:_indexPath.item];
}

- (void)createCollectionView
{
    PhotoPreviewLayout* photoLayout = [[PhotoPreviewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:photoLayout];
    _collectionView.pagingEnabled = YES;
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.autoresizesSubviews = YES;
    [_collectionView registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:PRE_CELL_IDENTIFIER];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.contentInset = UIEdgeInsetsZero;
        _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
    } else {
        // Fallback on earlier versions
    }
    
    [self.view addSubview:_collectionView];
    
    [_collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)createBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [_bottomView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.3]];
    _bottomView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _bottomView.autoresizesSubviews = YES;
    [self.view addSubview:_bottomView];
    
    UIColor* buttonColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor;
    UIColor* textColor = [PhotoConfigureManager sharedManager].sendButtontextColor;
    
    NSString* sendTitle = ([PhotoConfigureManager sharedManager].sendButtonTitle && ![[PhotoConfigureManager sharedManager].sendButtonTitle isEqualToString:@""]) ? [PhotoConfigureManager sharedManager].sendButtonTitle : @"发送";
    _sendButton = [PHButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(_bottomView.frame.size.width - 80, 10, 70, 30)];
    [_sendButton setTitle:sendTitle forState:UIControlStateNormal];
    
    if (buttonColor) {
        [_sendButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
    }
    
    if (textColor) {
        [_sendButton setTitleColor:textColor forState:UIControlStateNormal];
    }

    [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_bottomView addSubview:_sendButton];
    
    [self updateSendButtonText];
}

- (void)updateSendButtonText
{
    NSString* buttonTitle = nil;
    NSString* sendTitle = ([PhotoConfigureManager sharedManager].sendButtonTitle && ![[PhotoConfigureManager sharedManager].sendButtonTitle isEqualToString:@""]) ? [PhotoConfigureManager sharedManager].sendButtonTitle : @"发送";
    if ([PhotoPickerManager sharedManager].selectedArray.count > 0) {
        buttonTitle = [NSString stringWithFormat:@"%@ %zi/%zi",sendTitle, [PhotoPickerManager sharedManager].selectedArray.count, _maxCount];
        [_sendButton setEnabled:YES];
    }else {
        buttonTitle = sendTitle;
        [_sendButton setEnabled:NO];
    }
    [_sendButton setTitle:buttonTitle forState:UIControlStateNormal];
}

#pragma mark - 
#pragma mark - button event

- (void)backButtonClicked:(id)sender
{
    if (self.backBlock) {
        _backBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendButtonClicked:(id)sender
{
    if ([PhotoPickerManager sharedManager].selectedArray && [PhotoPickerManager sharedManager].selectedArray.count > 0) {
        if (self.dissmissBlock) {
            _dissmissBlock([PhotoPickerManager sharedManager].selectedArray);
        }
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        [PhotoConfigureManager sharedManager].currentPicker = nil;
        [[PhotoPickerManager sharedManager] clearSelectedArray];
    }
}

- (void)selectButtonClicked:(id)sender
{
    
    NSArray* array = [_collectionView visibleCells];
    if (array.count == 1) {
        
        PhotoPreviewCell* cell = array.firstObject;
        
        if (![cell isOriginImageLoading]) {
            
            BOOL isOne = (_maxCount == 1);
            NSMutableArray* tempArray = [PhotoPickerManager sharedManager].selectedArray;
            NSIndexPath* indexPath = [_collectionView indexPathForCell:cell];
            PhotoBaseListItem* item = _assets[indexPath.item];
            
            if (isOne && tempArray.count > 0) {
                
                PhotoBaseListItem* preItem = tempArray.firstObject;
                preItem.isSelected = NO;
                [tempArray removeAllObjects];
                item.isSelected = YES;
                [tempArray addObject:item];
                
            }else {
                
                if (!item.isSelected && tempArray.count >= _maxCount) {
                    [PhotoUtility showAlertWithMsg:@"选择照片数已达上限" controller:self];
                    return;
                }
                
                item.isSelected = !item.isSelected;
                if ([tempArray containsObject:item]) {
                    
                    [tempArray removeObject:item];
                }else {
                    [tempArray addObject:item];
                }
            }
            UIButton* button = sender;
            button.selected = item.isSelected;
            [self updateSendButtonText];
        }
    }
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
    if (_isFirstShowOrigin) {
        
        [cell loadOriginImage];
        _isFirstShowOrigin = NO;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = (scrollView.contentOffset.x + _collectionView.frame.size.width / 2) / _collectionView.frame.size.width;
    if (currentPage < 0 || currentPage >= _assets.count) {
        
    }else {
        
        [self updateCurrentImageSelectState:currentPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray* visibleCells = [_collectionView visibleCells];
    PhotoPreviewCell* cell = nil;
    for (PhotoPreviewCell* innerCell in visibleCells) {
        
        if (innerCell.frame.origin.x == scrollView.contentOffset.x) {
            
            cell = innerCell;
            break;
        }
    }
    
    if (cell) {
        [cell loadOriginImage];
    }
}

- (void)updateCurrentImageSelectState:(NSInteger)index
{
    if (index < 0 || index >= _assets.count) {
        return;
    }
    
    PhotoBaseListItem* item = _assets[index];
    _selectButton.selected = item.isSelected;
}

@end
