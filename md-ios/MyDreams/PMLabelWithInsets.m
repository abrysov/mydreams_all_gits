//
//  PMStatusLabel.m
//  MyDreams
//
//  Created by user on 05.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLabelWithInsets.h"

@interface PMLabelWithInsets ()
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

@implementation PMLabelWithInsets

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
    self.edgeInsets = UIEdgeInsetsMake(self.insetHeight, self.insetWidth, self.insetHeight, self.insetWidth);
    CGSize size = [super intrinsicContentSize];
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

@end
