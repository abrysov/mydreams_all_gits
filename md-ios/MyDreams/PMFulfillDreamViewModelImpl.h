//
//  PMFulfillDreamViewModelImpl.h
//  MyDreams
//
//  Created by user on 19.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFulfillDreamViewModel.h"
#import "PMDreamForm.h"

@interface PMFulfillDreamViewModelImpl : NSObject <PMFulfillDreamViewModel>
@property (nonatomic, assign) CGFloat progress;
- (instancetype)initWithDreamForm:(PMDreamForm *)form;
@end
