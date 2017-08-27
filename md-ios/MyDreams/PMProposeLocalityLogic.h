//
//  PMSentenceLocalityLogic.h
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMLocationService.h"
extern NSString * const PMProposeLocalityLogicErrorDomain;

@interface PMProposeLocalityLogic : PMBaseLogic
@property (nonatomic, strong) id<PMLocationService> locationService;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *sendLocalityCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *regionTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *destrictTerminal;
@end

