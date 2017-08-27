//
//  PostMainViewController.m
//  MyDreams
//
//  Created by Игорь on 08.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "PostMainViewController.h"
#import "SimpleUserCell.h"
#import "CommonSearchViewController.h"
#import "ApiDataManager.h"
#import "Helper.h"
#import "UIHelpers.h"
#import "Constants.h"

@interface PostMainViewController ()

@end

@implementation PostMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = @"-";
    self.textLabel.text = @"-";
    self.dateLabel.text = @"-";
    
    [self initUIWith:self.post];
}

- (void)initUIWith:(Post *)post_ {
    self.nameLabel.text = post_.title;
    self.textLabel.text = post_.description_;
    
    if ([Helper profileUserId] == post_.owner.id) {
        self.likeButton.hidden = YES;
    }
    else {
        
    }
    
    if (![post_ isliked]) {
        
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy, hh:mm"];
    self.dateLabel.text = [dateFormatter stringFromDate:post_.date];
    
    NSString *dummyImageName = self.post.owner.isVip ? @"dummy-purple" : @"dummy-blue";
    [Helper setImageView:self.imageView withImageUrl:post_.imageUrl andDefault:dummyImageName];
    
    UIImage *likeBtnImage = [UIImage imageNamed:post_.owner.isVip ? @"like-purple" : @"like-blue"];
    [self.likeButton setImage:likeBtnImage forState:UIControlStateNormal];
    
    [self fitContentView];
}


- (IBAction)likeButtonTouch:(id)sender {
    if (self.post.isliked) {
        [ApiDataManager postunlike:self.post.id success:^{
            self.post.isliked = NO;
            [self showAlert:@"_DREAM_UNLIKE_SUCCESS"];
            [self.delegate needUpdateTabs:self];
            //((UIButton *)sender).alpha = 0.9;
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
    else {
        [ApiDataManager postlike:self.post.id success:^{
            self.post.isliked = YES;
            [self showAlert:@"_DREAM_LIKE_SUCCESS"];
            [self.delegate needUpdateTabs:self];
            //((UIButton *)sender).alpha = 1.0;
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    }
}

@end
