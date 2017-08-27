//
//  PMImageDownloader.h
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMImageDownloader <NSObject>
- (RACSignal *)imageForURL:(NSURL *)url;
@end
