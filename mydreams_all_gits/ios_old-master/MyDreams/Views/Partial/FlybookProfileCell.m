//
//  FlybookProfileCell.m
//  MyDreams
//
//  Created by Игорь on 13.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "FlybookProfileCell.h"
#import "Helper.h"
#import "Constants.h"

@implementation FlybookProfileCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.contentView.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.contentView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.contentView.layer setShadowOpacity:0.2];
    [self.contentView.layer setShadowRadius:0.4];
    self.contentView.layer.shouldRasterize = YES;
    self.contentView.layer.rasterizationScale = UIScreen.mainScreen.scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)initUIWith:(Flybook *)flybook {
    self.isVipImageView.hidden = !flybook.isVip;
    
    [Helper setImageView:self.avatarImageView withImageUrl:flybook.avatarUrl andDefault:(flybook.isVip ? @"dummy-purple": @"dummy-blue")];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.isVipImageView.image = [UIImage imageNamed:flybook.isVip ? @"vip-purple" : @"vip-blue"];
    
    self.diamondIconImage.image = [UIImage imageNamed:flybook.isVip ? @"diamond-purple" : @"diamond-blue"];
    self.markerIconImage.image = [UIImage imageNamed:flybook.isVip ? @"map-marker-purple" : @"map-marker-blue"];
    self.userIconImage.image = [UIImage imageNamed:flybook.isVip ? @"account-purple" : @"account-blue"];
    self.quoteIconImage.image = [UIImage imageNamed:flybook.isVip ? @"format-quote-purple" : @"format-quote-blue"];
    
    self.diamondLabel.text = [NSString stringWithFormat:@"%ld/%ld", [flybook.dreams longValue], [flybook.dreamsComplete longValue]];
    
    NSInteger age = 0;
    if (flybook.birthdate) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate *birthdate = [format dateFromString:flybook.birthdate];
        age = [Helper getAge:birthdate];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@%@%@",
                           flybook.name,
                           [flybook.surname length] > 0 ? @" " : @"",
                           flybook.surname,
                           age > 0 ? [NSString stringWithFormat:@", %ld", age] : @""];
    
    self.locationLabel.text = flybook.location;
    
    if (!flybook.quote || [flybook.quote length] == 0) {
        self.quoteLabel.text = nil;
    }
    else {
        self.quoteLabel.text = flybook.quote;
    }
    
    self.friendsLabel.text = [Helper localizedStringWithDeclension:@"_FLYBOOK_FRIENDS_DECLENSION" number:[flybook.friends longValue]];
    self.friendsCountLabel.text = [NSString stringWithFormat:@"%ld", [flybook.friends longValue]];
    
    self.subscribersLabel.text = [Helper localizedStringWithDeclension:@"_FLYBOOK_SUBSCRIBERS_DECLENSION" number:[flybook.subscribers longValue]];
    self.subscribersCountLabel.text = [NSString stringWithFormat:@"%ld", [flybook.subscribers longValue]];
    
    self.launchesLabel.text = [Helper localizedStringWithDeclension:@"_FLYBOOK_LAUNCHES_DECLENSION" number:[flybook.launches longValue]];
    self.launchesCountLabel.text = [NSString stringWithFormat:@"%ld", [flybook.launches longValue]];
}

@end
