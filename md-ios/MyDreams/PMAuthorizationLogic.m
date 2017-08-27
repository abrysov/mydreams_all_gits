//
//  PMAuthorizationLogic.m
//  MyDreams
//
//  Created by Иван Ушаков on 18.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAuthorizationLogic.h"
#import "PMAuthService.h"
#import "AuthentificationSegues.h"
#import "PMDreamerResponse.h"
#import "PMSocialNetworkCredentials.h"
#import "PMApplicationRouter.h"
#import "PMSocketClient.h"

NSString * const PMAuthorizationLogicErrorDomain = @"com.mydreams.auth.logic.error";

@interface PMAuthorizationLogic ()
@property (nonatomic, strong) RACChannelTerminal *usernameTerminal;
@property (nonatomic, strong) RACChannelTerminal *passwordTerminal;

@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) RACCommand *remaindPasswordCommand;
@property (nonatomic, strong) RACCommand *registrationCommand;

@property (nonatomic, strong) RACCommand *loginWithVKCommand;
@property (nonatomic, strong) RACCommand *loginWithFacebookCommand;
@property (nonatomic, strong) RACCommand *loginWithInstagrammCommand;
@property (nonatomic, strong) RACCommand *loginWithTwitterCommand;

@property (nonatomic, assign) BOOL isValidInput;
@property (nonatomic, assign) BOOL isValidUsername;
@property (nonatomic, assign) BOOL isValidPassword;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@end

@implementation PMAuthorizationLogic

- (void)startLogic
{
    [super startLogic];
    
    self.isValidUsername = YES;
    self.isValidPassword = YES;
    self.isValidInput = YES;
    
    self.usernameTerminal = RACChannelTo(self, username);
    self.passwordTerminal = RACChannelTo(self, password);
    
    self.loginCommand = [self createLoginCommand];
    self.remaindPasswordCommand = [self createRemaindPasswordCommand];
    self.registrationCommand = [self createRegistrationCommand];
    
    self.loginWithVKCommand = [self commandForSocialNetwork:PMAuthServiceSocialNetworkVK];
    self.loginWithFacebookCommand = [self commandForSocialNetwork:PMAuthServiceSocialNetworkFacebook];
    self.loginWithInstagrammCommand = [self commandForSocialNetwork:PMAuthServiceSocialNetworkInstagram];
    self.loginWithTwitterCommand = [self commandForSocialNetwork:PMAuthServiceSocialNetworkTwitter];
    
    @weakify(self);
    [RACObserve(self, username) subscribeNext:^(id x) {
        @strongify(self);
        [self validateUsername];
    }];
    
    [RACObserve(self, password) subscribeNext:^(id x) {
        @strongify(self);
        [self validatePassword];
    }];
}

- (RACCommand *)createLoginCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validate];
        
        RACSignal *signal = nil;
        
        if (self.isValidInput) {
            signal = [self connectSocketAndOpenVCOn:[self.authService authenticateWithUsername:self.username password:self.password]];
        }
        else {
            NSError *error = [NSError errorWithDomain:PMAuthorizationLogicErrorDomain
                                                 code:PMAuthorizationLogicErrorInvalidInput
                                             userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"error.invalidInput", nil)}];
            signal = [RACSignal error:error];
        }
        
        return [signal
            doError:^(NSError *error) {
                @strongify(self);
                [self setInputInvalid];
            }];
    }];
}

- (RACCommand *)createRemaindPasswordCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToRemindPasswordVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createRegistrationCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToRegistrationVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)commandForSocialNetwork:(PMAuthServiceSocialNetwork) socialNetwork
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(PMSocialNetworkCredentials *credentials) {
        @strongify(self);
        return [self authenticateWithSocialNetwork:socialNetwork credentials:credentials];
    }];
}

#pragma mark - validation

- (void)validate
{
    [self validateUsername];
    [self validatePassword];
}

- (void)validateUsername
{
    self.isValidUsername = (self.username.length > 0) && (self.username.length < 255) && [self checkEMailOnSymbols];
    self.isValidInput = self.isValidUsername && self.isValidPassword;
}

- (void)validatePassword
{
    NSString *trimmedString = [self.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.isValidPassword = (trimmedString.length > 5) && (trimmedString.length < 255);
    self.isValidInput = self.isValidUsername && self.isValidPassword;
}

- (void)setInputInvalid
{
    self.isValidUsername = NO;
    self.isValidPassword = NO;
    self.isValidInput = NO;
}

- (BOOL)checkEMailOnSymbols
{
    NSArray *arraySymbolsForValidating = @[@"@", @"."];
    for (NSString *symbol in arraySymbolsForValidating) {
        if ([self.username rangeOfString:symbol].location == NSNotFound) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - private

- (RACSignal *)connectSocketAndOpenVCOn:(RACSignal *)signal
{
    @weakify(self);
    return [signal
        doNext:^(PMDreamerResponse *response) {
            @strongify(self);
            [self.socketClient openSocketWithToken:response.dreamer.token];
            [self.router openMainVC];
        }];
}

- (RACSignal *)authenticateWithSocialNetwork:(PMAuthServiceSocialNetwork) socialNetwork credentials:(PMSocialNetworkCredentials *)credentials
{
    return [self connectSocketAndOpenVCOn:[self.authService authenticateWithSocialNetwork:socialNetwork credentials:credentials]];
}

@end
