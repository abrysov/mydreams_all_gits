//
//  PMMenuLogic.m
//  MyDreams
//
//  Created by Иван Ушаков on 22.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMMenuLogic.h"
#import "MenuSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMUserProvider.h"
#import "PMDreamer.h"
#import "PMMenuViewModelImpl.h"
#import "PMImageDownloader.h"
#import "PMDreamerResponse.h"
#import "PMProfileApiClient.h"
#import "PMApplicationRouter.h"

@interface PMMenuLogic ()
@property (assign, nonatomic) PMMenuItem selectedMenuItem;
@property (strong, nonatomic) RACCommand *loadProfileCommand;
@property (strong, nonatomic) PMMenuViewModelImpl *viewModel;
@end

@implementation PMMenuLogic

- (void)startLogic
{
    [super startLogic];
        
    self.viewModel = [[PMMenuViewModelImpl alloc] init];
    
    @weakify(self);
    
    [RACObserve(self.userProvider, me) subscribeNext:^(PMDreamer *dreamer) {
        @strongify(self);
        PMMenuViewModelImpl *viewModel = self.viewModel;
        
        viewModel.me = dreamer;
        
        NSURL *avatarUrl = [NSURL URLWithString:dreamer.avatar.medium];
        if (avatarUrl) {
            [[self.imageDownloader imageForURL:avatarUrl]
                subscribeNext:^(UIImage *avatar) {
                    viewModel.avatar = avatar;
                }];
        }
    }];
    
    RAC(self, selectedMenuItem) = RACObserve(self.router, selectedMenuItem);
    
    [RACObserve(self.userProvider, status) subscribeNext:^(PMStatus *status) {
        @strongify(self);
        PMMenuViewModelImpl *viewModel = self.viewModel;
        viewModel.status = status;
    }];
    
    self.loadProfileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self.profileApiClient getMe]
            doNext:^(PMDreamerResponse *response) {
                @strongify(self);
                [self.userProvider setMe:response.dreamer];
            }];
    }];
    
}

- (void)openMenuItem:(PMMenuItem)menuItem
{
    [self.router openMenuItem:menuItem];
}

@end
