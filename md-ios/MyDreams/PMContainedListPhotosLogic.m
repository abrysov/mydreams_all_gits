//
//  PMListPhotosLogic.m
//  MyDreams
//
//  Created by user on 06.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMContainedListPhotosLogic.h"
#import "PMDreamerApiClient.h"
#import "PMContainedListPhotosViewModelImpl.h"
#import "PMPhotosResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMBaseLogic+Protected.h"
#import "PMPhotoMapper.h"
#import "PMPhotoViewModelImpl.h"
#import "ObjectiveSugar.h"
#import "PMPaginationBaseLogic+Protected.h"
#import "PMProfileApiClient.h"
#import "PMBaseResponse.h"
#import "PMPhoto.h"

NSString * const PMContainedListPhotosLogicErrorDomain = @"com.mydreams.ContainedListPhotos.logic.error";

@interface PMContainedListPhotosLogic ()
@property (strong, nonatomic) PMContainedListPhotosViewModelImpl *viewModel;
@property (strong, nonatomic) NSNumber *dreamerIdx;
@property (assign, nonatomic) BOOL isMe;
@property (strong, nonatomic) RACCommand *deletePhotoAtIndexCommand;
@end

@implementation PMContainedListPhotosLogic

- (void)startLogic
{
    self.ignoreDataEmpty = YES;
    self.viewModel = [[PMContainedListPhotosViewModelImpl alloc] init];
    [super startLogic];
    
    @weakify(self);
    RAC(self.viewModel, photos) = [RACObserve(self, items)
        map:^id(NSArray<PMPhoto *> *items) {
            @strongify(self);
            return [self.photoMapper photosToViewModels:items];
        }];
    
    RAC(self.viewModel, isMe) = RACObserve(self, isMe);
    
    self.deletePhotoAtIndexCommand = [self createDeletePhotoAtIndexCommand];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    return [[self.dreamerApiClient getPhotos:self.dreamerIdx page:page]
        map:^RACTuple *(PMPhotosResponse *response) {
            return RACTuplePack(response.photos, response.meta);
        }];
}

- (RACCommand *)createLoadDataCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[self loadData]
            doError:^(NSError *error) {
                @strongify(self);
                self.isDataLoaded = NO;
            }]
            doCompleted:^{
                @strongify(self);
                self.isDataLoaded = YES;
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

- (void)setupDreamerIdx:(NSNumber *)dreamerIdx isMe:(BOOL)isMe
{
    self.dreamerIdx = dreamerIdx;
    self.isMe = isMe;
}

@end
