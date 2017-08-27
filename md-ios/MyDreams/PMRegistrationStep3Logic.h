//
//  PMRegistrationStep3Logic.h
//  MyDreams
//
//  Created by user on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMRegistrationStep3ViewModelImpl.h"

@class PMImageForm;

@interface PMRegistrationStep3Logic : PMBaseLogic
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *showSelectionLocationCommand;
@property (nonatomic, strong, readonly) RACCommand *completeRegistrationCommand;
@property (nonatomic, strong, readonly) RACCommand *toUserAgreementCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *phoneNumberTerminal;
@property (nonatomic, strong, readonly) id<PMRegistrationStep3ViewModel> viewModel;

- (void)setAvatarForm:(PMImageForm *)avatar;
@end
