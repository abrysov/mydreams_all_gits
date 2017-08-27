//
//  PMNetworkErrorMapper.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMNetworkErrorMapper <NSObject>
- (NSError *)mapNetworkError:(NSError *)error;
@end
