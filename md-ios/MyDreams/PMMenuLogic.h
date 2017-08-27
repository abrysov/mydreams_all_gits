//
//  PMMenuLogic.h
//  MyDreams
//
//  Created by Иван Ушаков on 22.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMMenuItem.h"

@protocol PMUserProvider;
@protocol PMImageDownloader;
@protocol PMMenuViewModel;
@protocol PMProfileApiClient;
@protocol PMApplicationRouter;

@interface PMMenuLogic : PMBaseLogic
@property (nonatomic, strong) id<PMProfileApiClient> profileApiClient;
@property (strong, nonatomic) id<PMUserProvider> userProvider;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (strong, nonatomic) id<PMApplicationRouter> router;

@property (assign, nonatomic, readonly) PMMenuItem selectedMenuItem;
@property (strong, nonatomic, readonly) RACCommand *loadProfileCommand;
@property (strong, nonatomic, readonly) id<PMMenuViewModel> viewModel;

- (void)openMenuItem:(PMMenuItem)menuItem;

@end
