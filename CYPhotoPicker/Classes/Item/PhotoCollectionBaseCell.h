//
//  PhotoCollectionBaseCell.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/12.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPhotoPickerDefines.h"

@interface PhotoCollectionBaseCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* thumbImageView;
@property (nonatomic, strong) UIView* blackCoverView;
@property (nonatomic, strong) UIImageView* selectedIcon;
@property (nonatomic, strong) id item;

- (void)shouldUpdateItemCellWithObject:(id)obj;

- (void)selectButtonClicked:(id)sender;

@end
