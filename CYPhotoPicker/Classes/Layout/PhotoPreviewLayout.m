//
//  PhotoPreviewLayout.m
//  CYPhotoPicker
//
//  Created by 高天翔 on 16/1/20.
//  Copyright © 2016年 CYGTX. All rights reserved.
//

#import "PhotoPreviewLayout.h"

@interface PhotoPreviewLayout ()
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@end

@implementation PhotoPreviewLayout

#pragma mark - Init
- (void)commonInit
{
//    _columnCount = kColumnCount;
//    _itemWidth = ([UIScreen mainScreen].bounds.size.width / _columnCount) - 2;
//    _sectionInset = UIEdgeInsetsZero;
    _itemAttributes = [NSMutableArray arrayWithCapacity:0];
//    _columnHeights = [NSMutableArray arrayWithCapacity:0];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (_itemAttributes.count > 0) {
        
        [_itemAttributes removeAllObjects];
    }
    
    _itemCount = [[self collectionView] numberOfItemsInSection:0];
    
    for (NSInteger idx = 0; idx < _itemCount; idx++) {
        
        CGFloat originX = ([self collectionView].frame.size.width) * idx;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(originX, 0, [self collectionView].frame.size.width, [self collectionView].frame.size.height);
        
        [_itemAttributes addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake([self collectionView].frame.size.width * _itemCount, [self collectionView].bounds.size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    return (self.itemAttributes)[path.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

@end
