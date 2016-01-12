//
//  PhotoCollectionViewLayout.h
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/8.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoCollectionViewLayout;
@protocol PhotoCollectionViewLayoutDelegate <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(PhotoCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface PhotoCollectionViewLayout : UICollectionViewLayout
@property (nonatomic, weak) id <PhotoCollectionViewLayoutDelegate> delegate;
@property (nonatomic, assign) NSUInteger columnCount;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@end
