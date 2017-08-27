//
//  PMRegistrationStep3ViewModelImpl.m
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationStep3ViewModelImpl.h"

@interface PMRegistrationStep3ViewModelImpl ()
@property (strong, nonatomic) NSString *locationTitle;
@property (nonatomic, assign) BOOL isValidPhoneNumber;
@property (strong, nonatomic) UIImage *avatar;
@property (nonatomic, strong) RACSubject *errorsSubject;
@end

@implementation PMRegistrationStep3ViewModelImpl

- (instancetype)initWithUserForm:(PMUserForm *)userForm errorSubject:(RACSubject *)errorSubject
{
    self = [super init];
    if (self) {
        
        self.errorsSubject = errorSubject;
        
        RAC(self, isValidPhoneNumber) = RACObserve(userForm, isValidPhoneNumber);
        RAC(self, avatar) = [RACObserve(userForm, avatarForm)
            map:^id(PMImageForm *avatar) {
                return avatar.cropedImage;
            }];
        
       RAC(self, locationTitle) = [[RACSignal
           combineLatest:@[RACObserve(userForm, country),
                           RACObserve(userForm, locality)]] map:^id(RACTuple *tuple) {
               PMLocation *country = tuple.first;
               PMLocality *locality = tuple.second;
           
               if (!country.name) {
                   return nil;
               }
               if (!locality.name) {
                   return country.name;
               }
               return [NSString stringWithFormat:@"%@, %@", country.name, locality.name];
           }];
    }
    return self;
}
@end
