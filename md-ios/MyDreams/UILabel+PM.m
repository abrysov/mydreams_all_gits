//
//  UILabel+PM.m
//  MyDreams
//
//  Created by user on 04.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "UILabel+PM.h"

@implementation UILabel (PM)

- (void)boldRange:(NSRange)range
{
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    
    self.attributedText = attributedText;
}

- (void)boldSubstring:(NSString *)substring
{
    if(!substring) {
        return;
    }
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}

@end
