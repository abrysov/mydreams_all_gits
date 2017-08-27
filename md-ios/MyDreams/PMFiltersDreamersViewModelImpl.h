//
//  PMFiltersDreamersViewModelImpl.h
//  MyDreams
//
//  Created by user on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMFiltersDreamersViewModel.h"
#import "PMDreamerFilterForm.h"

@interface PMFiltersDreamersViewModelImpl : NSObject <PMFiltersDreamersViewModel>
- (instancetype)initWithFilterForm:(PMDreamerFilterForm *)filterForm;
- (void)updateTotalCount:(NSInteger)totalCount;
- (void)receiveNotFound;
@end
