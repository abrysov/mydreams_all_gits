//
//  PMEditPostLogic.m
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditPostLogic.h"
#import "PMDetailedPostContext.h"
#import "PMPostForm.h"
#import "PMEditPostViewModelImpl.h"
#import "PMBaseLogic+Protected.h"
#import "DreambookSegues.h"
#import "PMPostApiClient.h"
#import "PMPostPhoto.h"
#import "PMImage.h"
#import "PMImageDownloader.h"
#import "PMPostResponse.h"

NSString * const PMEditPostLogicErrorDomain = @"com.mydreams.EditPost.logic.error";

@interface PMEditPostLogic ()
@property (strong, nonatomic) PMDetailedPostContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *saveDreamCommand;
@property (nonatomic, strong) PMPostForm *postForm;
@property (nonatomic, strong) PMEditPostViewModelImpl *viewModel;
@property (nonatomic, strong) RACSubject *progressSubject;
@property (nonatomic, strong) UIImage *photo;
@end

@implementation PMEditPostLogic
@dynamic context;

- (void)startLogic
{
    self.postForm = [[PMPostForm alloc] initWithPost:self.context.post];
    [super startLogic];
    
    self.backCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseEditPostVC];
    self.saveDreamCommand = [self createSaveDreamCommand];
    
    RAC(self, viewModel) = [[RACObserve(self, postForm) ignore:nil]
        map:^id(PMPostForm *form) {
            return [[PMEditPostViewModelImpl alloc] initWithPostForm:form];
        }];
    
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(PMEditPostViewModelImpl *viewModel) {
        @strongify(self);
        if (self.postForm.postPhotos.count > 0) {
            PMPostPhoto *postPhoto = self.postForm.postPhotos.firstObject;
            NSURL *photoUrl = [NSURL URLWithString:postPhoto.photo.large];
            if (photoUrl) {
                [[self.imageDownloader imageForURL:photoUrl]
                    subscribeNext:^(UIImage *photo) {
                        viewModel.photo = photo;
                    }];
            }
        }
    }];

    self.progressSubject = [RACSubject subject];
    [self.progressSubject subscribeNext:^(NSProgress *progress) {
        @strongify(self);
        PMEditPostViewModelImpl *viewModel = self.viewModel;
        viewModel.progress = 0.33f + ((float)progress.completedUnitCount / progress.totalUnitCount / 3) ;
    }];
}

- (void)setupContent:(NSString *)content
{
    self.postForm.content = content;
}

- (void)setupPhoto:(UIImage *)photo
{
    self.photo = photo;
    PMEditPostViewModelImpl *viewModel = self.viewModel;
    viewModel.photo = photo;
}

#pragma mark - commands

- (RACCommand *)createSaveDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (self.postForm.isValidDescription) {
            RACSignal *saveSignal = [RACSignal empty];
            if (self.photo) {
                saveSignal = [self postPhoto];
                if (self.postForm.postPhotos.count > 0) {
                    saveSignal = [self removePhotoAfter:saveSignal];
                }
            }
            
            saveSignal = [self updatePostAfter:saveSignal];
            
            return [saveSignal doNext:^(PMPostResponse *response) {
                @strongify(self);
                [self.context.postSubject sendNext:response.post];
                [self performSegueWithIdentifier:kPMSegueIdentifierCloseEditPostVC];
            }];
        }
        NSError *error = [NSError errorWithDomain:PMEditPostLogicErrorDomain
                                             code:PMEditPostLogicErrorInvalidInput
                                         userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"dreambook.create_post.invalid_description", nil)}];
        return [RACSignal error:error];
    }];
}

#pragma mark - private

- (RACSignal *)postPhoto
{
    PMEditPostViewModelImpl *viewModel = self.viewModel;
    viewModel.progress = 0.33f;
    return [self.postApiClient postPhotos:self.photo idx:self.postForm.postIdx progress:self.progressSubject];
}

- (RACSignal *)removePhotoAfter:(RACSignal *)signal
{
    @weakify(self);
    return [signal then:^RACSignal *{
        @strongify(self);
        PMEditPostViewModelImpl *viewModel = self.viewModel;
        viewModel.progress = 0.66f;
        PMPostPhoto *postPhoto = self.postForm.postPhotos.firstObject;
        return [self.postApiClient removePhotos:postPhoto.idx];
    }];
}

- (RACSignal *)updatePostAfter:(RACSignal *)signal
{
    @weakify(self);
    return [signal then:^RACSignal *{
        @strongify(self);
        PMEditPostViewModelImpl *viewModel = self.viewModel;
        viewModel.progress = 1.0f;
        return [self.postApiClient updatePost:self.postForm];
    }];
}

@end
