//
//  PMDetailedLikesLogic.m
//  MyDreams
//
//  Created by Alexey Yakunin on 22/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedLikesLogic.h"
#import "PMDetailedLikesViewModelImpl.h"
#import "PMDetailedLikesContext.h"
#import "PMLikeApiClient.h"
#import "PMDreamer.h"
#import "PMLike.h"
#import "PMDreambookDreamerViewModelImpl.h"
#import "PMImageDownloader.h"
#import "PMLikesResponse.h"
#import "PMPaginationResponseMeta.h"

@interface PMDetailedLikesLogic()
@property (strong, nonatomic) PMDetailedLikesViewModelImpl *viewModel;
@property (strong, nonatomic) PMDetailedLikesContext *context;
@end

@implementation PMDetailedLikesLogic
@dynamic context;

- (void)startLogic
{
	[super startLogic];
	self.viewModel = [[PMDetailedLikesViewModelImpl alloc] init];

	self.viewModel.title = [self titleForVC];
	
	@weakify(self);
	RAC(self, viewModel.dreamers) = [RACObserve(self, items)
		map:^id(NSArray *items) {
			@strongify(self);
			return [self likesToDreamerViewModels:items];
	}];
}

- (RACSignal *)loadPage:(PMPage *)page
{
	@weakify(self);
	return [[[self.likeApiClient getDreamersWhoLikedEntityWithIdx:self.context.idx entityType:PMEntityTypePost page:page]
		doNext:^(PMLikesResponse *response) {
			@strongify(self);
			PMDetailedLikesViewModelImpl* viewModel = self.viewModel;
			viewModel.totalCount = response.meta.totalCount;
		}]
		map:^id(PMLikesResponse *response) {
			return RACTuplePack(response.likes, response.meta);
		}];
}

#pragma mark - private

- (NSString *)titleForVC
{
	NSString* title;
	switch (self.context.type) {
		case PMEntityTypePost:
			title = NSLocalizedString(@"dreambook.detailed_likes.post", nil);
			break;
		case PMEntityTypeDream:
			title = NSLocalizedString(@"dreambook.detailed_likes.dream", nil);;
			break;
		default:
			break;
	}
	title = [[title stringByAppendingString:NSLocalizedString(@"dreambook.detailed_likes.liked", nil)] uppercaseString];
	
	return title;
}
#pragma mark - private

- (NSArray *)likesToDreamerViewModels:(NSArray *)likes
{
	NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:likes.count];
	
	for (PMLike *like in likes) {
		PMDreambookDreamerViewModelImpl *viewModel = [[PMDreambookDreamerViewModelImpl alloc] initWithDreamer:like.dreamer];

		NSURL *avatarUrl = [NSURL URLWithString:like.dreamer.avatar.medium];
		viewModel.avatarSignal = [self.imageDownloader imageForURL:avatarUrl];
		[viewModels addObject:viewModel];
	}
	return [NSArray arrayWithArray:viewModels];
}

@end
