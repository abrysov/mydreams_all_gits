//
//  PMFulfillDreamLogic.h
//  myDreams
//
//  Created by AlbertA on 18/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMFulfillDreamViewModel.h"

@protocol PMDreamApiClient;
@protocol PMApplicationRouter;

extern NSString * const PMFulfillDreamLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMFulfillDreamLogicError) {
    PMFulfillDreamLogicErrorInvalidInput = 3,
};

@interface PMFulfillDreamLogic : PMBaseLogic
@property (strong, nonatomic) id<PMDreamApiClient> dreamApiClient;
@property (strong, nonatomic) id<PMApplicationRouter> router;

@property (nonatomic, strong, readonly) RACCommand *sendDreamCommand;
@property (nonatomic, strong, readonly) RACCommand *changeRestrictionLevelCommand;
@property (nonatomic, strong, readonly) RACCommand *toDreambookCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *titleDreamTerminal;
@property (nonatomic, strong, readonly) id<PMFulfillDreamViewModel> viewModel;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *descriptionDream;
- (void)resetData;
@end
