//
//  PMCertificateDetailViewModelImpl.h
//  MyDreams
//
//  Created by Alexey Yakunin on 20/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMCertificateDetailViewModel.h"
#import "PMCertificate.h"

@interface PMCertificateDetailViewModelImpl : NSObject <PMCertificateDetailViewModel>

@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) UIImage *avatarImage;
- (instancetype)initWithCertificate:(PMCertificate *)certificate;
@end
