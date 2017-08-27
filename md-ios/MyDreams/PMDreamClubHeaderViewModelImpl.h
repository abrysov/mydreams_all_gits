//
//  PMDreamClubHeaderViewModelImpl.h
//  MyDreams
//
//  Created by user on 08.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamClubHeaderViewModel.h"

@class PMDreamer;

@interface PMDreamClubHeaderViewModelImpl : NSObject <PMDreamClubHeaderViewModel>
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) UIImage *background;

- (instancetype)initWithDreamer:(PMDreamer *)dreamer;

@end
