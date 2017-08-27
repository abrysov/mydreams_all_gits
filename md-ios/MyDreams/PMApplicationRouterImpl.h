//
//  PMApplicationRouterImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 15.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMApplicationRouter.h"

@interface PMApplicationRouterImpl : NSObject <PMApplicationRouter>
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) PMMenuItem selectedMenuItem;
@end
