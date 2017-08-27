//
//  PMCollectionViewConversationLayout.m
//  MyDreams
//
//  Created by Alexey Yakunin on 29/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCollectionViewConversationLayout.h"

CGFloat const kPMStrangeConversationLayoutFraction = 0.94;

@implementation PMCollectionViewConversationLayout

- (void)setup
{
	[super setup];
	self.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 20.0);
}

- (CGSize)itemSize
{
	CGFloat itemWidth = CGRectGetWidth(self.collectionView.frame) / self.columnCount;
	return CGSizeMake(itemWidth, round(itemWidth * kPMStrangeConversationLayoutFraction));
}

@end
