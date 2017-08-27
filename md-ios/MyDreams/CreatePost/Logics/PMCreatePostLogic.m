//
//  PMCreatePostLogic.m
//  myDreams
//
//  Created by AlbertA on 28/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCreatePostLogic.h"
#import "PMPostApiClient.h"
#import "PMPostForm.h"
#import "PMCreatePostViewModelImpl.h"
#import "PMPostPhotoResponse.h"
#import "PMPostResponse.h"
#import "DreambookSegues.h"
#import "PMSubjectContext.h"
#import "PMBaseLogic+Protected.h"

NSString * const PMCreatePostLogicErrorDomain = @"com.mydreams.CreatePost.logic.error";

@interface PMCreatePostLogic ()
@property (nonatomic, strong) PMSubjectContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *sendPostCommand;
@property (nonatomic, strong) PMPostForm *form;
@property (nonatomic, strong) PMCreatePostViewModelImpl *viewModel;
@property (nonatomic, strong) RACSubject *progressSubject;
@end

@implementation PMCreatePostLogic
@dynamic context;

- (void)startLogic
{
    self.form = [[PMPostForm alloc] init];
    self.viewModel = [[PMCreatePostViewModelImpl alloc] init];
    [super startLogic];
    
    @weakify(self);
    self.backCommand = [self createBackCommand];
    self.sendPostCommand = [self createSendPostCommand];
    self.progressSubject = [RACSubject subject];
    [self.progressSubject subscribeNext:^(NSProgress *progress) {
        @strongify(self);
        PMCreatePostViewModelImpl *viewModel = self.viewModel;
        viewModel.progress = (float)progress.completedUnitCount / progress.totalUnitCount / 2;
    }];
}

- (void)setPostDescription:(NSString *)postDescription
{
    self.form.content = postDescription;
}

- (void)setPhoto:(UIImage *)photo
{
    if (self->_photo != photo) {
        self->_photo = photo;
        PMCreatePostViewModelImpl *viewModel = self.viewModel;
        viewModel.photo = photo;
    }
}

#pragma mark - private
- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseCreatePostVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSendPostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if ([self.form isValidDescription] && self.photo) {
            return [[self.postApiClient postPhotos:self.photo idx:nil progress:self.progressSubject]
                flattenMap:^RACStream *(PMPostPhotoResponse *response) {
                    NSArray *array = @[response.postPhoto.idx];
                    @strongify(self);
                    self.form.postPhotosIdxs = array;
                    PMCreatePostViewModelImpl *viewModel = self.viewModel;
                    viewModel.progress = 1.0f;
                    return [[self.postApiClient createPost:self.form] doNext:^(PMPostResponse *postResponse) {
                        @strongify(self);
                        [self.context.subject sendNext:postResponse.post];
                        [self performSegueWithIdentifier:kPMSegueIdentifierCloseCreatePostVC];
                    }];
                }];
        }
        NSError *error = [NSError errorWithDomain:PMCreatePostLogicErrorDomain
                                             code:PMCreatePostLogicErrorInvalidInput
                                         userInfo:@{NSLocalizedDescriptionKey:[self errorMessage]}];
        return [RACSignal error:error];
    }];
}

- (NSString *)errorMessage
{
    if (!self.photo) {
        return NSLocalizedString(@"dreambook.create_post.invalid_photo", nil);
    }
    if (!self.form.isValidDescription) {
        return NSLocalizedString(@"dreambook.create_post.invalid_description", nil);
    }
    return NSLocalizedString(@"error.invalidInput", nil);
}

@end
