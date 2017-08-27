//
//  PMMarkReadImCommand.h
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseImCommand.h"

@interface PMMarkReadImCommand : PMBaseImCommand
@property (strong, nonatomic) NSNumber *conversationIdx;
@property (strong, nonatomic) NSNumber *messageIdx;
@end
