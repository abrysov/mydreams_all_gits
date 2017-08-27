//
//  PMListPhotosLogic.m
//  myDreams
//
//  Created by Ivan Ushakov on 12/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListPhotosLogic.h"
#import "PMBaseModelIdxWithisMineContext.h"
#import "PMListPhotosViewModelImpl.h"
#import "PMDreamerApiClient.h"
#import "PMProfileApiClient.h"
#import "PMPhotosResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMPhotoResponse.h"
#import "PMPaginationBaseLogic+Protected.h"
#import "PMPhotoMapper.h"
#import "PMPhoto.h"
#import "PMBaseResponse.h"

NSString * const PMListPhotosLogicErrorDomain = @"com.mydreams.ListPhotos.logic.error";

@interface PMListPhotosLogic ()
@property (nonatomic, strong) PMBaseModelIdxWithIsMineContext *context;
@property (nonatomic, strong) PMListPhotosViewModelImpl *viewModel;
@property (nonatomic, strong) RACCommand *uploadPhotoCommand;
@property (nonatomic, strong) RACCommand *deletePhotoAtIndexCommand;
@property (nonatomic, strong) RACSubject *progressSubject;
@property (strong, nonatomic) NSArray<PMBaseModel *> *items;
@end

@implementation PMListPhotosLogic
@dynamic context;
@dynamic items;

- (void)startLogic
{
    self.viewModel = [[PMListPhotosViewModelImpl alloc] init];
    [super startLogic];
    
    @weakify(self);
    
    RAC(self.viewModel, photos) = [RACObserve(self, items)
        map:^id(NSArray<NSURL *> *items) {
            @strongify(self);
            return [self.photoMapper photosToViewModels:items];
        }];
    
    RAC(self.viewModel, isMe) = RACObserve(self.context, isMine);
    
    self.progressSubject = [RACSubject subject];
    [self.progressSubject subscribeNext:^(NSProgress *progress) {
        self.viewModel.progress = (float)progress.completedUnitCount / progress.totalUnitCount;
    }];
    
    self.uploadPhotoCommand = [self createUploadPhotoCommand];
    self.deletePhotoAtIndexCommand = [self createDeletePhotoAtIndexCommand];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    RACSignal *loadPhotosSignal = nil;
    
    if (self.context.isMine) {
        loadPhotosSignal = [self.profileApiClient getPhotosPage:page];
    }
    else {
        loadPhotosSignal = [self.dreamerApiClient getPhotos:self.context.idx page:page];
    }
    
    return [loadPhotosSignal
        map:^RACTuple *(PMPhotosResponse *response) {
            return RACTuplePack(response.photos, response.meta);
        }];
}

- (NSUInteger)perPage
{
    return 20;
}

#pragma mark - commands

- (RACCommand *)createUploadPhotoCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImage *photo) {
        @strongify(self);
        return [[self.profileApiClient createProfilePhoto:photo caption:nil progress:self.progressSubject] doNext:^(PMPhotoResponse *response) {
            @strongify(self);
            [self appendItem:response.photo atIndex:0];
        }];
    }];
}

- (RACCommand *)createDeletePhotoAtIndexCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *photoIndex) {
        @strongify(self);
        NSUInteger index = [photoIndex integerValue];
        PMPhoto *deletePhoto = (id)[self.items objectAtIndex:index];
        return [[self.profileApiClient destroyProfilePhoto:deletePhoto.idx] doNext:^(PMBaseResponse *response) {
            @strongify(self)
            [self removeItemAtIndex:index];
        }];
    }];
}
@end
