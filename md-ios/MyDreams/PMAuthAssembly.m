//
//  NNControllersAssembly.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.10.15.
//  Copyright © 2015 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAuthAssembly.h"
#import "PMApplicationAssembly.h"

#import "PMAuthorizationLogic.h"
#import "PMAuthorizationVC.h"
#import "PMRemaindPasswordLogic.h"
#import "PMRemaindPasswordVC.h"
#import "PMSuccessSendingEmailLogic.h"
#import "PMSuccessSendingEmailVC.h"
#import "PMBlockedProfileLogic.h"
#import "PMBlockedProfileVC.h"
#import "PMRestoreProfileVC.h"
#import "PMRestoreProfileLogic.h"
#import "PMRegistrationVC.h"
#import "PMRegistrationLogic.h"
#import "PMRegistrationStep2VC.h"
#import "PMRegistrationStep2Logic.h"
#import "PMRegistrationStep3VC.h"
#import "PMRegistrationStep3Logic.h"
#import "PMSelectCountryLogic.h"
#import "PMSelectCountryVC.h"
#import "PMSelectLocalityVC.h"
#import "PMSelectLocalityLogic.h"
#import "PMSuccessfulProposalLocalityVC.h"
#import "PMSuccessfulProposalLocalityLogic.h"
#import "PMProposeLocalityVC.h"
#import "PMProposeLocalityLogic.h"
#import "PMUserAgreementVC.h"
#import "PMUserAgreementLogic.h"
#import "PMBaseAuthentificationVC.h"
#import "PMRegistrationProgressLogic.h"
#import "PMRegistrationProgressVC.h"

@interface PMAuthAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMAuthAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (PMBaseAuthentificationVC *)baseAuthentificationVC
{
    return [TyphoonDefinition withClass:[PMBaseAuthentificationVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
    }];
}

- (PMAuthorizationLogic *)authorizationLogic
{
    return [TyphoonDefinition withClass:[PMAuthorizationLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(authService)];
        [definition injectProperty:@selector(router)];
        [definition injectProperty:@selector(socketClient)];
    }];
}

- (PMAuthorizationVC *)authorizationVC
{
    return [TyphoonDefinition withClass:[PMAuthorizationVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.authorizationLogic];
        [definition injectProperty:@selector(socialAuthFactory)];
    }];
}

- (PMRemaindPasswordLogic *)remaindPasswordLogic
{
    return [TyphoonDefinition withClass:[PMRemaindPasswordLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(authService)];
    }];
}

- (PMRemaindPasswordVC *)remaindPasswordVC
{
    return [TyphoonDefinition withClass:[PMRemaindPasswordVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.remaindPasswordLogic];
    }];
}

- (PMRestoreProfileLogic *)restoreProfileLogic
{
    return [TyphoonDefinition withClass:[PMRestoreProfileLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(authService)];
    }];
}

- (PMRestoreProfileVC *)restoreProfileVC
{
    return [TyphoonDefinition withClass:[PMRestoreProfileVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.restoreProfileLogic];
    }];
}

- (PMSuccessSendingEmailLogic *)successSendingEmailLogic
{
    return [TyphoonDefinition withClass:[PMSuccessSendingEmailLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
    }];
}

- (PMSuccessSendingEmailVC *)successSendingEmailVC
{
    return [TyphoonDefinition withClass:[PMSuccessSendingEmailVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.successSendingEmailLogic];
    }];
}

- (PMBlockedProfileLogic *)blockedProfileLogic
{
    return [TyphoonDefinition withClass:[PMBlockedProfileLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(supportEmail) with:TyphoonConfig(@"support.email")];
    }];
}

- (PMBlockedProfileVC *)blockedProfileVC
{
    return [TyphoonDefinition withClass:[PMBlockedProfileVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.blockedProfileLogic];
    }];
}

- (PMRegistrationLogic *)registrationLogic
{
    return [TyphoonDefinition withClass:[PMRegistrationLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(authService)];
        [definition injectProperty:@selector(router)];
        [definition injectProperty:@selector(emailValidator)];
        [definition injectProperty:@selector(socketClient)];
    }];
}

- (PMRegistrationVC *)registrationVC
{
    return [TyphoonDefinition withClass:[PMRegistrationVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.registrationLogic];
        [definition injectProperty:@selector(socialAuthFactory)];
    }];
}

- (PMRegistrationStep2Logic *)registrationStep2Logic
{
    return [TyphoonDefinition withClass:[PMRegistrationStep2Logic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
    }];
}

- (PMRegistrationStep2VC *)registrationStep2VC
{
    return [TyphoonDefinition withClass:[PMRegistrationStep2VC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.registrationStep2Logic];
    }];
}

- (PMRegistrationStep3Logic *)registrationStep3Logic
{
    return [TyphoonDefinition withClass:[PMRegistrationStep3Logic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
    }];
}

- (PMRegistrationStep3VC *)registrationStep3VC
{
    return [TyphoonDefinition withClass:[PMRegistrationStep3VC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.registrationStep3Logic];
    }];
}

- (PMRegistrationProgressLogic *)registrationProgressLogic
{
    return [TyphoonDefinition withClass:[PMRegistrationProgressLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(authService)];
        [definition injectProperty:@selector(router)];
        [definition injectProperty:@selector(profileApiClient)];
        [definition injectProperty:@selector(socketClient)];
    }];
}

- (PMRegistrationProgressVC *)registrationProgressVC
{
    return [TyphoonDefinition withClass:[PMRegistrationProgressVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.registrationProgressLogic];
    }];
}

- (PMSelectCountryLogic *)selectCountyLogic
{
    return [TyphoonDefinition withClass:[PMSelectCountryLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(locationService)];
    }];
}

- (PMSelectCountryVC *)selectCountyVC
{
    return [TyphoonDefinition withClass:[PMSelectCountryVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.selectCountyLogic];
    }];
}

- (PMSelectLocalityLogic *)selectLocalityLogic
{
    return [TyphoonDefinition withClass:[PMSelectLocalityLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
         [definition injectProperty:@selector(locationService)];
    }];
}

- (PMSelectLocalityVC *)selectLocalityVC
{
    return [TyphoonDefinition withClass:[PMSelectLocalityVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.selectLocalityLogic];
    }];
}


- (PMSuccessfulProposalLocalityLogic *)successfulProposalLocalityLogic
{
    return [TyphoonDefinition withClass:[PMSuccessfulProposalLocalityLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
    }];
}

- (PMSuccessfulProposalLocalityVC *)successfulProposalLocalityVC
{
    return [TyphoonDefinition withClass:[PMSuccessfulProposalLocalityVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.successfulProposalLocalityLogic];
    }];
}

- (PMProposeLocalityLogic *)proposeLocalityLogic
{
    return [TyphoonDefinition withClass:[PMProposeLocalityLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(locationService)];
    }];
}

- (PMProposeLocalityVC *)proposeLocalityVC
{
    return [TyphoonDefinition withClass:[PMProposeLocalityVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.proposeLocalityLogic];
    }];
}

- (PMUserAgreementLogic *)userAgreementLogic
{
    return [TyphoonDefinition withClass:[PMUserAgreementLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(authService)];
    }];
}

- (PMUserAgreementVC *)userAgreementVC
{
    return [TyphoonDefinition withClass:[PMUserAgreementVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.baseAuthentificationVC;
        [definition injectProperty:@selector(logic) with:self.userAgreementLogic];
    }];
}

@end
