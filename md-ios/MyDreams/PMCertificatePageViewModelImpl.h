//
//  PMCertificatePageViewModelImpl.h
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificatePageViewModel.h"

@class PMCertificate;

@interface PMCertificatePageViewModelImpl : NSObject <PMCertificatePageViewModel>
@property (strong, nonatomic) RACSignal *imageSignal;
- (instancetype)initWithCertificate:(PMCertificate *)certificate totalCount:(NSInteger)totalCount pageIndex:(NSUInteger)pageIndex;
@end
