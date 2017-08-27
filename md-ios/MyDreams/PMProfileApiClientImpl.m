//
//  PMProfileApiClientImpl.m
//  MyDreams
//
//  Created by user on 01.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMProfileApiClientImpl.h"
#import "PMOAuth2APIClient.h"
#import "PMPhotosResponse.h"
#import "PMFile.h"
#import "NSDictionary+PM.h"
#import "PMDreamerForm.h"
#import "NSDictionary+PM.h"
#import "PMDreamerResponse.h"
#import "PMAvatarResponse.h"
#import "PMDreambookBackgroundResponse.h"
#import "PMPage.h"
#import "PMPhotoResponse.h"

@implementation PMProfileApiClientImpl

- (RACSignal *)getMe
{
    return [self.apiClient requestPath:@"me" parameters:nil method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMDreamerResponse class]];
}

- (RACSignal *)changePasswordWithCurrentPassword:(NSString *)currentPassword
                                        password:(NSString *)password
                            passwordConfirmation:(NSString *)passwordConfirm
{
    NSDictionary *params = @{@"current_password":currentPassword,
                             @"password":password,
                             @"password_confirmation":passwordConfirm};
    return [self.apiClient requestPath:@"profile/settings/change_password"
                            parameters:params
                                method:PMAPIClientHTTPMethodPOST
                    mapResponseToClass:nil];
}

- (RACSignal *)changeEmail:(NSString *)email
{
    NSDictionary *params = @{@"email":email};
    return [self.apiClient requestPath:@"profile/settings/change_email"
                            parameters:params
                                method:PMAPIClientHTTPMethodPOST
                    mapResponseToClass:nil];
}

- (RACSignal *)changeStatus:(NSString *)status
{
    NSDictionary *params = @{@"status":status};

    return [self.apiClient requestPath:@"profile"
                            parameters:params
                                method:PMAPIClientHTTPMethodPUT
                    mapResponseToClass:nil];
}

- (RACSignal *)editProfile:(PMDreamerForm *)form
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:&error];
        
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:params];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return [[[signal
              subscribeOn:[RACScheduler scheduler]]
             deliverOn:[RACScheduler mainThreadScheduler]]
            flattenMap:^RACStream *(id params) {
                return [self.apiClient uploadPath:@"profile" parameters:params method:PMAPIClientHTTPMethodPUT mapResponseToClass:nil progress:nil];
            }];
}

- (RACSignal *)accountDeleting
{
    return [self.apiClient requestPath:@"profile"
                            parameters:nil
                                method:PMAPIClientHTTPMethodDELETE
                    mapResponseToClass:nil];
}

- (RACSignal *)getPhotosPage:(PMPage *)page;
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:page error:nil];
    params = [params dictionaryByRemovingNullValues];
    return [self.apiClient requestPath:@"profile/photos"
                            parameters:params
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMPhotosResponse class]];
}

- (RACSignal *)createProfilePhoto:(UIImage *)image caption:(NSString *)caption progress:(RACSubject *)progress
{
    if ([caption isEqualToString:@""]) {
        caption = nil;
    }
    PMFile *photoFile = [[PMFile alloc] initWithName:@"image.jpg" data:UIImageJPEGRepresentation(image, 0.8f) mimeType:@"image/jpeg"];
    NSDictionary *params = (caption) ? @{@"file":photoFile, @"caption":caption} : @{@"file":photoFile};
    params = [params dictionaryByRemovingNullValues];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:params];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return [[[signal
        subscribeOn:[RACScheduler scheduler]]
        deliverOn:[RACScheduler mainThreadScheduler]]
        flattenMap:^RACStream *(id params) {
            return [self.apiClient uploadPath:@"profile/photos" parameters:params method:PMAPIClientHTTPMethodPOST mapResponseToClass:[PMPhotoResponse class] progress:progress];
        }];
}

- (RACSignal *)destroyProfilePhoto:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"profile/photos/%@", idx];
    return [self.apiClient requestPath:requestPath
                            parameters:nil
                                method:PMAPIClientHTTPMethodDELETE
                    mapResponseToClass:[PMBaseResponse class]];
}

- (RACSignal *)postAvatar:(PMImageForm *)avatar progress:(RACSubject *)progress
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:avatar error:&error];
        
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:params];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return [[[signal
        subscribeOn:[RACScheduler scheduler]]
        deliverOn:[RACScheduler mainThreadScheduler]]
        flattenMap:^RACStream *(id params) {
            return [self.apiClient uploadPath:@"profile/avatar" parameters:params method:PMAPIClientHTTPMethodPOST mapResponseToClass:[PMAvatarResponse class] progress:progress];
        }];
}

- (RACSignal *)postDreambookBackground:(PMImageForm *)form progress:(RACSubject *)progress
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:&error];
        params = [params dictionaryByRemovingNullValues];
        
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:params];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return [signal flattenMap:^RACStream *(id params) {
        return [self.apiClient uploadPath:@"profile/dreambook_bg" parameters:params method:PMAPIClientHTTPMethodPOST mapResponseToClass:[PMDreambookBackgroundResponse class] progress:progress];
    }];
}

@end
