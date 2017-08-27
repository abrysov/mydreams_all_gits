//
//  PMRegistrationSelectionLocationLogic.h
//  MyDreams
//
//  Created by user on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMLocationService.h"
#import "PMCountriesViewModelImpl.h"

@interface PMSelectCountryLogic : PMBaseLogic
@property (strong, nonatomic) id<PMLocationService> locationService;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong) id<PMCountriesViewModel> countriesViewModel;
- (void)selectCountryWithIndex:(NSInteger)index;
@end
