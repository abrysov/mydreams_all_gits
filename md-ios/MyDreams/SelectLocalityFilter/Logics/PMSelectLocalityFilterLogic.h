//
//  PMSelectLocalityFilterLogic.h
//  myDreams
//
//  Created by AlbertA on 11/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMLocationService.h"
#import "PMLocalitiesViewModel.h"

extern NSString * const PMSelectLocalityFilterLogicErrorDomain;

@interface PMSelectLocalityFilterLogic : PMBaseLogic
@property (nonatomic, strong) id<PMLocationService> locationService;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong) id<PMLocalitiesViewModel> localitiesViewModel;
- (void)selectLocalityWithIndex:(NSInteger)index;
@end

