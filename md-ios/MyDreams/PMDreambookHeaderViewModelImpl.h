//
//  PMMyDreambookViewModelImpl.h
//  MyDreams
//
//  Created by user on 09.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookHeaderViewModel.h"
#import "PMDreamer.h"

@interface PMDreambookHeaderViewModelImpl : NSObject <PMDreambookHeaderViewModel>
@property (assign, nonatomic) BOOL isMe;
@property (strong, nonatomic) PMDreamer *dreamer;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) UIImage *background;
@property (strong, nonatomic) RACSignal *friendshipRequestSignal;
@property (assign, nonatomic) PMDreamerSubscriptionType subscriptionType;
@property (assign, nonatomic) NSUInteger postsCountInteger;

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl;

@end
