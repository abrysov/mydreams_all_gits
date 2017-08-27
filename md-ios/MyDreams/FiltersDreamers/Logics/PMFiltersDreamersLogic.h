//
//  PMFiltersDreamersLogic.h
//  myDreams
//
//  Created by AlbertA on 04/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMFiltersDreamersViewModel.h"

@protocol PMDreamerApiClient;

extern NSString * const PMFiltersDreamersLogicErrorDomain;

@interface PMFiltersDreamersLogic : PMBaseLogic
@property (strong, nonatomic) id<PMDreamerApiClient> dreamerApiClient;
@property (nonatomic, strong, readonly) id<PMFiltersDreamersViewModel> viewModel;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *toSelectCountryCommand;
@property (nonatomic, strong, readonly) RACCommand *toSelectLocalityCommand;
@property (nonatomic, strong, readonly) RACCommand *resetFiltersCommand;
@property (nonatomic, strong, readonly) RACCommand *changeAllOptionCommand;
@property (nonatomic, strong, readonly) RACCommand *changeNewOptionCommand;
@property (nonatomic, strong, readonly) RACCommand *changeTopOptionCommand;
@property (nonatomic, strong, readonly) RACCommand *changeVipOptionCommand;
@property (nonatomic, strong, readonly) RACCommand *changeOnlineOptionCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *fromAgeTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *toAgeTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *selectGenderTerminal;
@end
