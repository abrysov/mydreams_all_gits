//
//  PMDetailedDreamLogic.h
//  MyDreams
//
//  Created by user on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMDetailedDreamViewModel.h"

@protocol PMUserProvider;
@protocol PMImageDownloader;
@protocol PMLikeApiClient;
@protocol PMDreamApiClient;


extern NSString * const PMDetailedDreamLogicErrorDomain;

@interface PMDetailedDreamLogic : PMBaseLogic
@property (nonatomic, strong) id<PMDreamApiClient> dreamApiClient;
@property (strong, nonatomic) id<PMUserProvider> userProvider;
@property (nonatomic, strong) id<PMImageDownloader> imageDownloader;
@property (strong, nonatomic) id<PMLikeApiClient> likeApiClient;
@property (nonatomic, strong, readonly) id<PMDetailedDreamViewModel> viewModel;
@property (nonatomic, strong, readonly) RACCommand *likedCommand;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *toEditingDreamCommand;
@property (nonatomic, strong, readonly) RACCommand *deleteDreamCommand;
- (void)setupComment:(NSString *)comment;
@end
