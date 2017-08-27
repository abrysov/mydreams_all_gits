//
//  PMUserAgreementViewModelImpl.h
//  MyDreams
//
//  Created by user on 14.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMUserAgreementViewModel.h"

@interface PMUserAgreementViewModelImpl : NSObject <PMUserAgreementViewModel>
- (instancetype)initWithUserAgreement:(NSString *)userAgreement;
@end
