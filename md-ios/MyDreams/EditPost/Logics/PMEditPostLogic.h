//
//  PMEditPostLogic.h
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"

@protocol PMPostApiClient;
@protocol PMImageDownloader;
@protocol PMEditPostViewModel;

extern NSString * const PMEditPostLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMEditPostLogicError) {
    PMEditPostLogicErrorInvalidInput = 3,
};

@interface PMEditPostLogic : PMBaseLogic
@property (strong, nonatomic) id<PMPostApiClient> postApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *saveDreamCommand;
@property (nonatomic, strong, readonly) id<PMEditPostViewModel> viewModel;

- (void)setupPhoto:(UIImage *)photo;
- (void)setupContent:(NSString *)content;
@end
