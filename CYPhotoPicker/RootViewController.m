//
//  RootViewController.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/7.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "RootViewController.h"
#import "CYPhotoPicker.h"
#import "PhotoBaseListItem.h"
#import "PhotoUtility.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CYPhotoPicker* picker;
@property (nonatomic, strong) NSArray* temp;
@property (nonatomic, assign) NSInteger count;
@end

@implementation RootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellid = @"cellid";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"弹出相册";
            break;
        case 1:
            cell.textLabel.text = @"测试数组";
            break;
        case 2:
            cell.textLabel.text = @"创建相册";
            break;
        case 3:
            cell.textLabel.text = @"保存照片200次";
            break;
        case 4:
            cell.textLabel.text = @"预览网络图片";
            break;
        case 5:
            cell.textLabel.text = @"保存image到沙盒";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            CYPhotoPicker* picker = [CYPhotoPicker showFromController:self option:PhotoPickerOptionAlbum | PhotoPickerOptionCamera showPreview:YES compeletionBlock:^(NSArray *imageAssets) {
                
                [[PhotoPickerManager sharedManager] asyncGetOriginImageWithAsset:imageAssets[0] completion:^(UIImage *image) {
                    
                    
                }];
            }];
            picker.maxCount = 9;
            picker.sendButtonTitle = @"确定";
            [picker show];
        }
            
            break;
        case 1:
        {
            NSLog(@"=----%@", _temp);
        }
            break;
        case 2:
        {
            [[PhotoPickerManager sharedManager] saveImage:[UIImage imageNamed:@"0.jpg"] toAlbum:@"春雨" completion:^(NSError *error) {
                
            }];
        }
            break;
        case 3:
        {
            CYPhotoPicker* picker = [CYPhotoPicker showFromController:self option:PhotoPickerOptionAlbum | PhotoPickerOptionCamera showPreview:YES compeletionBlock:^(NSArray *imageAssets) {
                
            }];
            picker.maxCount = 9;
            [picker show];
        }
            break;
        case 4:
        {
            PhotoNetworkItem* item1 = [[PhotoNetworkItem alloc] init];
            item1.url = @"https://support.apple.com/content/dam/edam/applecare/images/en_US/ipad/ipad/featured-promo-ipad-photos_2x.jpg";
            PhotoNetworkItem* item2 = [[PhotoNetworkItem alloc] init];
            item2.url = @"https://support.apple.com/content/dam/edam/applecare/images/en_US/ipad/featured_content_appleid-4up_icon_2x.png";
            PhotoNetworkItem* item3 = [[PhotoNetworkItem alloc] init];
            item3.url = @"https://support.apple.com/content/da/edam/applecare/images/en_US/ipad/featured_content_appleid-4up_icon_2x.png";
            PhotoNetworkItem* item4 = [[PhotoNetworkItem alloc] init];
            item4.url = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test"];
            [CYPhotoPicker showFromeController:self imageList:@[item1, item2, item3, item4] currentIndex:0 placeholderImage:[UIImage imageNamed:@"ph_holder"]];
        }
            break;
        case 5:
        {
            UIImage* image = [UIImage imageNamed:@"ph_photo_selected_arrow"];
            NSFileManager* manager = [NSFileManager defaultManager];
            NSString* tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test"];
            if (![manager fileExistsAtPath:tempPath]) {
                
                NSData* data = UIImagePNGRepresentation(image);
                [data writeToFile:tempPath atomically:YES];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)buttonClicked:(id)sender
{

}

- (void)testbuttonClicked:(id)sender
{
    NSLog(@"=----%@", _temp);
}

- (void)albumButtonClicked:(id)sender
{

}

- (void)addPhotoButtonClicked:(id)sender
{
    

}

- (void)prePhotoButtonClicked:(id)sender
{

}

- (void)savePhoto:(UIImage*)image
{
    @weakify(self);
    [[PhotoPickerManager sharedManager] saveImage:image toAlbum:@"春雨" completion:^(NSError* error){
        
        @strongify(self);
        self.count ++;
        
        NSLog(@"%-----zi", self.count);
        if (self.count > 1200) {
            [PhotoUtility showAlertWithMsg:@"保存完成" controller:self];
        }else {
            [self savePhoto:image];
        }
    }];
}

@end
