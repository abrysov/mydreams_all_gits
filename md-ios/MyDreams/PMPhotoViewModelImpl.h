//
//  PMPhotoViewModelImpl.h
//  MyDreams
//
//  Created by user on 07.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPhotoViewModel.h"

@interface PMPhotoViewModelImpl : NSObject <PMPhotoViewModel>
@property (strong, nonatomic) RACSignal *imageSignal;
@property (strong, nonatomic) NSURL *url;
@end
