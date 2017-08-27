//
//  PMCertificateViewModelImpl.h
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificateViewModel.h"
#import "PMCertificateType.h"
@interface PMCertificateViewModelImpl : NSObject <PMCertificateViewModel>
@property (strong, nonatomic) RACSignal *imageSignal;
- (instancetype)initWithCertificateType:(PMDreamCertificateType)certificateType;
@end
