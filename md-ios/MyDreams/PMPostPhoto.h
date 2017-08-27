//
//  PMPostPhoto.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@class PMImage;

@interface PMPostPhoto : PMBaseModel
@property (strong, nonatomic, readonly) PMImage *photo;
@property (strong, nonatomic, readonly) NSNumber *postIdx;
@end
