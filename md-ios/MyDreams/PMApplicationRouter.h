//
//  PMApplicationRouter.h
//  MyDreams
//
//  Created by Иван Ушаков on 15.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMMenuItem.h"

@protocol PMApplicationRouter <NSObject>
@property (assign, nonatomic, readonly) PMMenuItem selectedMenuItem;

- (void)openURL:(NSURL *)url;

- (void)openAuthVC;
- (void)openUserBlockedVC;
- (void)openUserDeletedVC;

- (void)openMainVC;
- (void)openMenuItem:(PMMenuItem)menuItem;
@end
