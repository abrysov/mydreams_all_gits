//
//  PMRegistrationProgressLogic.m
//  MyDreams
//
//  Created by Иван Ушаков on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationProgressLogic.h"
#import "AuthentificationSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMUserContext.h"
#import "PMAuthService.h"
#import "PMNetworkError.h"
#import "PMResponseMeta.h"
#import "PMDreamerResponse.h"
#import "PMUserForm.h"
#import "PMRegistrationProgressViewModelImpl.h"
#import "PMApplicationRouter.h"
#import "PMProfileApiClient.h"
#import "PMSocketClient.h"
#import "PMDreamer.h"

@interface PMRegistrationProgressLogic ()
@property (nonatomic, strong) PMUserContext *context;
@property (nonatomic, strong) RACCommand *registrationCommand;
@property (nonatomic, strong) PMRegistrationProgressViewModelImpl *viewModel;
@property (nonatomic, strong) RACSubject *progressSubject;
@end

@implementation PMRegistrationProgressLogic
@dynamic context;

- (void)startLogic
{
    self.viewModel = [[PMRegistrationProgressViewModelImpl alloc] initWithProgress:0];
    [super startLogic];
    @weakify(self);
    
    self.progressSubject = [RACSubject subject];
    [self.progressSubject subscribeNext:^(NSProgress *progress) {
        @strongify(self);
        self.viewModel = [[PMRegistrationProgressViewModelImpl alloc] initWithProgress:0.5f + (progress.completedUnitCount / progress.totalUnitCount / 4)];
    }];
    
    self.registrationCommand = [self createRegistrationCommand];
}

#pragma mark - private

- (RACCommand *)createRegistrationCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self registrationSignal];
    }];
}

- (RACSignal *)registrationSignal;
{
    @weakify(self);
    RACSignal *signal = [self.authService registerDreamer:self.context.userForm];
    signal = [self authAfter:signal];
    
    if (self.context.userForm.avatarForm) {
        signal = [self postAvatarAfter:signal];
    }
    
    return [[signal
        doError:^(NSError *error) {
            @strongify(self);
            [self applyError:error];
            [self.context.errorsSubject sendNext:error.localizedDescription];
            [self performSegueWithIdentifier:kPMSegueIdentifierCloseRegistrationProgressVC context:self.context];
        }]
        doNext:^(PMDreamerResponse *response) {
            @strongify(self);
            [self.socketClient openSocketWithToken:response.dreamer.token];
            self.viewModel = [[PMRegistrationProgressViewModelImpl alloc] initWithProgress:1.0f];
            [self.router openMainVC];
        }];
}

- (RACSignal *)authAfter:(RACSignal *)signal
{
    @weakify(self);
    return [signal then:^RACSignal *{
        @strongify(self);
        self.viewModel = [[PMRegistrationProgressViewModelImpl alloc] initWithProgress:0.33f];
        return [self.authService authenticateWithUsername:self.context.userForm.email password:self.context.userForm.password];
    }];
}

- (RACSignal *)postAvatarAfter:(RACSignal *)signal
{
    @weakify(self);
    
    return [signal then:^RACSignal *{
        @strongify(self);
        self.viewModel = [[PMRegistrationProgressViewModelImpl alloc] initWithProgress:0.66f];
        RACSignal *signal = [self.profileApiClient postAvatar:self.context.userForm.avatarForm progress:self.progressSubject];
        return signal;
    }];
}

#pragma mark - apply errors

- (void)applyError:(NSError *)error
{
    PMResponseMeta *errorsDictionary = [error.userInfo valueForKey:PMAPIClientResponseKey];
    
    self.context.userForm.isValidPassword = ![self hasErrors:errorsDictionary.errors forKey:@"password"];
    self.context.userForm.isValidEmail = ![self hasErrors:errorsDictionary.errors forKey:@"email"];
    self.context.userForm.isValidFirstName = ![self hasErrors:errorsDictionary.errors forKey:@"first_name"];
    self.context.userForm.isValidSecondName = ![self hasErrors:errorsDictionary.errors forKey:@"last_name"];
    self.context.userForm.isValidBirthDay = ![self hasErrors:errorsDictionary.errors forKey:@"birthday"];
    self.context.userForm.isValidGender = ![self hasErrors:errorsDictionary.errors forKey:@"gender"];
    self.context.userForm.isValidPhoneNumber = ![self hasErrors:errorsDictionary.errors forKey:@"phone"];
}

- (BOOL)hasErrors:(NSDictionary *)errors forKey:(NSString *)key
{
    return ([[errors valueForKey:key] count] > 0);
}

@end
