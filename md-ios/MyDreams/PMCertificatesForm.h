//
//  PMCertificatesForm.h
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@interface PMCertificatesForm : PMBaseModel
@property (nonatomic, strong) NSNumber *isGifted;
@property (nonatomic, strong) NSNumber *isPaid;
@property (nonatomic, strong) NSNumber *isNew;
@property (nonatomic, strong) NSNumber *isLaunches;
@end
