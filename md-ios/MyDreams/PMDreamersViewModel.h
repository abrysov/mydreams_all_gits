
//
//  PMDreamersViewModel.h
//  MyDreams
//
//  Created by user on 05.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMDreamersViewModel <NSObject>
@property (strong, nonatomic) NSArray *dreamers;
@property (strong, nonatomic, readonly) NSString *totalResult;
@property (strong, nonatomic, readonly) NSString *filtersDescription;
@end