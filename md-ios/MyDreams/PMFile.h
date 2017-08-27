//
//  PMFile.h
//  MyDreams
//
//  Created by Иван Ушаков on 11.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMFile : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSString *mimeType;

- (instancetype)initWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType;
@end
