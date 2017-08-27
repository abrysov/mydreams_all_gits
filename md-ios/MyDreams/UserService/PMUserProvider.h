//
//  PMUserProvider.h
//  myDreams
//
//  Created by Ivan Ushakov on 28/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDreamer.h"
#import "PMStatus.h"

@protocol PMUserProvider <NSObject>
@property (strong, nonatomic) PMDreamer *me;
@property (strong, nonatomic) PMStatus *status;
@end
