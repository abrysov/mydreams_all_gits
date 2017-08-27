//
//  PMSubjectContext.h
//  MyDreams
//
//  Created by Иван Ушаков on 15.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"

@interface PMSubjectContext : NSObject

+ (instancetype)contextWithSubject:(RACSubject *)subject;

@property (strong, nonatomic) RACSubject *subject;

@end
