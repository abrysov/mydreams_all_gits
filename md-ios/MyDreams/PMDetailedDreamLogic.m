//
//  PMDetailedDreamLogic.m
//  MyDreams
//
//  Created by user on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedDreamLogic.h"
#import "PMDreamApiClient.h"
#import "PMBaseModelIdxContext.h"
#import "PMDetailedDreamContext.h"
#import "PMDetailedDreamViewModelImpl.h"
#import "DreambookSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMDreamResponse.h"
#import "PMLikeApiClient.h"
#import "PMImage.h"
#import "PMImageDownloader.h"
#import "PMDreamer.h"
#import "PMUserProvider.h"

NSString * const PMDetailedDreamLogicErrorDomain = @"com.mydreams.DetailedDream.logic.error";

@interface PMDetailedDreamLogic ()
@property (strong, nonatomic) PMBaseModelIdxContext *context;
@property (strong, nonatomic) PMDetailedDreamViewModelImpl *viewModel;
@property (nonatomic, strong) RACCommand *likedCommand;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *toEditingDreamCommand;
@property (nonatomic, strong) RACCommand *deleteDreamCommand;
@property (strong, nonatomic) PMDream *dream;
@property (strong, nonatomic) NSNumber *dreamIdx;
@property (strong, nonatomic) NSNumber *isMine;
@property (strong, nonatomic) NSString *comment;
@end

@implementation PMDetailedDreamLogic
@dynamic context;

- (void)startLogic
{
    self.dreamIdx = self.context.idx;
    [super startLogic];

    @weakify(self);
    [[RACObserve(self, dream) ignore:nil] subscribeNext:^(PMDream *dream) {
        @strongify(self);
        [self createViewModelWithDream:dream];
    }];
    
    self.likedCommand = [self createLikedCommand];
    self.toEditingDreamCommand = [self createToEditingDreamCommand];
    self.deleteDreamCommand = [self createDeleteDreamCommand];
    self.backCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseDetailedDreamVC];
}

- (RACSignal *)loadData
{
    @weakify(self);
    return [[self.dreamApiClient getDream:self.dreamIdx] doNext:^(PMDreamResponse *response) {
        @strongify(self);
        self.dream = response.dream;
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
        PMDetailedDreamViewModelImpl *viewModel = self.viewModel;
        
        if (viewModel.likedByMe) {
            return  [[self.likeApiClient removeLikeWithIdx:self.dreamIdx entityType:PMEntityTypeDream] doNext:^(id x) {
                @strongify(self);
                PMDetailedDreamViewModelImpl *viewModel = self.viewModel;
                viewModel.likedByMe = NO;
                viewModel.likesCount = viewModel.likesCount - 1;
            }];
        }
        else {
            return [[self.likeApiClient createLikeWithIdx:self.dreamIdx entityType:PMEntityTypeDream] doNext:^(id x) {
                @strongify(self);
                PMDetailedDreamViewModelImpl *viewModel = self.viewModel;
                viewModel.likedByMe = YES;
                viewModel.likesCount = viewModel.likesCount + 1;
            }];
        }
    }];
}

- (RACCommand *)createToEditingDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSubject *subject = [RACSubject subject];
        @strongify(self);
        PMDetailedDreamContext *context = [PMDetailedDreamContext contextWithDream:self.dream subject:subject];
        [subject subscribeNext:^(PMDream *dream) {
            @strongify(self);
            self.dream = dream;
        }];
        [self performSegueWithIdentifier:kPMSegueIdentifierToEditDreamVC context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createDeleteDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self.dreamApiClient removeDream:self.dreamIdx] doNext:^(id x) {
            @strongify(self);
            [self performSegueWithIdentifier:kPMSegueIdentifierCloseDetailedDreamVC];
        }];
    }];
}

#pragma mark - private

- (void)createViewModelWithDream:(PMDream *)dream
{
    BOOL isMine = [dream.dreamer.idx isEqualToNumber:self.userProvider.me.idx];
    self.viewModel = [[PMDetailedDreamViewModelImpl alloc] initWithDream:dream isMine:isMine];
    [self imageDownloaderWithDream:dream];
}

- (void)imageDownloaderWithDream:(PMDream *)dream
{
    @weakify(self);
    NSURL *imageUrl = [NSURL URLWithString:dream.image.large];
    if (imageUrl) {
        [[self.imageDownloader imageForURL:imageUrl] subscribeNext:^(UIImage *image) {
            @strongify(self);
            PMDetailedDreamViewModelImpl *viewModel = self.viewModel;
            viewModel.photo = image;
        }];
    }
    
    NSURL *avatarUrl = [NSURL URLWithString:dream.dreamer.avatar.medium];
    if (avatarUrl) {
        @strongify(self);
        [[self.imageDownloader imageForURL:avatarUrl] subscribeNext:^(UIImage *avatar) {
            PMDetailedDreamViewModelImpl *viewModel = self.viewModel;
            viewModel.avatar = avatar;
        }];
    }
}

@end
