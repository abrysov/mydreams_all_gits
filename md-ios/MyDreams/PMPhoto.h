//
//  PMPhoto.h
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@interface PMPhoto : PMBaseModel
@property (strong, nonatomic, readonly) NSString *photo;
@property (strong, nonatomic, readonly) NSString *preview;
@property (strong, nonatomic, readonly) NSString *caption;
@end
