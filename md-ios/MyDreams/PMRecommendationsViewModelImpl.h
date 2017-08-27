//
//  PMRecommendationsViewModelImpl.h
//  MyDreams
//
//  Created by user on 05.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRecommendationsViewModel.h"

@interface PMRecommendationsViewModelImpl : NSObject <PMRecommendationsViewModel>
@property (strong, nonatomic) NSArray *items;
@end
