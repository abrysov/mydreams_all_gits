//
//  UITableView+PM.m
//  MyDreams
//
//  Created by user on 26.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "UITableView+PM.h"

@implementation UITableView (PM)

- (void)updateSectionSizeWithView:(UIView *)view section:(UIView *)section
{
    CGFloat heightDif = [view intrinsicContentSize].height - view.bounds.size.height;
    if (heightDif > 0) {
        CGRect sectionFrame = section.frame;
        sectionFrame.size.height = sectionFrame.size.height + heightDif;
        
        CGSize tableViewContentSize = self.contentSize;
        tableViewContentSize.height = tableViewContentSize.height + heightDif;
        
        self.contentSize = tableViewContentSize;
        section.frame = sectionFrame;
    }
}

@end
