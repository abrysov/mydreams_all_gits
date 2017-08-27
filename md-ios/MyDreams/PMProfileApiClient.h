//
//  PMProfileApiClient.h
//  MyDreams
//
//  Created by user on 01.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.

@class PMDreamerForm;
@class PMImageForm;
@class PMPage;

@protocol PMProfileApiClient <NSObject>

- (RACSignal *)getMe;
- (RACSignal *)changePasswordWithCurrentPassword:(NSString *)currentPassword
                                        password:(NSString *)password
                            passwordConfirmation:(NSString *)passwordConfirm;
- (RACSignal *)changeEmail:(NSString *)email;
- (RACSignal *)changeStatus:(NSString *)status;
- (RACSignal *)editProfile:(PMDreamerForm *)form;
- (RACSignal *)accountDeleting;
- (RACSignal *)getPhotosPage:(PMPage *)page;
- (RACSignal *)createProfilePhoto:(UIImage *)image caption:(NSString *)caption progress:(RACSubject *)progress;
- (RACSignal *)destroyProfilePhoto:(NSNumber *)idx;
- (RACSignal *)postAvatar:(PMImageForm *)avatar progress:(RACSubject *)progress;
- (RACSignal *)postDreambookBackground:(PMImageForm *)form progress:(RACSubject *)progress;
@end
