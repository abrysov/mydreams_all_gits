//
//  PMCertificates.h
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMDream.h"
#import "PMDreamer.h"
#import "PMCertificateType.h"

@interface PMCertificate : PMBaseModel
@property (nonatomic, strong) NSNumber *accepted;
@property (nonatomic, strong) NSString *wish;
@property (nonatomic, strong) NSNumber *launchesCount;
@property (nonatomic, assign) PMDreamCertificateType certificateType;
@property (nonatomic, strong) PMDream *certifiable;
@property (nonatomic, strong) PMDreamer *giftedBy;
@property (nonatomic, strong) NSDate* createdAt;
@end
