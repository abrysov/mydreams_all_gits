//
//  PMSearchViewModelImpl.h
//  MyDreams
//
//  Created by user on 26.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSearchViewModel.h"

@interface PMSearchViewModelImpl : NSObject <PMSearchViewModel>
@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) PMSearchType type;
@end
