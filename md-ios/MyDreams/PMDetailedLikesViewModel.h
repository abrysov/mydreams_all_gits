//
//  PMDetailedLikesViewModel.h
//  MyDreams
//
//  Created by Alexey Yakunin on 22/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMDetailedLikesViewModel <NSObject>
@property (strong, nonatomic) NSString* title;
@property (assign, nonatomic, readonly) NSUInteger totalCount;
@property (strong, nonatomic, readonly) NSArray* dreamers;
@end
