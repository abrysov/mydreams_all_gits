//
//  PMCreatePostLogic.h
//  myDreams
//
//  Created by AlbertA on 28/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMCreatePostViewModel.h"

@protocol PMPostApiClient;

extern NSString * const PMCreatePostLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMCreatePostLogicError) {
    PMCreatePostLogicErrorInvalidInput = 3,
};

@interface PMCreatePostLogic : PMBaseLogic
@property (strong, nonatomic) id<PMPostApiClient> postApiClient;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *sendPostCommand;
@property (nonatomic, strong, readonly) id<PMCreatePostViewModel> viewModel;
@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, strong) UIImage *photo;
@end
