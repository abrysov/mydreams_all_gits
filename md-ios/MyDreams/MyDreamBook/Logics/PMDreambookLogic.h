//
//  PMMyDreamBookLogic.h
//  myDreams
//
//  Created by Ivan Ushakov on 17/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMDreambookHeaderViewModel.h"
#import "PMDreambookViewModel.h"

@protocol PMProfileApiClient;
@protocol PMDreamerApiClient;
@protocol PMFriendsApiClient;
@protocol PMPostApiClient;
@protocol PMUserProvider;
@protocol PMImageDownloader;
@protocol PMApplicationRouter;
@protocol PMPostMapper;

typedef NS_ENUM(NSUInteger, PMDreambookLogicError) {
    PMDreambookLogicErrorInvalidInput = 3,
};

extern NSString * const PMDreambookLogicErrorDomain;

@interface PMDreambookLogic : PMPaginationBaseLogic
@property (nonatomic, strong) id<PMProfileApiClient> profileApiClient;
@property (nonatomic, strong) id<PMDreamerApiClient> dreamerApiClient;
@property (nonatomic, strong) id<PMFriendsApiClient> friendsApiClient;
@property (nonatomic, strong) id<PMPostApiClient> postApiClient;
@property (strong, nonatomic) id<PMUserProvider> userProvider;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (strong, nonatomic) id<PMPostMapper> postMapper;
@property (weak, nonatomic) PMBaseLogic *containerLogic;
@property (strong, nonatomic) id<PMApplicationRouter> router;
@property (strong, nonatomic) NSURL *baseUrl;

@property (nonatomic, strong, readonly) id<PMDreambookHeaderViewModel> dreambookHeaderViewModel;
@property (nonatomic, strong, readonly) id<PMDreambookViewModel> viewModel;
@property (nonatomic, strong, readonly) RACCommand *changeAvatarCommand;
@property (nonatomic, strong, readonly) RACCommand *changeBackgroundCommand;
@property (nonatomic, strong, readonly) RACCommand *editCommand;
@property (nonatomic, strong, readonly) RACCommand *getMessageCommand;
@property (nonatomic, strong, readonly) RACCommand *addFriendCommand;
@property (nonatomic, strong, readonly) RACCommand *createPostCommand;
@property (nonatomic, strong, readonly) RACCommand *changeStatusCommand;
@property (nonatomic, strong, readonly) RACCommand *toSectionCommand;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *openInWebCommand;
@property (nonatomic, strong, readonly) RACCommand *toFullPostCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *statusTerminal;
@end
