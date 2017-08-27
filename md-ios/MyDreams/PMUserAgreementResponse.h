//
//  PMUserAgreement.h
//  MyDreams
//
//  Created by user on 14.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"

@interface PMUserAgreementResponse : PMBaseResponse
@property (strong, nonatomic, readonly) NSString *terms;
@end
