//
//  ProposedCell.m
//  MyDreams
//
//  Created by Игорь on 17.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "ProposedCell.h"
#import "UIHelpers.h"
#import "Constants.h"
#import "Helper.h"

@implementation ProposedCell {
    
}

- (void)awakeFromNib {
    [self.proposedContainer.layer setCornerRadius:3];
    
    // бордер для "ссылки"
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.proposedFormatLabel.frame.size.height - 2, 200, 1.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.proposedFormatLabel.layer addSublayer:bottomBorder];
    self.proposedFormatLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)initUIWith:(NSInteger)proposed appearence:(AppearenceStyle)appearence {
    if (proposed > 0) {
        self.proposedFormatLabel.text = [Helper localizedStringWithDeclension:@"_FLYBOOK_PROPOSED_DECLENSION" number:proposed];
    }
    self.proposedContainer.backgroundColor = AppearenceStylePURPLE == appearence ? [Helper colorWithHexString:COLOR_STYLE_PURPLE] : [Helper colorWithHexString:COLOR_STYLE_BLUE];
    self.diamondIconImage.image = [UIImage imageNamed:AppearenceStylePURPLE == appearence ? @"diamond-purple" : @"diamond-blue"];
}

- (void)initHiding:(id)target action:(SEL)action; {
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self.proposedCloseView addGestureRecognizer:singleFingerTap];
    self.proposedCloseView.userInteractionEnabled = YES;
}

- (void)initGoProposed:(id)target action:(SEL)action; {
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self.proposedFormatLabel addGestureRecognizer:singleFingerTap];
    self.proposedFormatLabel.userInteractionEnabled = YES;
}

@end
