//
//  PMImage.h
//  MyDreams
//
//  Created by Иван Ушаков on 25.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@interface PMImage : PMBaseModel

@property (strong, nonatomic, readonly) NSString *small;
@property (strong, nonatomic, readonly) NSString *preMedium;
@property (strong, nonatomic, readonly) NSString *medium;
@property (strong, nonatomic, readonly) NSString *large;

@end
