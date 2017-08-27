//
//  PMSocketClient.h
//  MyDreams
//
//  Created by Иван Ушаков on 02.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMBaseSocketClient.h"

@protocol PMSocketClient <NSObject, PMBaseSocketClient>
- (void)openSocketWithToken:(NSString *)token;
@end
