//
//  PMAddLocalityLogic.h
//  myDreams
//
//  Created by AlbertA on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMCustomLocalityViewModelImpl.h"

extern NSString * const PMSuccessfulProposalLocalityLogicErrorDomain;

@interface PMSuccessfulProposalLocalityLogic : PMBaseLogic
@property (nonatomic, strong, readonly) id<PMCustomLocalityViewModel> customLocality;
@property (nonatomic, strong, readonly) RACCommand *backToRegistrationCommand;
@end
