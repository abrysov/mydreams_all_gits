//
//  PMCollectionViewThreeColumnLayout.m
//  MyDreams
//
//  Created by Иван Ушаков on 12.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCollectionViewColumnLayout.h"

@implementation PMCollectionViewColumnLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

#pragma mark - private

- (CGSize)itemSize
{
    CGFloat itemWidth = CGRectGetWidth(self.collectionView.frame) / self.columnCount;
    return CGSizeMake(itemWidth, itemWidth);
}

- (CGFloat)minimumInteritemSpacing
{
    return 0;
}

- (CGFloat)minimumLineSpacing
{
    return 0;
}

@end
