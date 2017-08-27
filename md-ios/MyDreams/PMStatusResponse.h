//
//  PMStatusResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"
#import "PMStatus.h"

@interface PMStatusResponse : PMBaseResponse
@property (strong, nonatomic, readonly) PMStatus *status;
@end
