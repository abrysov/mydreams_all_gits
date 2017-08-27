//
//  PMListPhotosViewModel.h
//  MyDreams
//
//  Created by user on 07.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMContainedListPhotosViewModel <NSObject>
@property (strong, nonatomic, readonly) NSArray *photos;
@property (assign, nonatomic, readonly) BOOL isMe;
@end