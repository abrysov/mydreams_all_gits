//
//  PMListConversationsVC.m
//  MyDreams
//
//  Created by Alexey Yakunin on 28/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListConversationsVC.h"
#import "PMConversationCollectionCell.h"
#import "MessagesCollectionViewCells.h"
#import "PMSearchView.h"
#import "UIColor+MyDreams.h"
#import "PMSwipeButton.h"

NSString *const kPMConversationsEmptyHeaderReuseIdentifier = @"kPMConversationsEmptyHeaderReuseIdentifier";

@interface PMListConversationsVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet PMSearchView *searchView;
@end

@implementation PMListConversationsVC

- (void)setupLocalization
{
	[super setupLocalization];
	self.title = [NSLocalizedString(@"messages.conversations_list.title", nil) uppercaseString];
	self.searchView.placeholder = NSLocalizedString(@"messages.conversations_list.search_placeholder", nil);
}

- (void)setupUI
{
	[super setupUI];
	[self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPMConversationsEmptyHeaderReuseIdentifier];
}
#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PMConversationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cell.kPMReuseIdentifierConversationCell forIndexPath:indexPath];
	
	PMSwipeButton* deleteButton = [PMSwipeButton buttonWithTitle:NSLocalizedString(@"messages.conversations_list.delete", nil) backgroundColor:[UIColor conversationCellDeleteSwipeButtonColor] callback:^(UITableViewCell *cell) {
		NSLog(@"%@ delete button pressed", indexPath);
	}];

	cell.buttons = @[deleteButton];

	return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:kPMConversationsEmptyHeaderReuseIdentifier forIndexPath:indexPath];
}

@end
