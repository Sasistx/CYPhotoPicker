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

@interface PhotoAlbumListController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray* albumsArray;
@property (nonatomic, strong) NSMutableArray* albumsPosterArray;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, copy) PhotoPickerDismissBlock dissmissBlock;
@end

@implementation PhotoAlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"照片";
    [self createTableView];
    [self createNaviButton];
    [self getAlbumsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    PH_WEAK_VAR(self);
    _albumsArray = [NSMutableArray array];
    _albumsPosterArray = [NSMutableArray array];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection* collection, NSUInteger idx, BOOL * _Nonnull stop) {
        //209所有照片       //206最近添加   //211屏幕快照
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary || collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
            
            [_self insertCollectionToArray:collection];
        }
        
        if (PH_IOSOVER(9) && collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumScreenshots) {
            
            [_self insertCollectionToArray:collection];
        }
        
        
    }];
    [topLevelUserCollections enumerateObjectsUsingBlock:^(PHAssetCollection* collection, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [_self insertCollectionToArray:collection];
    }];
}

- (void)createNaviButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
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
    [self.tableView reloadData];
}

#pragma mark - button event

- (void)cancelButtonClicked:(id)sender
{
    [[PhotoPickerManager sharedManager] clearSelectedArray];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    
    }];
}

#pragma mark -
#pragma mark - public method

- (void)setPhotoCompeletionBlock:(PhotoPickerDismissBlock)dissmissBlock
{
    self.dissmissBlock = dissmissBlock;
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
    PhotoCollectionListViewController* controller = [[PhotoCollectionListViewController alloc] init];
    controller.isOne = self.isOne;
    controller.showPreview = self.showPreview;
    controller.dissmissBlock = self.dissmissBlock;
    PhotoAlbumItem* item = _albumsArray[indexPath.row];
    controller.fetchResult = item.assetsFetchResult;
    controller.collection = item.collection;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
