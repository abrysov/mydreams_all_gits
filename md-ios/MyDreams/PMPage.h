//
//  PMPage.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@interface PMPage : PMBaseModel
@property (nonatomic, strong, readonly) NSNumber *from;
@property (nonatomic, strong, readonly) NSNumber *per;
@property (nonatomic, strong, readonly) NSNumber *page;

- (instancetype)initWithPage:(NSUInteger)page per:(NSUInteger)per;
- (void)updatePage:(NSInteger)page per:(NSInteger)per;
@end
