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

#define PRE_CELL_IDENTIFIER @"prePhotoPickerCell"

@interface PhotoScrollPreviewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) PHSelectButton* selectButton;
@property (nonatomic, strong) UIButton* originImageButton;
@property (nonatomic, strong) PHButton* sendButton;
@property (nonatomic, strong) UIImageView* selectedImageView;
@property (nonatomic, strong) UIImageView* deselectedImageView;
@property (nonatomic, copy) PhotoPreviewBackBlock backBlock;
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    UIView* naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height - 60, 60)];
    [naviView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
    [self.view addSubview:naviView];
    
    UIButton* naviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [naviButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    [naviButton setImage:[UIImage imageNamed:@"ph_navi_white_left_arrow"] forState:UIControlStateNormal];
    [naviButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [naviButton setFrame:CGRectMake(10, 25, 30, 20)];
    [naviView addSubview:naviButton];
    
    _selectButton = [PHSelectButton buttonWithType:UIButtonTypeCustom];
    [_selectButton setFrame:CGRectMake(self.view.frame.size.width - 45, 20, 30, 30)];
    
    UIColor* selectColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor;
    if (selectColor) {
        [_selectButton setButtonSelectBackgroundColor:selectColor];
    }
    
    [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.selected = NO;
    [naviView addSubview:_selectButton];
    
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
    [_collectionView registerClass:[PhotoPreviewCell class] forCellWithReuseIdentifier:PRE_CELL_IDENTIFIER];
    [self.view addSubview:_collectionView];
    
    [_collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)createBottomView
{
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
    [self.view addSubview:bottomView];
    
    UIColor* buttonColor = [PhotoConfigureManager sharedManager].buttonBackgroundColor;
    UIColor* textColor = [PhotoConfigureManager sharedManager].sendButtontextColor;
    
    _sendButton = [PHButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(bottomView.frame.size.width - 80, 10, 70, 30)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    
    if (buttonColor) {
        [_sendButton setBackgroundImage:[PhotoUtility imageWithColor:buttonColor] forState:UIControlStateNormal];
    }
    
    if (textColor) {
        [_sendButton setTitleColor:textColor forState:UIControlStateNormal];
    }

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
        [_sendButton setEnabled:YES];
    }else {
        buttonTitle = @"发送";
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
    }
}

- (void)selectButtonClicked:(id)sender
{
    
    NSArray* array = [_collectionView visibleCells];
    if (array.count == 1) {
        
        PhotoPreviewCell* cell = array.firstObject;
        
        if (![cell isOriginImageLoading]) {
            
            NSIndexPath* indexPath = [_collectionView indexPathForCell:cell];
            
            NSMutableArray* tempArray = [PhotoPickerManager sharedManager].selectedArray;
            PhotoBaseListItem* item = _assets[indexPath.item];
            if (!item.isSelected && tempArray.count >= 9) {
                
                [SVProgressHUD showErrorWithStatus:@"选择照片数已达上限"];
                return;
            }
            
            item.isSelected = !item.isSelected;
            if ([tempArray containsObject:item]) {
                
                [tempArray removeObject:item];
            }else {
                [tempArray addObject:item];
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

- (void)updateCurrentImageSelectState:(NSInteger)index
{
    if (index < 0 || index >= _assets.count) {
        return;
    }
    
    PhotoBaseListItem* item = _assets[index];
    _selectButton.selected = item.isSelected;
}

@end
