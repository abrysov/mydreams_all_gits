//
//  PMReaction.h
//  MyDreams
//
//  Created by Иван Ушаков on 27.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMEntityType.h"

@interface PMReaction : PMBaseModel
@property (assign, nonatomic) PMEntityType *resourceType;
@property (strong, nonatomic) NSNumber *resourceIdx;
@property (strong, nonatomic) NSString *reaction;
@property (strong, nonatomic) NSString *dreamerFirstName;
@property (strong, nonatomic) NSString *dreamerLastName;
@end
