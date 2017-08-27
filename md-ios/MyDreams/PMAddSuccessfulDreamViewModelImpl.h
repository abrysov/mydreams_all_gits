//
//  PMAddSuccessfulDreamViewModelImpl.h
//  MyDreams
//
//  Created by user on 17.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAddSuccessfulDreamViewModel.h"
#import "PMDreamForm.h"

@interface PMAddSuccessfulDreamViewModelImpl:NSObject <PMAddSuccessfulDreamViewModel>
@property (nonatomic, assign) CGFloat progress;
- (instancetype)initWithDreamForm:(PMDreamForm *)form;
@end
