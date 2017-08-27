//
//  PMPhotoViewModel.h
//  MyDreams
//
//  Created by user on 07.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMPhotoViewModel <NSObject>
@property (strong, nonatomic, readonly) RACSignal *imageSignal;
@property (strong, nonatomic, readonly) NSURL *url;
@end