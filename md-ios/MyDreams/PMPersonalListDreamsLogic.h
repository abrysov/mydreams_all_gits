//
//  PMPersonalListDreamsLogic.h
//  MyDreams
//
//  Created by Anatoliy Peshkov on 29/06/2016.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMDreamApiClient;
@protocol PMDreamsViewModel;
@protocol PMDreamMapper;

@interface PMPersonalListDreamsLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMDreamApiClient> dreamApiClient;
@property (strong, nonatomic) id<PMDreamMapper> dreamMapper;

@property (copy,   nonatomic, readonly) NSString *localizedTitleKey;
@property (strong, nonatomic, readonly) id<PMDreamsViewModel> dreamsViewModel;
@property (strong, nonatomic, readonly) RACCommand *toFullDreamCommand;
@property (strong, nonatomic, readonly) RACChannelTerminal *searchTerminal;
@end
