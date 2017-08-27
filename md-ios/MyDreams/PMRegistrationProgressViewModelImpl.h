//
//  PMRegistrationProgressViewModelImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMRegistrationProgressViewModel.h"

@interface PMRegistrationProgressViewModelImpl : NSObject <PMRegistrationProgressViewModel>
- (instancetype)initWithProgress:(CGFloat)progress;
@end
