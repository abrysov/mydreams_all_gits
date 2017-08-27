//
//  DreamLikesUserCell.m
//  MyDreams
//
//  Created by Игорь on 20.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "CommentUserCell.h"
#import "UIHelpers.h"
#import "Helper.h"
#import "ApiDataManager.h"

@implementation CommentUserCell {
    DreamComment *dreamComment;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [UIHelpers setShadow:self.containerView];
    [self.avatarImageView.layer setCornerRadius:25];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)likeButtonTouch:(id)sender {
    if (dreamComment.isliked) {
        [ApiDataManager dreamunlikecomment:[dreamComment.id longValue] success:^{
            self.likeButton.alpha = 0.5;
            [self showAlert:@"_DREAM_UNLIKE_SUCCESS"];
            dreamComment.isliked = NO;
        } error:^(NSString *error) {
            //
        }];
    }
    else {
        [ApiDataManager dreamlikecomment:[dreamComment.id longValue] success:^{
            self.likeButton.alpha = 1.0;
            [self showAlert:@"_DREAM_LIKE_SUCCESS"];
            dreamComment.isliked = YES;
        } error:^(NSString *error) {
            //
        }];
    }
}

- (void)showAlert:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:[Helper localizedStringIfIsCode:title]
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil] show];
}

- (void)initWithUser:(BasicUser *)user {
    [Helper setImageView:self.avatarImageView withImageUrl:user.avatarUrl andDefault:@"_LOGO_IMAGE_BLUE"];

    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", user.fullname, user.age];
    self.subnameLabel.text = @"25.06.15 08:35";
    
    if (user.id % 2)
        self.commentLabel.text = @"В случае с Ambit3 всё иначе! Создатели часов решили, что принципиально новая внешность девайсу не нужна, ведь, философия этого гаджета выходит далеко за пределы навороченного корпуса";
    else
        self.commentLabel.text = @"У-у-у-у-у-у крутые часы!";
}

- (void)initWithComment:(DreamComment *)comment {
    dreamComment = comment;
    
    [Helper setImageView:self.avatarImageView withImageUrl:comment.user.avatarUrl andDefault:@"_LOGO_IMAGE_BLUE"];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", comment.user.fullname, comment.user.age];
    self.commentLabel.text = comment.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy, HH:mm"];
    self.subnameLabel.text = [dateFormatter stringFromDate:comment.date];
    
    if (![comment isliked]) {
        self.likeButton.alpha = 0.5;
    }
}

@end
