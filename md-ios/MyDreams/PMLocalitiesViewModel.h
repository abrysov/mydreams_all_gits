//
//  PMLocalitiesViewModel.h
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocality.h"

@protocol PMLocalitiesViewModel <NSObject>
@property (strong, nonatomic, readonly) NSArray *localities;
@end
