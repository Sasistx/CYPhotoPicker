//
//  PhotoOldAlbumViewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/14.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoOldAlbumViewController.h"
#import "PhotoOldAlbumItem.h"
#import "PhotoOldCollectionViewController.h"

@interface PhotoOldAlbumViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* albumTableView;
@property (nonatomic, strong) NSMutableArray* assetGroups;
@property (nonatomic, strong) ALAssetsLibrary *library;
@end

@implementation PhotoOldAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"相册";
    
    if (PH_IOSOVER(7)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _albumTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_albumTableView setDelegate:self];
    [_albumTableView setDataSource:self];
    [self.view addSubview:_albumTableView];
    
    [self createNaviButton];
    
    _assetGroups = [NSMutableArray array];
    
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(libraryChanged:) name:ALAssetsLibraryChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetChanged:) name:ALAssetLibraryUpdatedAssetsKey object:nil];
    
    [self loadAlbumData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - load data

- (void)loadAlbumData
{
    [_assetGroups removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       @autoreleasepool {
                           // Group enumerator Block
                           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                           {
                               if (group == nil) {
                                   return;
                               }
                               
                               // added fix for camera albums order
                               NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                               NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                               
                               PhotoOldAlbumItem* item = [[PhotoOldAlbumItem alloc] init];
                               item.group = group;
                               if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                                   
                                   [self.assetGroups insertObject:item atIndex:0];
                               }
                               else {
                                   [self.assetGroups addObject:item];
                               }
                               
                               // Reload albums
                               [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                           };
                           
                           // Group Enumerator Failure Block
                           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                               
                               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               [alert show];
                               
                               NSLog(@"A problem occured %@", [error description]);
                           };
                           
                           // Enumerate Albums
                           [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                                       usingBlock:assetGroupEnumerator
                                                     failureBlock:assetGroupEnumberatorFailure];
                       }
                   });
}

#pragma mark -
#pragma mark - createView

- (void)createNaviButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - button event

- (void)cancelButtonClicked:(id)sender
{
    [[PhotoPickerManager sharedManager] clearSelectedArray];
    if (_dissmissBlock) {
        _dissmissBlock(nil);
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark Table view data source & delegate

- (void)reloadTableView
{
    [self.albumTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"tableCellId";
    PhotoOldAlbumItemCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[PhotoOldAlbumItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell phCellShouldUpdateWithObject:_assetGroups[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoOldCollectionViewController* controller = [[PhotoOldCollectionViewController alloc] init];
    PhotoOldAlbumItem* item = self.assetGroups[indexPath.row];
    controller.assetGroup = item.group;
    controller.isOne = self.isOne;
    controller.showPreview = self.showPreview;
    controller.dissmissBlock = self.dissmissBlock;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 
#pragma mark - notification

- (void)libraryChanged:(NSNotification*)note
{
    PH_WEAK_VAR(self);
    NSLog(@"libraryChanged:%@", note.userInfo);
    NSSet* AssetsKey = note.userInfo[@"ALAssetLibraryUpdatedAssetsKey"];
    NSLog(@"url:%@", AssetsKey);
    if (AssetsKey) {
        
        [AssetsKey enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            
            NSURL* urlStr = obj;
            [_self.library assetForURL:urlStr resultBlock:^(ALAsset *asset) {
                
                NSLog(@"date:%@", [asset valueForProperty:ALAssetPropertyDate]);
            } failureBlock:^(NSError *error) {
                
            }];
        }];
        
    }
    [self loadAlbumData];
}

- (void)assetChanged:(NSNotification*)note
{
    NSLog(@"assetChanged:%@", note.userInfo);
}

@end
