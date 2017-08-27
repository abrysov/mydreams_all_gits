//
//  PMLocalitiesViewModelImpl.h
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMLocalitiesViewModel.h"

@interface PMLocalitiesViewModelImpl : NSObject <PMLocalitiesViewModel>
- (instancetype)initWithLocalities:(NSArray *)localities;
@end
