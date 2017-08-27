//
//  PMDetailedLikesViewModelImpl.h
//  MyDreams
//
//  Created by Alexey Yakunin on 22/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedLikesViewModel.h"

@interface PMDetailedLikesViewModelImpl: NSObject <PMDetailedLikesViewModel>
@property (strong, nonatomic) NSString* title;
@property (assign, nonatomic) NSUInteger totalCount;
@property (strong, nonatomic) NSArray* dreamers;
@end