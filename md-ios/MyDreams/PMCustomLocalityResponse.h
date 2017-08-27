//
//  PMLocalityIdResponse.h
//  MyDreams
//
//  Created by user on 12.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"
#import "PMLocality.h"

@interface PMCustomLocalityResponse : PMBaseResponse
@property (strong, nonatomic, readonly) PMLocality *locality;
@end
