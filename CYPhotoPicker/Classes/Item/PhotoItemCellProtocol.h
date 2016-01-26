//
//  PhotoItemCellProtocol.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/26.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PhotoItemCellProtocol <NSObject>

- (void)didTapImageInCell:(UICollectionViewCell *)cell object:(id)obj;

@end
