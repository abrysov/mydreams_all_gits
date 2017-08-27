//
//  PMRegistrationStep3ViewModel.h
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//


@protocol PMRegistrationStep3ViewModel <NSObject>
@property (strong, nonatomic, readonly) NSString *locationTitle;
@property (nonatomic, assign, readonly) BOOL isValidPhoneNumber;
@property (strong, nonatomic, readonly) UIImage *avatar;
@property (nonatomic, strong, readonly) RACSubject *errorsSubject;
@end
