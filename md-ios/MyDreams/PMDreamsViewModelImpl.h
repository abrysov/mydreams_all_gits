//
//  PMDreamsViewModelImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDreamsViewModel.h"

@interface PMDreamsViewModelImpl : NSObject <PMDreamsViewModel>
@property (strong, nonatomic) NSArray *dreams;
@end
