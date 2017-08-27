//
//  PMListFollowersLogic.m
//  MyDreams
//
//  Created by user on 24.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListFollowersLogic.h"
#import "PMFriendsApiClient.h"
#import "PMFollowersViewModelImpl.h"
#import "PMDreamerFilterForm.h"
#import "PMFollowersResponse.h"
#import "PMPaginationResponseMeta.h"
#import "DreambookSegues.h"
#import "PMBaseModelIdxContext.h"
#import "PMBaseLogic+Protected.h"
#import "PMDreamerMapper.h"

NSString * const PMListFollowersLogicErrorDomain = @"com.mydreams.ListFollowers.logic.error";

@interface PMListFollowersLogic ()
@property (nonatomic, strong) PMBaseModelIdxContext *context;
@property (strong, nonatomic) PMFollowersViewModelImpl *followersViewModel;
@property (nonatomic, strong) PMDreamerFilterForm *filterForm;
@property (strong, nonatomic) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic) RACCommand *backCommand;
@property (strong, nonatomic) RACCommand *toDreambookCommand;
@property (strong, nonatomic) RACSubject *cancelSignal;
@end

@implementation PMListFollowersLogic
@dynamic context;

- (void)startLogic
{
    self.filterForm = [[PMDreamerFilterForm alloc] init];
    
    [super startLogic];
    
    @weakify(self);
    self.backCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseListFollowersVC];
    self.toDreambookCommand = [self createToDreambookCommand];
    
    self.searchTerminal = RACChannelTo(self, filterForm.search);
    self.followersViewModel = [[PMFollowersViewModelImpl alloc] init];
    
    PMFollowersViewModelImpl *viewModel = self.followersViewModel;
    viewModel.dreamers = @[];
    self.cancelSignal = [RACSubject subject];
    
    RAC(self, followersViewModel.dreamers) = [RACObserve(self, items)
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
    return [[[self.friendsApiClient getFollowers:self.context.idx filterForm:self.filterForm page:page]
        doNext:^(PMFollowersResponse *response) {
            @strongify(self)
            PMFollowersViewModelImpl *viewModel = self.followersViewModel;
            viewModel.totalCount = response.meta.totalCount;
        }]
        map:^RACTuple *(PMFollowersResponse *response) {
            return RACTuplePack(response.followers, response.meta);
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
        [self performSegueWithIdentifier:kPMSegueIdentifierToDreambookVCFromListFollowersVC context:context];
        return [RACSignal empty];
    }];
}

@end
