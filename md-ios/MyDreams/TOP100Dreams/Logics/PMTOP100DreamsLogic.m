//
//  PMTOP100DreamsLogic.m
//  myDreams
//
//  Created by AlbertA on 22/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMTOP100DreamsLogic.h"
#import "PMDreamsViewModelImpl.h"
#import "PMDreamApiClient.h"
#import "PMImageDownloader.h"
#import "PMTopDreamsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMDreamViewModelImpl.h"
#import "PMTopDream.h"
#import "PMImage.h"
#import "PMLikeApiClient.h"
#import "PMPaginationBaseLogic+Protected.h"

NSString * const PMTOP100DreamsLogicErrorDomain = @"com.mydreams.TOP100Dreams.logic.error";

@interface PMTOP100DreamsLogic ()
@property (strong, nonatomic) PMDreamsViewModelImpl *dreamsViewModel;
@end

@implementation PMTOP100DreamsLogic

- (void)startLogic
{
    @weakify(self);
    
    self.dreamsViewModel = [[PMDreamsViewModelImpl alloc] init];
    self.dreamsViewModel.dreams = @[];
    
    RAC(self.dreamsViewModel, dreams) = [RACObserve(self, items)
        map:^id(NSArray *items) {
            @strongify(self);
            return [self dreamsToViewModels:items];
    }];
    
    [super startLogic];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    return [[self.dreamApiClient getTopDreams:page] map:^RACTuple *(PMTopDreamsResponse *response) {
        return RACTuplePack(response.dreams, response.meta);
    }];
}

#pragma mark - private

- (NSArray *)dreamsToViewModels:(NSArray *)dreams
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:dreams.count];
    for (int i = 0; i < dreams.count; i++) {
        PMTopDream *dream = dreams[i];
        PMDreamViewModelImpl *viewModel = [[PMDreamViewModelImpl alloc] initWithTopDream:dream];
        viewModel.position = i + 1;
        NSURL *imageUrl = [NSURL URLWithString:dream.image.large];
        if (imageUrl) {
            viewModel.imageSignal = [self.imageDownloader imageForURL:imageUrl];
        }
        
        @weakify(self);
        
        viewModel.likedSignal = [[self.likeApiClient createLikeWithIdx:dream.idx entityType:PMEntityTypeTopDream] doNext:^(id x) {
            @strongify(self);
            dream.likedByMe = YES;
            dream.likesCount = dream.likesCount + 1;
            [self updateItem:dream];
        }];
        
        viewModel.removeLikeSignal = [[self.likeApiClient removeLikeWithIdx:dream.idx entityType:PMEntityTypeTopDream] doNext:^(id x) {
            @strongify(self);
            dream.likedByMe = NO;
            dream.likesCount = dream.likesCount - 1;
            [self updateItem:dream];
        }];
        
        [viewModels addObject:viewModel];
    }
    
    return [NSArray arrayWithArray:viewModels];
}

@end
