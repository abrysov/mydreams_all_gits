//
//  PMListFolloweesLogic.m
//  myDreams
//
//  Created by AlbertA on 29/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListFolloweesLogic.h"
#import "PMFriendsApiClient.h"
#import "PMFollowersViewModelImpl.h"
#import "PMDreamerFilterForm.h"
#import "PMFolloweesResponse.h"
#import "PMPaginationResponseMeta.h"
#import "DreambookSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMBaseModelIdxContext.h"
#import "PMDreamerMapper.h"

NSString * const PMListFolloweesLogicErrorDomain = @"com.mydreams.ListFollowees.logic.error";

@interface PMListFolloweesLogic ()
@property (strong, nonatomic) PMFollowersViewModelImpl *followeesViewModel;
@property (nonatomic, strong) PMDreamerFilterForm *filterForm;
@property (strong, nonatomic) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic) RACCommand *backCommand;
@property (strong, nonatomic) RACCommand *toDreambookCommand;
@property (strong, nonatomic) RACSubject *cancelSignal;
@end

@implementation PMListFolloweesLogic

- (void)startLogic
{
    self.filterForm = [[PMDreamerFilterForm alloc] init];
    [super startLogic];
    
    @weakify(self);
    self.backCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseListFolloweesVC];
    self.toDreambookCommand = [self createToDreambookCommand];
    
    self.searchTerminal = RACChannelTo(self, filterForm.search);
    self.followeesViewModel = [[PMFollowersViewModelImpl alloc] init];
    PMFollowersViewModelImpl *viewModel = self.followeesViewModel;
    viewModel.dreamers = @[];
    self.cancelSignal = [RACSubject subject];
    
    RAC(self, followeesViewModel.dreamers) = [RACObserve(self, items)
        map:^id(NSArray *items) {
            @strongify(self);
            return [self.dreamerMapper dreambookDreamersToViewModel:items];
        }];
    
    [[[[[[RACObserve(self, filterForm.search) skip:1]
        distinctUntilChanged]
        doNext:^(id x) {
            @strongify(self);
            [self.cancelSignal sendNext:x];
        }]
        map:^id(NSString *search) {
            @strongify(self);
            return [self.loadDataCommand execute:nil];
        }]
        switchToLatest]
        subscribeNext:^(id input) {}];
}


- (RACSignal *)loadPage:(PMPage *)page
{
    @weakify(self);
    return [[[self.friendsApiClient getFollowees:self.filterForm page:page]
        doNext:^(PMFolloweesResponse *response) {
            @strongify(self)
            PMFollowersViewModelImpl *viewModel = self.followeesViewModel;
            viewModel.totalCount = response.meta.totalCount;
        }]
        map:^RACTuple *(PMFolloweesResponse *response) {
            return RACTuplePack(response.dreamers, response.meta);
        }];
}

- (RACSignal *)loadData
{
    RACSignal *signal = [super loadData];
    return [signal takeUntil:self.cancelSignal];
}

- (NSUInteger)perPage
{
    return 15;
}

#pragma mark - private

- (RACCommand *)createToDreambookCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *index) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:index];
        [self performSegueWithIdentifier:kPMSegueIdentifierToDreambookVCFromListFolloweesVC context:context];
        return [RACSignal empty];
    }];
}


@end
