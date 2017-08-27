//
//  PMRegistrationStep3Logic.m
//  MyDreams
//
//  Created by user on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationStep3Logic.h"
#import "AuthentificationSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMUserContext.h"
#import "PMNetworkError.h"
#import "PMResponseMeta.h"
#import "PMDreamerResponse.h"

@interface PMRegistrationStep3Logic ()
@property (nonatomic, strong) PMUserContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *showSelectionLocationCommand;
@property (nonatomic, strong) RACCommand *completeRegistrationCommand;
@property (nonatomic, strong) RACCommand *toUserAgreementCommand;
@property (nonatomic, strong) RACChannelTerminal *phoneNumberTerminal;
@property (nonatomic, strong) PMRegistrationStep3ViewModelImpl *viewModel;
@end

@implementation PMRegistrationStep3Logic
@dynamic context;

- (void)startLogic
{
    [super startLogic];

    self.backCommand = [self createBackCommand];
    self.showSelectionLocationCommand = [self createShowSelectionLocationCommand];
    self.completeRegistrationCommand = [self createCompleteRegistrationCommand];
    self.toUserAgreementCommand = [self createToUserAgreementCommand];
    self.phoneNumberTerminal = RACChannelTo(self.context.userForm, phoneNumber);
    
    RAC(self, viewModel) = [[[RACObserve(self, context)
        ignore:nil]
        distinctUntilChanged]
        map:^id<PMRegistrationStep3ViewModel>(PMUserContext *context) {
            return [[PMRegistrationStep3ViewModelImpl alloc] initWithUserForm:context.userForm errorSubject:context.errorsSubject];
        }];
}

- (void)setAvatarForm:(PMImageForm *)avatar
{
    self.context.userForm.avatarForm = avatar;
}

#pragma mark - private

- (RACCommand *)createToUserAgreementCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToUserAgreement];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseRegistrationStep3VC context:self.context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createShowSelectionLocationCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToRegistrationSelectionLocationVC context:self.context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createCompleteRegistrationCommand
{
    @weakify(self);
    [self validate];
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToRegistrationProgressVC context:self.context];
        return [RACSignal empty];
    }];
}

#pragma mark - validation

- (void)validate{}

- (BOOL)isValidInput
{
    return self.context.userForm.isValidPhoneNumber;
}

@end
