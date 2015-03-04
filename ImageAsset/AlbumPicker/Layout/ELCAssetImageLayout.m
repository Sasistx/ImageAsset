//
//  ELCAssetImageLayout.m
//  ImageAsset
//
//  Created by baidu on 15/1/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "ELCAssetImageLayout.h"

@interface ELCAssetImageLayout ()
@property (assign, nonatomic) NSInteger itemCount;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (strong, nonatomic) NSMutableArray *columnHeights;
@property (strong, nonatomic) NSMutableArray *itemAttributes;
@end

@implementation ELCAssetImageLayout

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (void)setColumnCount:(NSUInteger)columnCount
{
    if (_columnCount != columnCount) {
        _columnCount = columnCount;
        [self invalidateLayout];
    }
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    if (_itemWidth != itemWidth) {
        _itemWidth = itemWidth;
        [self invalidateLayout];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _columnCount = 4;
    _itemWidth = self.collectionView.frame.size.width / _columnCount;
    _sectionInset = UIEdgeInsetsZero;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    _itemCount = [[self collectionView] numberOfItemsInSection:0];
    
    CGFloat width = self.collectionView.frame.size.width - _sectionInset.left - _sectionInset.right;
    
    _interitemSpacing = floorf((width - _columnCount * _itemWidth) / (_columnCount - 1));
    
    _itemAttributes = [NSMutableArray arrayWithCapacity:0];
    _columnHeights = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger idx = 0; idx < _columnCount; idx++) {
        
        [_columnHeights addObject:@(_sectionInset.top)];
    }
    
    for (NSInteger idx = 0; idx < _itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGFloat itemHeight = [self.delegate collectionView:self.collectionView
                                                    layout:self
                                  heightForItemAtIndexPath:indexPath];
        NSUInteger columnIndex = [self shortestColumnIndex];
        CGFloat xOffset = _sectionInset.left + (_itemWidth + _interitemSpacing) * columnIndex;
        CGFloat yOffset = [(_columnHeights[columnIndex]) floatValue];
        
        UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(xOffset, yOffset, self.itemWidth, itemHeight);
        [_itemAttributes addObject:attributes];
        _columnHeights[columnIndex] = @(yOffset + itemHeight + _interitemSpacing);
    }
}

- (CGSize)collectionViewContentSize
{
    if (self.itemCount == 0) {
        return CGSizeZero;
    }
    CGSize contentSize = self.collectionView.frame.size;
    NSUInteger columnIndex = [self longestColumnIndex];
    CGFloat height = [self.columnHeights[columnIndex] floatValue];
    contentSize.height = height - self.interitemSpacing + self.sectionInset.bottom;
    return contentSize;
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

#pragma mark - Private Methods
// Find out shortest column.
- (NSUInteger)shortestColumnIndex
{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

// Find out longest column.
- (NSUInteger)longestColumnIndex
{
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

@end
