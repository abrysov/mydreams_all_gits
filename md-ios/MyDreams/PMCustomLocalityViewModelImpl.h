//
//  PMCustomLocalityViewModelImpl.h
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCustomLocalityViewModel.h"
#import "PMLocalityForm.h"

@interface PMCustomLocalityViewModelImpl : NSObject <PMCustomLocalityViewModel>
- (instancetype)initWithLocalityForm:(PMLocalityForm *)localityForm;

@end
