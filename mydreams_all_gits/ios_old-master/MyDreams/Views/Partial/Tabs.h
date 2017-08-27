//
//  Tabs.h
//  MyDreams
//
//  Created by Игорь on 23.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#ifndef MyDreams_Tabs_h
#define MyDreams_Tabs_h

typedef void (^TabsDelegateBlock)(NSInteger selectedTabIndex, NSInteger previousTabIndex);


@protocol TabProtocol

- (void)tabSelect:(NSInteger)tabIndex;

@end

#endif
