//
//  PMCertificateDetailContext.h
//  MyDreams
//
//  Created by Alexey Yakunin on 20/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"
@class PMCertificate;
@interface PMCertificateDetailContext : PMBaseContext
@property (nonatomic, strong) PMCertificate * certificate;
+ (instancetype)contextWithCertificate:(PMCertificate *) certificate;
@end
