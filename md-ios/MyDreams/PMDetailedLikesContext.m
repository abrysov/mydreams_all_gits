//
//  PMDetailedLikesContext.m
//  MyDreams
//
//  Created by Alexey Yakunin on 22/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedLikesContext.h"

@implementation PMDetailedLikesContext
+ (instancetype)contextWithIdx:(NSNumber *)idx andType:(PMEntityType)type
{
	PMDetailedLikesContext *context = [self new];
	context.idx = idx;
	context.type = type;
	return context;
}
@end
