//
//  PMEditDreamViewModelImpl.h
//  MyDreams
//
//  Created by user on 25.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditDreamViewModel.h"

@class PMDreamForm;

@interface PMEditDreamViewModelImpl : NSObject <PMEditDreamViewModel>
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIImage *photo;
- (instancetype)initWithDreamForm:(PMDreamForm *)form;
@end
