//
//  PMCustomLocalityViewModel.h
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol PMCustomLocalityViewModel <NSObject>
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *region;
@property (strong, nonatomic, readonly) NSString *district;
@end
