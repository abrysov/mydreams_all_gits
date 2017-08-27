//
//  PMFiltersDreamersContext.h
//  MyDreams
//
//  Created by user on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"
#import "PMDreamerFilterForm.h"

@interface PMFiltersDreamersContext : PMBaseContext
@property (nonatomic, strong) PMDreamerFilterForm *filterForm;
+ (PMFiltersDreamersContext *)contextWithFilterForm:(PMDreamerFilterForm *)dreamerFilterForm;
@end
