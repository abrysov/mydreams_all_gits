//
//  PostCell.m
//  MyDreams
//
//  Created by Игорь on 08.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "PostCell.h"
#import "Helper.h"
#import "Constants.h"
#import "UIHelpers.h"

@implementation PostCell {
    NSInteger postId;
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

- (void)initUIWith:(Post *)post andAppearence:(AppearenceStyle)appearence {
//    if (postId == post.id) {
//        NSLog(@"Same cell reused");
//        return;
//    }
    
    [self setAppearence:appearence];
    
    postId = post.id;
    
    self.nameLabel.text = post.title;
    self.descriptionLabel.text = post.description_;
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", [post.likes longValue]];
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", [post.comments longValue]];
    
    NSString *dummyImageName = appearence == AppearenceStyleGREEN
    ? @"dummy-green" : (appearence == AppearenceStylePURPLE
                        ? @"dummy-purple" : @"dummy-blue");
    [Helper setImageView:self.imageView_ withImageUrl:post.imageUrl andDefault:dummyImageName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy, HH:mm"];
    self.dateLabel.text = [dateFormatter stringFromDate:post.date];
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
        self.likesIcon.image = [UIImage imageNamed:@"heart297-purple"];
        self.commentsIcon.image = [UIImage imageNamed:@"citation-purple"];
        
        self.likesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_PURPLE];
        self.commentsLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_PURPLE];
    }
    else if (appearence == AppearenceStyleDBLUE) {
        self.likesIcon.image = [UIImage imageNamed:@"heart297-dblue"];
        self.commentsIcon.image = [UIImage imageNamed:@"citation-dblue"];
        
        self.likesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_DBLUE];
        self.commentsLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_DBLUE];
    }
    else {
        self.likesIcon.image = [UIImage imageNamed:@"heart297-blue"];
        self.commentsIcon.image = [UIImage imageNamed:@"citation-blue"];
        
        self.likesLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_BLUE];
        self.commentsLabel.textColor = [Helper colorWithHexString:COLOR_STYLE_BLUE];
    }
}

@end
