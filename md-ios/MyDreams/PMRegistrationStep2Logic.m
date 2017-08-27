//
//  PMRegistrationStep2Logic.m
//  MyDreams
//
//  Created by user on 16.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationStep2Logic.h"
#import "AuthentificationSegues.h"
#import "PMBaseLogic+Protected.h"

@interface PMRegistrationStep2Logic ()
@property (nonatomic, strong) PMUserContext *context;
@property (nonatomic, strong) PMRegistrationStep2ViewModelImpl *viewModel;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *nextStepCommand;
@property (nonatomic, strong) RACCommand *selectedMaleCommand;
@property (nonatomic, strong) RACCommand *selectedFemaleCommand;
@property (nonatomic, strong) RACCommand *receiveBirthDayCommand;
@property (nonatomic, strong) RACChannelTerminal *firstNameTerminal;
@property (nonatomic, strong) RACChannelTerminal *secondNameTerminal;
@end

@implementation PMRegistrationStep2Logic
@dynamic context;

- (void)startLogic
{
    [super startLogic];
        
    self.backCommand = [self createBackCommand];
    self.nextStepCommand = [self createNextStepCommand];
    self.selectedMaleCommand = [self createSelectedMaleCommand];
    self.selectedFemaleCommand = [self createSelectedFemaleCommand];
    self.receiveBirthDayCommand = [self createReceiveBirthDayCommand];
    
    self.firstNameTerminal = RACChannelTo(self.context.userForm, firstName);
    self.secondNameTerminal = RACChannelTo(self.context.userForm, secondName);

    RAC(self, viewModel) = [[[RACObserve(self, context)
        ignore:nil]
        distinctUntilChanged]
        map:^id<PMRegistrationStep2ViewModel>(PMUserContext *context) {
            return [[PMRegistrationStep2ViewModelImpl alloc] initWithUserForm:context.userForm];
        }];
}

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseRegistrationStep2VC context:self.context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createNextStepCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validate];
        if (self.isValidInput) {
            [self performSegueWithIdentifier:kPMSegueIdentifierToRegistrationStep3VC context:self.context];
        }
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSelectedMaleCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.context.userForm.sex = PMDreamerGenderMale;
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSelectedFemaleCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.context.userForm.sex = PMDreamerGenderFemale;
        return [RACSignal empty];
    }];
}

- (RACCommand *)createReceiveBirthDayCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(NSDate *birthday) {
        @strongify(self);
        self.context.userForm.birthday = birthday;
        return [RACSignal empty];
    }];
}

#pragma mark - validation

- (void)validate
{
    [self.context.userForm validateFirstName];
    [self.context.userForm validateGender];
}

- (BOOL)isValidInput
{
    return self.context.userForm.isValidFirstName &&
    self.context.userForm.isValidSecondName &&
    self.context.userForm.isValidBirthDay &&
    self.context.userForm.isValidGender;
}

@end
