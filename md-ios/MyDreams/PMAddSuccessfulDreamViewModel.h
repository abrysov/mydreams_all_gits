//
//  PMAddSuccessfulDreamViewModel.h
//  MyDreams
//
//  Created by user on 17.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMAddSuccessfulDreamViewModel <NSObject>
@property (nonatomic, strong, readonly) UIImage *photo;
@property (nonatomic, assign) CGFloat progress;
@end
