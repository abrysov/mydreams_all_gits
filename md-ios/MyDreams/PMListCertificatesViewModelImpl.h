//
//  PMListCertificatesViewModelImpl.h
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListCertificatesViewModel.h"

@interface PMListCertificatesViewModelImpl : NSObject <PMListCertificatesViewModel>
@property (strong, nonatomic) NSArray *certificates;
@end
