//
//  TabView.m
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "TabView.h"

@implementation TabView {
    id<TabProtocol> observer;
    UIColor *activeColor;
    UIColor *inactiveColor;
}

- (void)awakeFromNib {
    activeColor = self.tabNameLabel.textColor;
    inactiveColor = [activeColor colorWithAlphaComponent:0.5];
}

- (void)setupWithIndex:(NSInteger)index_ andObserver:(id<TabProtocol>)observer_ {
    self.index = index_;
    observer = observer_;
    
    UITapGestureRecognizer *tabSelect = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(tabSelected)];
    [self addGestureRecognizer:tabSelect];
    self.userInteractionEnabled = YES;
}

- (void)tabSelected {
    [observer tabSelect:self.index];
}

- (void)setSelected {
    self.tabBorder.hidden = NO;
    self.tabNameLabel.textColor = activeColor;
}

- (void)setDeselected {
    self.tabBorder.hidden = YES;
    self.tabNameLabel.textColor = inactiveColor;
}

+ (TabView *)addToContainer:(UIView *)container name:(NSString *)tabName offset:(CGFloat)offset {
    TabView *tab = [[[NSBundle mainBundle]
                     loadNibNamed:@"TabView" owner:nil options:nil] objectAtIndex:0];
    tab.tabNameLabel.text = [tabName uppercaseString];
    CGSize textSize = [tab.tabNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[tab.tabNameLabel font]}];
    // ширина таба - ширина текста + 2 констреинта
    tab.frame = CGRectMake(offset, 0, ceil(textSize.width + 16), tab.frame.size.height);
    [container addSubview:tab];
    return tab;
}

+ (void)fittingSize {
    
}

@end
