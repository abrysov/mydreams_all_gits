//
//  PMLocalityViewModelImpl.h
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocalityViewModel.h"
#import "PMLocality.h"

@interface PMLocalityViewModelImpl : NSObject <PMLocalityViewModel>
- (instancetype)initWithLocality:(PMLocality *)locality;
@end


