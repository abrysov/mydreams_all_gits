//
//  ActionUserCell.m
//  MyDreams
//
//  Created by Игорь on 20.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "ActionUserCell.h"
#import "SimpleUserCell.h"
#import "Helper.h"
#import "UIHelpers.h"
#import "ApiDataManager.h"

@implementation ActionUserCell {
    BasicUser *user;
    NSString *mode;
    NSMutableDictionary *modes;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [UIHelpers setShadow:self.containerView];
    [self.avatarImageView.layer setCornerRadius:25];
    
    self.button1.hidden = YES;
    self.button1.enabled = NO;
    self.button2.hidden = YES;
    self.button2.enabled = NO;
    self.button3.hidden = YES;
    self.button3.enabled = NO;
    
    modes = [[NSMutableDictionary alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)getAlertConfirmation:(NSInteger)tag {
    NSString *action = [modes objectForKey:[NSNumber numberWithLong:tag]];
    
    if ([action isEqualToString:@"unfriend"]) {
        return @"Удалить из друзей?";
    }
    else if ([action isEqualToString:@"requestfriendship"]) {
        return nil;
    }
    else if ([action isEqualToString:@"acceptrequest"]) {
        return nil;
    }
    else if ([action isEqualToString:@"denyrequest"]) {
        return @"Отклонить заявку?";
    }
    else if ([action isEqualToString:@"subscribe"]) {
        return nil;
    }
    else if ([action isEqualToString:@"unsubscribe"]) {
        return @"Отписаться?";
    }
    return nil;
}

- (IBAction)button1Touch:(id)sender {
    [self doButtonTouch:1];
}

- (IBAction)button2Touch:(id)sender {
    [self doButtonTouch:2];
}

- (IBAction)button3Touch:(id)sender {
    [self doButtonTouch:3];
}

- (void)doButtonTouch:(NSInteger)tag {
    NSString *confirmation = [self getAlertConfirmation:tag];
    if (confirmation) {
        [self showConfirmation:confirmation tag:tag];
    }
    else {
        NSString *action = [modes objectForKey:[NSNumber numberWithLong:tag]];
        [self doAction:action];
    }
}

- (void)showConfirmation:(NSString *)title tag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[Helper localizedStringIfIsCode:title]
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:[Helper localizedString:@"_NO"]
                                         otherButtonTitles:[Helper localizedString:@"_YES"], nil];
    alert.tag = tag;
    [alert show];
}

- (void)showAlert:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:[Helper localizedStringIfIsCode:title]
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)initWithUser:(BasicUser *)user_ andMode:(NSString *)mode_ {
    user = user_;
    mode = mode_;
    
    [Helper setImageView:self.avatarImageView withImageUrl:user.avatarUrl andDefault:@"_LOGO_IMAGE_BLUE"];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", user.fullname, user.age];
    self.subnameLabel.text = user.location;
    
    [self setupButtons];
}

- (void)setupButtons {
    if ([mode isEqualToString:@"friends"]) {
        [self setButtonState:self.button1 title:@"Убрать из друзей" index:1 action:@"unfriend"];
        [self setSubscribtionButton:self.button2 index:2];
    }
    else if ([mode isEqualToString:@"subscribers"]) {
        [self setFriendButton:self.button1 index:1];
        [self setSubscribtionButton:self.button2 index:2];
    }
    else if ([mode isEqualToString:@"subscribed"]) {
        [self setRequestButton:self.button1 index:1];
        [self setSubscribtionButton:self.button2 index:2];
    }
    else if ([mode isEqualToString:@"requests"]) {
        [self setButtonState:self.button1 title:@"Принять заявку" index:1 action:@"acceptrequest"];
        [self setButtonState:self.button2 title:@"Отклонить заявку" index:2 action:@"denyrequest"];
        //[self setSubscribtionButton:self.button3 index:3];
    }
}

- (void)setButtonState:(UIButton *)button
            title:(NSString *)title
            index:(NSInteger)index
           action:(NSString *)action {
    
    [button setTitle:[title uppercaseString] forState:UIControlStateNormal];
    button.hidden = NO;
    button.enabled = YES;
    [modes setObject:action forKey:[NSNumber numberWithLong:index]];
}

- (void)setFriendButton:(UIButton *)button index:(NSInteger)index {
    if (user.friend) {
        [self setButtonState:button title:@"Убрать из друзей" index:index action:@"unfriend"];
    }
    else {
        [self setButtonState:button title:@"Добавить в друзья" index:index action:@"requestfriendship"];
    }
}

- (void)setSubscribtionButton:(UIButton *)button index:(NSInteger)index {
    if (user.subscribed) {
        [self setButtonState:button title:@"Отписаться" index:index action:@"unsubscribe"];
    }
    else {
        [self setButtonState:button title:@"Подписаться" index:index action:@"subscribe"];
    }
}

- (void)setRequestButton:(UIButton *)button index:(NSInteger)index {
    if (user.friendshipRequestSended) {
        [self setButtonState:button title:@"Отменить заявку" index:index action:@"denyrequest"];
    }
    else {
        [self setButtonState:button title:@"Добавить в друзья" index:index action:@"requestfriendship"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *action = [modes objectForKey:[NSNumber numberWithLong:alertView.tag]];
        [self doAction:action];
    }
}

- (void)doAction:(NSString *)action {
    if ([action isEqualToString:@"unfriend"]) {
        [ApiDataManager unfriend:user.id success:^{
            [self showAlert:@"Друг удален"];
            [self.delegate needUpdateTabs:nil];
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
    else if ([action isEqualToString:@"requestfriendship"]) {
        [ApiDataManager requestfriendship:user.id success:^{
            [self showAlert:@"Заявка отправлена"];
            [self.delegate needUpdateTabs:nil];
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
    else if ([action isEqualToString:@"acceptrequest"]) {
        [ApiDataManager acceptrequest:user.id success:^{
            [self showAlert:@"Заявка принята"];
            [self.delegate needUpdateTabs:nil];
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
    else if ([action isEqualToString:@"denyrequest"]) {
        [ApiDataManager denyrequest:user.id success:^{
            [self showAlert:@"Заявка отклонена"];
            [self.delegate needUpdateTabs:nil];
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
    else if ([action isEqualToString:@"unsubscribe"]) {
        [ApiDataManager unsubscribe:user.id success:^{
            [self showAlert:@"Вы отписались"];
            [self.delegate needUpdateTabs:nil];
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
    else if ([action isEqualToString:@"subscribe"]) {
        [ApiDataManager subscribe:user.id success:^{
            [self showAlert:@"Вы подписались!"];
            [self.delegate needUpdateTabs:nil];
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
}

@end
