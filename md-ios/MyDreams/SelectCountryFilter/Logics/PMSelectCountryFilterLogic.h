//
//  PMSelectCountryFilterLogic.h
//  myDreams
//
//  Created by AlbertA on 11/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMLocationService.h"
#import "PMCountriesViewModelImpl.h"

extern NSString * const PMSelectCountryFilterLogicErrorDomain;

@interface PMSelectCountryFilterLogic : PMBaseLogic
@property (strong, nonatomic) id<PMLocationService> locationService;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong) id<PMCountriesViewModel> countriesViewModel;

- (void)selectCountryWithIndex:(NSInteger)index;
@end
