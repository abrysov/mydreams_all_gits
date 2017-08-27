//
//  PMDetailedPostPageVC.m
//  MyDreams
//
//  Created by user on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedPostVC.h"
#import "PMDetailedPostLogic.h"
#import "DreamTableViewCellStatisticView.h"
#import "SZTextView.h"
#import "PMNibManagement.h"
#import "PMCommentTableViewCell.h"
#import "UILabel+PM.h"
#import "UITableView+PM.h"

@interface PMDetailedPostVC ()
@property (strong, nonatomic) PMDetailedPostLogic *logic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *dreamerTopInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dreamerBottomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *photoActivity;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *likesView;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *commentsView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *showCommentsButton;
@property (weak, nonatomic) IBOutlet UILabel *writeCommentLabel;
@property (weak, nonatomic) IBOutlet SZTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *extraMenuBarButtonItem;
@end

@implementation PMDetailedPostVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    [self.tableView registerCellNIBForClass:[PMCommentTableViewCell class]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [PMCommentTableViewCell estimatedRowHeight];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    self.backBarButtonItem.rac_command = self.logic.backCommand;
	self.likesView.button.rac_command = self.logic.likesListCommand;//self.logic.likedCommand; FIXME: change back command
	
    @weakify(self);
    
    [[RACObserve(self.logic, viewModel) ignore:nil] subscribeNext:^(id<PMDetailedPostPageViewModel> viewModel) {
        @strongify(self);
        [self setupPostWithViewModel:viewModel];
        [self.tableView updateSectionSizeWithView:self.descriptionLabel section:self.tableView.tableHeaderView];
        [self.tableView reloadData];
    }];
    
    RAC(self.likesView, count) = [RACObserve(self.logic, viewModel.likesCount) ignore:nil];
    RAC(self.commentsView, count) = [RACObserve(self.logic, viewModel.commentsCount) ignore:nil];
    RAC(self.photoImageView, image) = [[[RACObserve(self.logic, viewModel.photo) skip:1]
        doNext:^(id photo) {
             @strongify(self);
            self.photoImageView.contentMode = photo ? UIViewContentModeScaleAspectFill : UIViewContentModeCenter;
            [self.photoActivity stopAnimating];
        }]
        filter:^BOOL(id value) {
            return value ? YES : NO;
        }];
    
    RAC(self.avatarImageView, image) = [[RACObserve(self.logic, viewModel.avatar) ignore:nil] doNext:^(id x) {
         @strongify(self);
        [self.avatarActivity stopAnimating];
    }];
    RAC(self.likesView, icon) = [RACObserve(self.logic, viewModel.likesViewIcon) ignore:nil];
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreambook.detailed_post.title", nil) uppercaseString];
    [self.showCommentsButton setTitle:[NSLocalizedString(@"dreambook.detailed_post.show_comments_button_title", nil) uppercaseString] forState:UIControlStateNormal];
    self.writeCommentLabel.text = [NSLocalizedString(@"dreambook.detailed_post.write_comment", nil) uppercaseString];
    [self.addCommentButton setTitle:NSLocalizedString(@"dreambook.detailed_post.add_comment_button_title", nil) forState:UIControlStateNormal];
    self.commentTextView.placeholder = NSLocalizedString(@"dreambook.detailed_post.new_comment_placeholder", nil);
}

- (IBAction)showExtraMenu:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *editingPostAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.detailed_post.editing_post", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.logic.toEditingPostCommand execute:nil];
        }];
        
    [alertController addAction:editingPostAction];
    
    UIAlertAction *deletePostAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.detailed_post.delete_post", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.logic.deletePostCommand execute:nil];
        }];
        
    [alertController addAction:deletePostAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.detailed_post.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIView *)viewForStatesViewsConstraints
{
    return self.tableView;
}

#pragma mark - PMRefreshableController

- (UIScrollView *)refreshableScrollView
{
    return self.tableView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self.logic setupComment:textView.text];
    [self.tableView updateSectionSizeWithView:textView section:self.tableView.tableFooterView];
}

#pragma mark - private

- (void)setupPostWithViewModel:(id<PMDetailedPostPageViewModel>) viewModel
{
    self.dreamerTopInfoLabel.text = viewModel.dreamerTopInfo;
    self.dreamerBottomInfoLabel.text = viewModel.dreamerBottomInfo;
    [self.dreamerBottomInfoLabel boldSubstring:viewModel.age];
    self.timeLabel.text = viewModel.date;
    self.descriptionLabel.text = viewModel.details;
    self.commentsCountLabel.text = viewModel.descriptionCommentCount;
    if (!viewModel.isMine) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

@end
