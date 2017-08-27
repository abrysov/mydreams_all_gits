//
//  PMAPIClientWithStatusChecker.m
//  MyDreams
//
//  Created by Иван Ушаков on 15.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAPIClientWithStatusChecker.h"
#import "PMApplicationRouter.h"
#import "PMAuthService.h"
#import "PMNetworkError.h"
#import "PMResponseMeta.h"

@interface PMAPIClientWithStatusChecker ()
@property (strong, nonatomic) id<PMAPIClient> apiClient;
@end

@implementation PMAPIClientWithStatusChecker

- (instancetype)initWithApiClient:(id<PMAPIClient>)apiClient
{
    self = [super init];
    if (self) {
        self.apiClient = apiClient;
    }
    return self;
}

- (RACSignal *)requestPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method mapResponseToClass:(Class)klass
{
    return [self fillterByStatus:[self.apiClient requestPath:path parameters:parameters method:method mapResponseToClass:klass]];
}

- (RACSignal *)requestPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method keyPath:(NSString *)keyPath mapResponseToClass:(Class)klass
{
    return [self fillterByStatus:[self.apiClient requestPath:path parameters:parameters method:method keyPath:keyPath mapResponseToClass:klass]];
}

- (RACSignal *)uploadPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method mapResponseToClass:(Class)klass progress:(RACSubject *)progress
{
    return [self fillterByStatus:[self.apiClient uploadPath:path parameters:parameters method:method mapResponseToClass:klass progress:progress]];
}

- (RACSignal *)uploadPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method keyPath:(NSString *)keyPath mapResponseToClass:(Class)klass progress:(RACSubject *)progress
{
    return [self fillterByStatus:[self.apiClient uploadPath:path parameters:parameters method:method keyPath:keyPath mapResponseToClass:klass progress:progress]];
}

#pragma mark - private

- (RACSignal *)fillterByStatus:(RACSignal *)signal
{
    @weakify(self);
    return [signal catch:^RACSignal *(NSError *error) {
        @strongify(self);
        
        if (error.code == 401) {
            [self.authService logout];
            [self.router openAuthVC];
            return [RACSignal empty];
        }
        else if (error.code == 403) {
            
            PMResponseMeta *meta = error.userInfo[PMAPIClientResponseKey];
            if (meta.isBlocked) {
                [self.router openUserBlockedVC];
            }
            else if (meta.isDeleted) {
                [self.router openUserDeletedVC];
            }
            
            return [RACSignal empty];
        }
        
        return [RACSignal error:error];
    }];
}

@end
