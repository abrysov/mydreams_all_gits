//
//  PMListPhotosViewModelImpl.h
//  MyDreams
//
//  Created by user on 07.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMContainedListPhotosViewModel.h"

@interface PMContainedListPhotosViewModelImpl : NSObject <PMContainedListPhotosViewModel>
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray<NSURL *> *photoUrls;
@property (assign, nonatomic) BOOL isMe;
@end
