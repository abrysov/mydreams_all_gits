//
//  PMSearchDreamView.h
//  MyDreams
//
//  Created by Anatoliy Peshkov on 22/06/2016.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMNibLinkableView.h"

@interface PMSearchView : PMNibLinkableView

- (void)establishChannelToTextWithTerminal:(RACChannelTerminal *)otherTerminal;
@property (strong,nonatomic) NSString* placeholder;

@end
