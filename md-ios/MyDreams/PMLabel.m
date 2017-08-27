//
//  PMLabel.m
//  MyDreams
//
//  Created by Иван Ушаков on 04.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLabel.h"
#import <objc/runtime.h>

@implementation PMLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setText:self.text];
}

- (void)setText:(NSString *)text
{
    if (self.characterSpacing != 0) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName: @(self.characterSpacing),
                                                                                                  NSFontAttributeName: self.font,
                                                                                                  NSForegroundColorAttributeName: self.textColor}];
        self.attributedText = string;
    }
}

- (NSString *)text
{
    return self.attributedText.string;
}

#pragma mark - Properties

- (void)setCharacterSpacing:(CGFloat)characterSpacing
{
    objc_setAssociatedObject(self, @selector(characterSpacing), @(characterSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)characterSpacing
{
    NSNumber *number = (NSNumber*)objc_getAssociatedObject(self, @selector(characterSpacing));
#if CGFLOAT_IS_DOUBLE
    return [number doubleValue];
#else
    return [number floatValue];
#endif
}

@end
