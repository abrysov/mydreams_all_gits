//
//  PMFastLinksLogic.h
//  MyDreams
//
//  Created by Иван Ушаков on 17.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMMenuItem.h"

@protocol PMApplicationRouter;

@interface PMFastLinksLogic : PMBaseLogic
@property (strong, nonatomic) id<PMApplicationRouter> router;
@property (assign, nonatomic, readonly) PMMenuItem selectedMenuItem;

- (void)openMenuItem:(PMMenuItem)menuItem;

@end
