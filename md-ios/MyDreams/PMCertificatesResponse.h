//
//  PMCertificatesResponse.h
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMCertificate;

@interface PMCertificatesResponse : PMPaginationResponse
@property (nonatomic, strong) NSArray<PMCertificate *> *certificates;
@end
