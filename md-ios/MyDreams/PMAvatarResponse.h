//
//  PMAvatarResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 10.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"

@class PMImage;

@interface PMAvatarResponse : PMBaseResponse
@property (strong, nonatomic, readonly) PMImage *avatar;
@end
