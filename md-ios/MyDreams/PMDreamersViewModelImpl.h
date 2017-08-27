//
//  PMDreamersViewModelImpl.h
//  MyDreams
//
//  Created by user on 05.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDreamersViewModel.h"
#import "PMDreamerFilterForm.h"

@interface PMDreamersViewModelImpl : NSObject <PMDreamersViewModel>
- (instancetype)initWithFilterForm:(PMDreamerFilterForm *)filterForm;
- (void)updateTotalCount:(NSNumber *)totalCount;
@property (strong, nonatomic) NSArray *dreamers;

@end
