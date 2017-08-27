//
//  PMCertificateDetailContext.m
//  MyDreams
//
//  Created by Alexey Yakunin on 20/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificateDetailContext.h"
#import "PMCertificate.h"

@implementation PMCertificateDetailContext
+ (instancetype)contextWithCertificate:(PMCertificate *)certificate
{
	PMCertificateDetailContext *context = [self new];
	context.certificate = certificate;

	return context;
}
@end
