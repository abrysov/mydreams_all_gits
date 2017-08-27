//
//  PMEditProfileLogic.m
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditProfileLogic.h"
#import "PMEditProfileViewModelImpl.h"
#import "PMBaseLogic+Protected.h"
#import "SettingsSegues.h"
#import "PMProfileApiClient.h"
#import "PMDreamerResponse.h"
#import "PMImageDownloader.h"
#import "PMSettingsSegues.h"
#import "PMLocationContext.h"
#import "PMLocation.h"
#import "PMSettingsSegues.h"
#import "PMDreamerGender.h"

NSString * const PMEditProfileLogicErrorDomain = @"com.mydreams.EditProfile.logic.error";

@interface PMEditProfileLogic ()
@property (nonatomic, strong) PMDreamerForm *dreamerForm;
@property (nonatomic, strong) PMEditProfileViewModelImpl *viewModel;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *setBirthdayCommand;
@property (nonatomic, strong) RACCommand *sendCommand;
@property (nonatomic, strong) RACCommand *toSelectCountryCommand;
@property (nonatomic, strong) RACCommand *toSelectLocalityCommand;
@property (nonatomic, strong) RACCommand *selectGenderCommand;
@property (nonatomic, strong) RACChannelTerminal *firstNameTerminal;
@property (nonatomic, strong) RACChannelTerminal *secondNameTerminal;
@end

@implementation PMEditProfileLogic

- (void)startLogic
{
    [super startLogic];

    RACSignal *countryNotEmptySignal = [RACObserve(self, dreamerForm.country) map:^id(PMLocation *country) {
        return @(country != nil);
    }];
    
    self.firstNameTerminal = RACChannelTo(self, dreamerForm.firstName);
    self.secondNameTerminal = RACChannelTo(self, dreamerForm.secondName);
    
    @weakify(self);
    
    RAC(self, viewModel) = [[[RACObserve(self, dreamerForm)
        ignore:nil]
        distinctUntilChanged]
        map:^id<PMEditProfileViewModel>(PMDreamerForm *form) {
            return [[PMEditProfileViewModelImpl alloc] initWithDreamerForm:form];
        }];
    
    [RACObserve(self,viewModel) subscribeNext:^(PMEditProfileViewModelImpl *viewModel) {
        @strongify(self);
        NSURL *avatarUrl = [NSURL URLWithString:self.dreamerForm.avatarURL.medium];
        if (avatarUrl) {
            [[self.imageDownloader imageForURL:avatarUrl]
             subscribeNext:^(UIImage *avatar) {
                 viewModel.avatar = avatar;
             }];
        }
    }];
    self.backCommand = [self createBackCommand];
    self.setBirthdayCommand = [self createSetBirthDayCommand];
    self.sendCommand = [self createSendCommand];
    self.toSelectCountryCommand = [self createToSelectCountryCommand];
    self.toSelectLocalityCommand = [self createToSelectLocalityCommandWithEnabledSignal:countryNotEmptySignal];
    self.selectGenderCommand = [self createSelectGenderCommand];
}

- (RACSignal *)loadData
{
    @weakify(self);
    return [[self.profileApiClient getMe] doNext:^(PMDreamerResponse *x) {
        @strongify(self);
        self.dreamerForm = [[PMDreamerForm alloc] initWithDreamer:x.dreamer];
    }];
}

- (void)setAvatar:(UIImage *)avatar
{
    self.dreamerForm.avatar = avatar;
}

#pragma mark - commands

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseEditProfileVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSetBirthDayCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(NSDate *birthday) {
        @strongify(self);
        self.dreamerForm.birthday = birthday;
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSendCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validate];
        if ([self isValidInput]) {
            return [[self.profileApiClient editProfile:self.dreamerForm] doNext:^(id x) {
                [self performSegueWithIdentifier:kPMSegueIdentifierCloseEditProfileVC];
            }];
        }
        else {
            NSError *error = [NSError errorWithDomain:PMEditProfileLogicErrorDomain
                                                 code:PMEditProfileLogicErrorInvalidInput
                                             userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"error.invalidInput", nil)}];
            return [RACSignal error:error];
        }
    }];
}

- (RACCommand *)createToSelectCountryCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSubject *subject = [RACSubject subject];
        PMLocationContext *context = [PMLocationContext contextWithSubject:subject];
        [subject subscribeNext:^(PMLocation *x) {
            self.dreamerForm.country = x;
            self.dreamerForm.locality = nil;
        }];
        [self performSegueWithIdentifier:kPMSegueIdentifierSettingsToSelectCountryVCFromSettings context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createToSelectLocalityCommandWithEnabledSignal:(RACSignal *)signal
{
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:signal signalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSubject *subject = [RACSubject subject];
        PMLocationContext *context = [PMLocationContext contextWithSubject:subject];
        context.countryIdx = self.dreamerForm.country.idx;
        [subject subscribeNext:^(PMLocality *x) {
            @strongify(self);
            self.dreamerForm.locality = x;
        }];
        [self performSegueWithIdentifier:kPMSegueIdentifierSettingsToSelectLocalityVCFromSettings context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSelectGenderCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(NSNumber *genderNumber) {
        @strongify(self);
        PMDreamerGender gender = [genderNumber intValue];
        self.dreamerForm.sex = gender;
        return [RACSignal empty];
    }];
}

#pragma mark - validation

- (void)validate
{
    [self.dreamerForm validateFirstName];
}

- (BOOL)isValidInput
{
    return self.dreamerForm.isValidFirstName &&
    self.dreamerForm.isValidSecondName;
}
@end
