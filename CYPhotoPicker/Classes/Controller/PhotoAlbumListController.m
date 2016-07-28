//
//  PhotoAlbumListController.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/1/5.
//  Copyright © 2016年 lvjianxiong. All rights reserved.
//

#import <Photos/Photos.h>

#import "PhotoAlbumListController.h"
#import "PhotoAlbumItem.h"
#import "PhotoCollectionListViewController.h"
#import "CYPhotoPickerDefines.h"

@interface PhotoAlbumListController () <UITableViewDelegate, UITableViewDataSource, PHPhotoLibraryChangeObserver>
@property (nonatomic, strong) NSMutableArray* albumsArray;
@property (nonatomic, strong) NSMutableArray* albumsPosterArray;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) NSInteger cameraRollIndex;
@end

@implementation PhotoAlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"照片";
    _cameraRollIndex = -1;
    [self createTableView];
    [self createNaviButton];
    [self getAlbumsList];
    [self registPhotoChange];
    
    if (_cameraRollIndex >= 0) {
       
        [self pushToCollectionList:_cameraRollIndex animate:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark -
#pragma mark - UI

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)getAlbumsList
{
    @weakify(self);
    if (!_albumsArray) {
        _albumsArray = [NSMutableArray array];
    }else {
        [_albumsArray removeAllObjects];
    }
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [smartAlbums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //209所有照片       //206最近添加   //211屏幕快照
        
        @strongify(self);
        if (![obj isKindOfClass:[PHCollectionList class]]) {
            
            PHAssetCollection* collection = obj;
            
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary || collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                
                [self insertCollectionToArray:collection];
            }
            
            if (PH_IOSOVER(9) && collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumScreenshots) {
                
                [self insertCollectionToArray:collection];
            }
        }
        
    }];
    [topLevelUserCollections enumerateObjectsUsingBlock:^(id collection, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @strongify(self);
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            [self insertCollectionToArray:collection];
        }else if ([collection isKindOfClass:[PHCollectionList class]]){
            
            [self fetchCollectionListAsset:collection];
        }
    }];
}

- (void)fetchCollectionListAsset:(PHCollectionList*)list
{
    @weakify(self);
    PHFetchResult* result = [PHAssetCollection fetchMomentsInMomentList:list options:nil];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if ([obj isKindOfClass:[PHAssetCollection class]]) {
            [self insertCollectionToArray:obj];
        }
    }];
}

- (void)createNaviButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)insertCollectionToArray:(PHAssetCollection* )collection
{
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    if (assetsFetchResult.count > 0) {
        PhotoAlbumItem* item = [[PhotoAlbumItem alloc] init];
        item.collection = collection;
        item.assetsFetchResult = assetsFetchResult;
        [_albumsArray addObject:item];
    }
    
    if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
        
        self.cameraRollIndex = _albumsArray.count - 1;
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - push to camera roll

- (void)pushToCollectionList:(NSInteger)row animate:(BOOL)animated
{
    PhotoCollectionListViewController* controller = [[PhotoCollectionListViewController alloc] init];
    controller.showPreview = self.showPreview;
    controller.dissmissBlock = self.dissmissBlock;
    controller.imageMaxCount = _maxCount;
    PhotoAlbumItem* item = _albumsArray[row];
    controller.fetchResult = item.assetsFetchResult;
    controller.collection = item.collection;
    [self.navigationController pushViewController:controller animated:animated];
}

#pragma mark -
#pragma mark - register change

- (void)registPhotoChange
{
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    [self getAlbumsList];
}

#pragma mark -
#pragma mark - button event

- (void)cancelButtonClicked:(id)sender
{
    [[PhotoPickerManager sharedManager] clearSelectedArray];
    if (_dissmissBlock) {
        _dissmissBlock(nil);
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    
    }];
    [PhotoConfigureManager sharedManager].currentPicker = nil;
}

#pragma mark - tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCYAlbumItemCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_albumsArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"tableCellId";
    PhotoAlbumItemCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[PhotoAlbumItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell phCellShouldUpdateWithObject:_albumsArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToCollectionList:indexPath.row animate:YES];
}

@end
