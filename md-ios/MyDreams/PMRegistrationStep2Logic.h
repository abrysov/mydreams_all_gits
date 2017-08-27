//
//  PMRegistrationStep2Logic.h
//  MyDreams
//
//  Created by user on 16.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMUserContext.h"
#import "PMRegistrationStep2ViewModelImpl.h"

@interface PMRegistrationStep2Logic : PMBaseLogic
@property (nonatomic, strong, readonly) id<PMRegistrationStep2ViewModel> viewModel;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *nextStepCommand;
@property (nonatomic, strong, readonly) RACCommand *selectedMaleCommand;
@property (nonatomic, strong, readonly) RACCommand *selectedFemaleCommand;
@property (nonatomic, strong, readonly) RACCommand *receiveBirthDayCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *firstNameTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *secondNameTerminal;
@end
