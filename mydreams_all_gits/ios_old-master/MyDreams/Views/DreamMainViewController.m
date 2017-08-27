//
//  DreamViewController.m
//  MyDreams
//
//  Created by Игорь on 18.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "DreamMainViewController.h"
#import "SimpleUserCell.h"
#import "CommonSearchViewController.h"
#import "ApiDataManager.h"
#import "Helper.h"
#import "UIHelpers.h"
#import "Constants.h"

@interface DreamMainViewController ()

@end

@implementation DreamMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = @"-";
    self.textLabel.text = @"-";
    self.dateLabel.text = @"-";
    
    [self initUIWith:self.dream];
}

//- (void)performLoading {
//    [ApiDataManager dream:self.dreamId success:^(Dream *dream_) {
//        dream = dream_;
//        [self initUIWith:dream_];
//    } error:^(NSString *error) {
//        [self showAlert:error];
//    }];
//}

- (void)initUIWith:(Dream *)dream_ {
    self.nameLabel.text = dream_.name;
    self.textLabel.text = dream_.description_;
    
    if (dream_.isdone) {
        self.giftButton.hidden = YES;
    }
    
    if ([Helper profileUserId] == dream_.owner.id) {
        self.likeButton.hidden = YES;
    }
    else {
        
    }
    
    if (![dream_ isliked]) {
        //self.likeButton.alpha = 0.9;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy, hh:mm"];
    self.dateLabel.text = [dateFormatter stringFromDate:dream_.date];
    
    NSString *dummyImageName = dream_.owner.isVip ? @"dummy-purple" : @"dummy-blue";
    [Helper setImageView:self.imageView withImageUrl:dream_.imageUrl andDefault:dummyImageName];
    
    UIImage *likeBtnImage = [UIImage imageNamed:dream_.owner.isVip ? @"like-purple" : @"like-blue"];
    [self.likeButton setImage:likeBtnImage forState:UIControlStateNormal];
    
    [self fitContentView];
}

//- (IBAction)proposeTouch:(id)sender {
//    [self presentSearchFriendsViewController];
//}


- (IBAction)likeButtonTouch:(id)sender {
    if (self.dream.isliked) {
        [ApiDataManager dreamunlike:self.dream.id success:^{
            self.dream.isliked = NO;
            [self showAlert:@"_DREAM_UNLIKE_SUCCESS"];
            [self.delegate needUpdateTabs:self];
            //((UIButton *)sender).alpha = 0.9;
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
    else {
        [ApiDataManager dreamlike:self.dream.id success:^{
            self.dream.isliked = YES;
            [self showAlert:@"_DREAM_LIKE_SUCCESS"];
            [self.delegate needUpdateTabs:self];
            //((UIButton *)sender).alpha = 1.0;
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
}

- (IBAction)giftTouch:(id)sender {
    [self showAlert:@"coming soon"];
}


@end
