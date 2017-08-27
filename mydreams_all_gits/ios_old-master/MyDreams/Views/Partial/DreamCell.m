//
//  DreamCell.m
//  MyDreams
//
//  Created by Игорь on 13.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "DreamCell.h"
#import "Helper.h"
#import "Constants.h"
#import "UIHelpers.h"

@implementation DreamCell {
    NSInteger dreamId;
    AppearenceStyle appearenceStyle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    appearenceStyle = AppearenceStyleBLUE;
    
    [UIHelpers setShadow:self.containerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)initUIWith:(Dream *)dream andAppearence:(AppearenceStyle)appearence {
//    if (dreamId == dream.id) {
//        NSLog(@"Same cell reused");
//        return;
//    }
    
    [self setAppearence:appearence];
    
    dreamId = dream.id;
    
    self.nameLabel.text = dream.name;
    self.descriptionLabel.text = dream.description_;
    self.launchesLabel.text = [NSString stringWithFormat:@"%ld", [dream.stamps longValue]];
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", [dream.likes longValue]];
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", [dream.comments longValue]];
    
    NSString *dummyImageName = appearence == AppearenceStyleGREEN
    ? @"dummy-green" : (appearence == AppearenceStylePURPLE
                        ? @"dummy-purple" : @"dummy-blue");
    [Helper setImageView:self.imageView_ withImageUrl:dream.imageUrl andDefault:dummyImageName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy, HH:mm"];
    self.dateLabel.text = [dateFormatter stringFromDate:dream.date];
}

- (void)setAppearence:(AppearenceStyle)appearence {
    if (appearence == AppearenceStyleNONE) {
        return;
    }
    
    if (appearenceStyle == appearence) {
        return;
    }
    
    appearenceStyle = appearence;
    
    if (appearence == AppearenceStylePURPLE) {
        self.launchesIcon.image = [UIImage imageNamed:@"space-ship2-purple"];
        self.likesIcon.image = [UIImage imageNamed:@"heart297-purple"];
        self.commentsIcon.image = [UIImage imageNamed:@"citation-purple"];
        
        self.launchesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_PURPLE];
        self.likesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_PURPLE];
        self.commentsLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_PURPLE];
    }
    else if (appearence == AppearenceStyleDBLUE) {
        self.launchesIcon.image = [UIImage imageNamed:@"space-ship2-dblue"];
        self.likesIcon.image = [UIImage imageNamed:@"heart297-dblue"];
        self.commentsIcon.image = [UIImage imageNamed:@"citation-dblue"];
        
        self.launchesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_DBLUE];
        self.likesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_DBLUE];
        self.commentsLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_DBLUE];
    }
    else {
        self.launchesIcon.image = [UIImage imageNamed:@"space-ship2-blue"];
        self.likesIcon.image = [UIImage imageNamed:@"heart297-blue"];
        self.commentsIcon.image = [UIImage imageNamed:@"citation-blue"];
        
        self.launchesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_BLUE];
        self.likesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_BLUE];
        self.commentsLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_BLUE];
    }
}

@end
