//
//  PMEditDreamLogic.h
//  myDreams
//
//  Created by AlbertA on 25/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"

@protocol PMDreamApiClient;
@protocol PMEditDreamViewModel;
@protocol PMImageDownloader;

extern NSString * const PMEditDreamLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMEditDreamLogicError) {
    PMEditDreamLogicErrorInvalidInput = 3,
};

@interface PMEditDreamLogic : PMBaseLogic
@property (strong, nonatomic) id<PMDreamApiClient> dreamApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *saveDreamCommand;
@property (nonatomic, strong, readonly) id<PMEditDreamViewModel> viewModel;

- (void)setupPhoto:(UIImage *)photo cropRect:(CGRect)cropRect;
- (void)setupDreamDescription:(NSString *)dreamDescription;
- (void)setupDreamTitle:(NSString *)dreamTitle;
@end
