//
//  PMMyDreambookViewModel.h
//  MyDreams
//
//  Created by user on 09.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPost.h"

@protocol PMDreambookViewModel <NSObject>
@property (nonatomic, strong, readonly) NSArray *posts;
@end