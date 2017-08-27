//
//  PMDetailedPostPageLogic.m
//  MyDreams
//
//  Created by user on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedPostLogic.h"
#import "PMBaseModelIdxContext.h"
#import "PMPostApiClient.h"
#import "PMImageDownloader.h"
#import "PMLikeApiClient.h"
#import "PMBaseLogic+Protected.h"
#import "PMPostResponse.h"
#import "PMDetailedPostPageViewModelImpl.h"
#import "PMPost.h"
#import "PMPostPhoto.h"
#import "DreambookSegues.h"
#import "PMDetailedLikesContext.h"
#import "PMUserProvider.h"
#import "PMDetailedPostContext.h"
#import "PMCommentsApiClient.h"

NSString * const PMDetailedPostLogicErrorDomain = @"com.mydreams.DetailedPost.logic.error";

@interface PMDetailedPostLogic ()
@property (strong, nonatomic) PMBaseModelIdxContext *context;
@property (strong, nonatomic) PMDetailedPostPageViewModelImpl *viewModel;
@property (nonatomic, strong) RACCommand *likedCommand;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *toEditingPostCommand;
@property (nonatomic, strong) RACCommand *deletePostCommand;
@property (nonatomic, strong) RACCommand *likesListCommand;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) PMPost *post;
@property (strong, nonatomic) NSNumber *postIdx;
@end

@implementation PMDetailedPostLogic
@dynamic context;

- (void)startLogic
{
    self.postIdx = self.context.idx;
    [super startLogic];
    self.likedCommand = [self createLikedCommand];
    self.toEditingPostCommand = [self createToEditingPostCommand];
    self.deletePostCommand = [self createDeletePostCommand];
    self.backCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseDetailedPostVC];
	self.likesListCommand = [self createLikesListCommand];
    
    @weakify(self);
    [[RACObserve(self, post) ignore:nil] subscribeNext:^(PMPost *post) {
        @strongify(self);
        [self createViewModelWithPost:post];
    }];
}

- (RACSignal *)loadData
{
    @weakify(self);
    return [[self.postApiClient getPost:self.postIdx] doNext:^(PMPostResponse *response) {
        @strongify(self);
        self.post = response.post;
        [[self.commentsApiClient requestCommentsListForResourceType:PMEntityTypePost resourceIdx:self.postIdx page:0] subscribeNext:^(id x) {
            
        }];
    }];
}

- (void)setupComment:(NSString *)comment
{
    self.comment = comment;
}

#pragma mark - commands

- (RACCommand *)createLikedCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        @strongify(self);
        PMDetailedPostPageViewModelImpl *viewModel = self.viewModel;

        if (viewModel.likedByMe) {
            return  [[self.likeApiClient removeLikeWithIdx:self.postIdx entityType:PMEntityTypePost] doNext:^(id x) {
                @strongify(self);
                PMDetailedPostPageViewModelImpl *viewModel = self.viewModel;
                viewModel.likedByMe = NO;
                viewModel.likesCount = viewModel.likesCount - 1;
            }];
        }
        else {
            return [[self.likeApiClient createLikeWithIdx:self.postIdx entityType:PMEntityTypePost] doNext:^(id x) {
                @strongify(self);
                PMDetailedPostPageViewModelImpl *viewModel = self.viewModel;
                viewModel.likedByMe = YES;
                viewModel.likesCount = viewModel.likesCount + 1;
            }];
        }
    }];
}

- (RACCommand *)createToEditingPostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSubject *subject = [RACSubject subject];
        [subject subscribeNext:^(PMPost *post) {
            @strongify(self);
            self.post = post;
        }];
        PMDetailedPostContext *context  =[PMDetailedPostContext contextWithPost:self.post subject:subject];
        [self performSegueWithIdentifier:kPMSegueIdentifierToEditPostVC context:context];
        return  [RACSignal empty];
    }];
}

- (RACCommand *)createDeletePostCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[self.postApiClient removePost:self.postIdx] doNext:^(id x) {
            [self performSegueWithIdentifier:kPMSegueIdentifierCloseDetailedPostVC];
        }];
    }];
}

- (RACCommand *)createLikesListCommand
{
	return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self performSegueWithIdentifier:kPMSegueIdentifierToDetailedLkesVCFromDetailedPostVC context:[PMDetailedLikesContext contextWithIdx:self.postIdx andType:PMEntityTypePost]];
		return  [RACSignal empty];
	}];
}

#pragma mark - private

- (void)createViewModelWithPost:(PMPost *)post
{
    BOOL isMine = [post.dreamer.idx isEqualToNumber:self.userProvider.me.idx];
    self.viewModel = [[PMDetailedPostPageViewModelImpl alloc] initWithPost:post isMine:isMine];
    [self imageDownloaderWithPost:post];
}

- (void)imageDownloaderWithPost:(PMPost *)post
{
    @weakify(self);
    NSURL *imageUrl = [NSURL URLWithString:post.photos.firstObject.photo.large];
    if (imageUrl) {
        [[self.imageDownloader imageForURL:imageUrl] subscribeNext:^(UIImage *image) {
            @strongify(self);
            PMDetailedPostPageViewModelImpl *viewModel = self.viewModel;
            viewModel.photo = image;
        }];
    }
    
    NSURL *avatarUrl = [NSURL URLWithString:post.dreamer.avatar.medium];
    if (avatarUrl) {
        @strongify(self);
        [[self.imageDownloader imageForURL:avatarUrl] subscribeNext:^(UIImage *avatar) {
            PMDetailedPostPageViewModelImpl *viewModel = self.viewModel;
            viewModel.avatar = avatar;
        }];
    }
}

@end
