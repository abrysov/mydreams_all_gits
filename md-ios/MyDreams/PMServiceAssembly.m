//
//  NNServiceAssembly.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.10.15.
//  Copyright © 2015 Perpetuum Mobile lab. All rights reserved.
//

#import "PMServiceAssembly.h"
#import "PMApplicationAssembly.h"

#import <Mantle/Mantle.h>
#import <Realm/Realm.h>

#import "PMStorageServiceImpl.h"
#import "PMObjectMapperMantle.h"
#import "PMObjectMapperRealm.h"
#import "PMObjectMapperMulti.h"
#import "PMNetworkErrorMapperImpl.h"
#import "PMOAuth2APIClientImpl.h"
#import "PMOAuth2APIClientStub.h"
#import "PMAPIClientWithStatusChecker.h"
#import "PMAuthServiceImpl.h"
#import "PMProfileApiClientImpl.h"
#import "PMCredentialStoreImpl.h"
#import "PMDreamerApiClientImpl.h"
#import "PMDreamApiClientImpl.h"
#import "PMLikeApiClientImpl.h"
#import "PMUserProviderImpl.h"
#import "PMPollingDataFetcher.h"
#import "PMImageDownloaderImpl.h"
#import "PMApiLoggerImpl.h"
#import "PMSocialAuthFactory.h"
#import "PMFacebookAuthDelegate.h"
#import "PMVkontakteAuthDelegate.h"
#import "PMTwitterAuthDelegate.h"
#import "PMInstagramAuthDelegate.h"
#import "PMAlertManager.h"
#import "PMLocationServiceImpl.h"
#import "PMFriendsApiClientImpl.h"
#import "PMEmailValidator.h"
#import "PMPostApiClientImpl.h"
#import "PMCertificatesApiClientImpl.h"
#import "PMDreamMapperImpl.h"
#import "PMPostMapperImpl.h"
#import "PMDreamerMapperImpl.h"
#import "PMPhotoMapperImpl.h"
#import "PMSocketClientImpl.h"
#import "PMCommentsApiClientImpl.h"
#import "PMDreamclubWrapperApiClientImpl.h"

@interface PMServiceAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMServiceAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (id<PMStorageService>)storageService
{
    return [TyphoonDefinition withClass:[PMStorageServiceImpl class]];
}

- (id<PMObjectMapper>)objectMapperMantle
{
    return [TyphoonDefinition withClass:[PMObjectMapperMantle class]];
}

- (id<PMObjectMapper>)objectMapperRealm
{
    return [TyphoonDefinition withClass:[PMObjectMapperRealm class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(storage)];
    }];
}

- (id<PMObjectMapper>)objectMapper
{
    return [TyphoonDefinition withClass:[PMObjectMapperMulti class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(registerMapper:forClass:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:self.objectMapperMantle];
            [method injectParameterWith:[MTLModel class]];
        }];
        
        [definition injectMethod:@selector(registerMapper:forClass:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:self.objectMapperRealm];
            [method injectParameterWith:[RLMObject class]];
        }];
    }];
}

- (id<PMNetworkErrorMapper>)networkErrorMapper
{
    return [TyphoonDefinition withClass:[PMNetworkErrorMapperImpl class]];
}

- (id<PMAPIClient>)apiClient
{
//    return [TyphoonDefinition withClass:[PMOAuth2APIClientStub class] configuration:^(TyphoonDefinition *definition) {
    return [TyphoonDefinition withClass:[PMOAuth2APIClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithBaseURL:configuration:clientID:secret:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonConfig(@"api.url")];
            [initializer injectParameterWith:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [initializer injectParameterWith:TyphoonConfig(@"api.application")];
            [initializer injectParameterWith:TyphoonConfig(@"api.secret")];
        }];
        [definition injectProperty:@selector(errorMapper)];
        [definition injectProperty:@selector(objectMapper) with:self.objectMapper];
        
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (id<PMAPIClient>)apiClientWithStatusChecker
{
    return [TyphoonDefinition withClass:[PMAPIClientWithStatusChecker class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithApiClient:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self.apiClient];
        }];
        
        [definition injectProperty:@selector(router)];
        [definition injectProperty:@selector(authService)];
    }];
}

- (id<PMCredentialStore>)credentialStore
{
    return [TyphoonDefinition withClass:[PMCredentialStoreImpl class]];
}

- (id<PMAuthService>)authService
{
    return [TyphoonDefinition withClass:[PMAuthServiceImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClient]];
        [definition injectProperty:@selector(credentialStore)];
        [definition injectProperty:@selector(userProvider)];
        [definition injectProperty:@selector(dataFetcher)];
        [definition injectProperty:@selector(profileApiClient)];
    }];
}

- (id<PMProfileApiClient>)profileApiClient
{
    return [TyphoonDefinition withClass:[PMProfileApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClient]];
    }];
}

- (id<PMPostApiClient>)postApiClient
{
    return [TyphoonDefinition withClass:[PMPostApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClient]];
    }];
}        
        
- (id<PMFriendsApiClient>)friendshipRequestsApiClient
{
    return [TyphoonDefinition withClass:[PMFriendsApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClient]];
    }];
}

- (id<PMLocationService>)locationService
{
    return [TyphoonDefinition withClass:[PMLocationServiceImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClientWithStatusChecker]];
    }];
}

- (id<PMDreamerApiClient>)dreamerApiClient
{
    return [TyphoonDefinition withClass:[PMDreamerApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClientWithStatusChecker]];
    }];
}

- (id<PMDreamApiClient>)dreamApiClient
{
    return [TyphoonDefinition withClass:[PMDreamApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClientWithStatusChecker]];
    }];
}

- (id<PMLikeApiClient>)likeApiClient
{
    return [TyphoonDefinition withClass:[PMLikeApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClientWithStatusChecker]];
    }];
}

- (id<PMCertificatesApiClient>)certificatesApiClient
{
    return [TyphoonDefinition withClass:[PMCertificatesApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(apiClient) with:[self apiClientWithStatusChecker]];
    }];
}

- (id<PMUserProvider>)userProvider
{
    return [TyphoonDefinition withClass:[PMUserProviderImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithStorage:dataFetcher:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self.storageService];
            [initializer injectParameterWith:self.dataFetcher];
        }];
        
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (id <PMDataFetcher>)dataFetcher
{
    return [TyphoonDefinition withClass:[PMPollingDataFetcher class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dreamerApiClient)];
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (id <PMImageDownloader>)imageDownloader
{
    return [TyphoonDefinition withClass:[PMImageDownloaderImpl class]];
}

- (id <PMApiLogger>)apiLogger
{
    return [TyphoonDefinition withClass:[PMApiLoggerImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition performAfterInjections:@selector(startLogging)];
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (PMVkontakteAuthDelegate *)vkontakteAuth
{
    return [TyphoonDefinition withClass:[PMVkontakteAuthDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithAppId:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonConfig(@"vk.appId")];
        }];
    }];
}

- (PMSocialAuthFactory *)objectSocialNetwork
{
    return [TyphoonDefinition withClass:[PMSocialAuthFactory class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(registerSocialNetwork:withClass:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:PMSocialAuthFactoryVK];
            [method injectParameterWith:[self vkontakteAuth]];
        }];
        
        [definition injectMethod:@selector(registerSocialNetwork:withClass:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:PMSocialAuthFactoryFacebook];
            [method injectParameterWith:[PMFacebookAuthDelegate new]];
        }];
        
        [definition injectMethod:@selector(registerSocialNetwork:withClass:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:PMSocialAuthFactoryTwitter];
            [method injectParameterWith:[PMTwitterAuthDelegate new]];
        }];
        
        [definition injectMethod:@selector(registerSocialNetwork:withClass:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:PMSocialAuthFactoryInstagram];
            [method injectParameterWith:[PMInstagramAuthDelegate new]];
        }];
    }];
}

- (PMAlertManager *)alertManager
{
    return [TyphoonDefinition withClass:[PMAlertManager class]];
}

- (PMEmailValidator *)emailValidator
{
    return [TyphoonDefinition withClass:[PMEmailValidator class]];
}

- (id <PMDreamMapper>)dreamMapper
{
    return [TyphoonDefinition withClass:[PMDreamMapperImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageDownloader)];
        [definition injectProperty:@selector(likeApiClient)];
    }];
}

- (id <PMPostMapper>)postMapper
{
    return [TyphoonDefinition withClass:[PMPostMapperImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageDownloader)];
        [definition injectProperty:@selector(likeApiClient)];
    }];
}

- (id <PMDreamerMapper>)dreamerMapper
{
    return [TyphoonDefinition withClass:[PMDreamerMapperImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageDownloader)];
        [definition injectProperty:@selector(friendsApiClient)];
    }];
}

- (id <PMPhotoMapper>)photoMapper
{
    return [TyphoonDefinition withClass:[PMPhotoMapperImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageDownloader)];
    }];
}

- (id<PMSocketClient>)socketClient
{
    return [TyphoonDefinition withClass:[PMSocketClientImpl class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeLazySingleton;
        
        [definition useInitializer:@selector(initWithBaseURL:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonConfig(@"websocket.url")];
        }];
        
        [definition injectProperty:@selector(objectMapper) with:self.objectMapper];
    }];
}

- (id <PMCommentsApiClient>)commentsApiClient
{
    return [TyphoonDefinition withClass:[PMCommentsApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithSocketClient:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self.socketClient];
        }];
    }];
}

- (id <PMDreamclubWrapperApiClient>)dreamclubWrapperApiClient
{
    return [TyphoonDefinition withClass:[PMDreamclubWrapperApiClientImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dreamerApiClient)];
        [definition injectProperty:@selector(postApiClient)];
    }];
}

@end
