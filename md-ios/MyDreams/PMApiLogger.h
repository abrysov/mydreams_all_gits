//
//  PMApiLogger.h
//  MyDreams
//
//  Created by Иван Ушаков on 05.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMApiLogger <NSObject>

- (void)startLogging;
- (void)stopLogging;

@end
