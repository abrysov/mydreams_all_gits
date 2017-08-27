//
//  PMListNewCertificatesVC.h
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"
#import "PMListNewCertificatesLogic.h"

@class PMListNewCertificatesVC;

@interface PMListNewCertificatesVC : PMBaseVC
@property (assign, nonatomic) BOOL isNewCertificatesEmpty;
@property (strong, nonatomic) PMListNewCertificatesLogic *logic;
@end
