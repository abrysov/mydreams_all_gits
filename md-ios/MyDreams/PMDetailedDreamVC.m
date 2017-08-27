//
//  PMDetailedDreamVC.m
//  MyDreams
//
//  Created by user on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedDreamVC.h"
#import "PMDetailedDreamLogic.h"
#import "DreamTableViewCellStatisticView.h"
#import "SZTextView.h"
#import "PMNibManagement.h"
#import "PMCommentTableViewCell.h"
#import "UILabel+PM.h"
#import "UITableView+PM.h"

@interface PMDetailedDreamVC ()
@property (strong, nonatomic) PMDetailedDreamLogic *logic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *photoActivity;
@property (weak, nonatomic) IBOutlet UILabel *dreamTitleLabel;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *launchesCountView;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *likesCountView;
@property (weak, nonatomic) IBOutlet UILabel *dreamerTopInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dreamerBottomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarActivity;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *commentsCountView;
@property (weak, nonatomic) IBOutlet UILabel *dreamDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *giveButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *showCommentsButton;
@property (weak, nonatomic) IBOutlet UILabel *writeCommentLabel;
@property (weak, nonatomic) IBOutlet SZTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *extraMenuBarButtonItem;
@end

@implementation PMDetailedDreamVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    [self.tableView registerCellNIBForClass:[PMCommentTableViewCell class]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [PMCommentTableViewCell estimatedRowHeight];
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    self.likesCountView.button.rac_command = self.logic.likedCommand;
    
    @weakify(self);
    
    [[RACObserve(self.logic, viewModel) ignore:nil] subscribeNext:^(id<PMDetailedDreamViewModel> viewModel) {
        @strongify(self);
        [self setupDreamWithViewModel:viewModel];
        [self.tableView updateSectionSizeWithView:self.dreamDescriptionLabel section:self.tableView.tableHeaderView];
        [self.tableView reloadData];
    }];
    
    RAC(self.likesCountView, count) = [RACObserve(self.logic, viewModel.likesCount) ignore:nil];
    RAC(self.commentsCountView, count) = [RACObserve(self.logic, viewModel.commentsCount) ignore:nil];
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
    
    RAC(self.likesCountView, icon) = [RACObserve(self.logic, viewModel.likesViewIcon) ignore:nil];
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreambook.detailed_dream.title", nil) uppercaseString];
    [self.showCommentsButton setTitle:[NSLocalizedString(@"dreambook.detailed_dream.show_comments_button_title", nil) uppercaseString] forState:UIControlStateNormal];
    self.writeCommentLabel.text = [NSLocalizedString(@"dreambook.detailed_dream.write_comment", nil) uppercaseString];
    [self.addCommentButton setTitle:NSLocalizedString(@"dreambook.detailed_dream.add_comment_button_title", nil) forState:UIControlStateNormal];
    self.commentTextView.placeholder = NSLocalizedString(@"dreambook.detailed_dream.new_comment_placeholder", nil);
    [self.shareButton setTitle:NSLocalizedString(@"dreambook.detailed_dream.share_button_title", nil) forState:UIControlStateNormal];
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

- (IBAction)showExtraMenu:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *privacyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.detailed_dream.privacy", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:privacyAction];
    
    UIAlertAction *editingDreamAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.detailed_dream.editing_dream", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.logic.toEditingDreamCommand execute:nil];
    }];
    
    [alertController addAction:editingDreamAction];
    
    UIAlertAction *deleteDreamAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.detailed_dream.delete_dream", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.logic.deleteDreamCommand execute:nil];
    }];
    
    [alertController addAction:deleteDreamAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.detailed_dream.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setupDreamWithViewModel:(id<PMDetailedDreamViewModel>) viewModel
{
    self.dreamTitleLabel.text = viewModel.dreamTitle;
    self.dreamerTopInfoLabel.text = viewModel.dreamerTopInfo;
    self.dreamerBottomInfoLabel.text = viewModel.dreamerBottomInfo;
    [self.dreamerBottomInfoLabel boldSubstring:viewModel.age];
    self.timeLabel.text = viewModel.date;
    self.dreamDescriptionLabel.text = viewModel.details;
    self.commentsCountLabel.text = viewModel.descriptionCommentCount;
    if (viewModel.isMine) {
        [self.giveButton setTitle:NSLocalizedString(@"dreambook.detailed_dream.buy_mark_button_title", nil) forState:UIControlStateNormal];
        [self.addButton setTitle:NSLocalizedString(@"dreambook.detailed_dream.completed_dream_button_title", nil) forState:UIControlStateNormal];
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
        [self.giveButton setTitle:NSLocalizedString(@"dreambook.detailed_dream.give_button_title", nil) forState:UIControlStateNormal];
        [self.addButton setTitle:NSLocalizedString(@"dreambook.detailed_dream.add_button_title", nil) forState:UIControlStateNormal];
    }
}

-(IBAction)prepareForUnwindDetailedDream1:(UIStoryboardSegue *)segue {}

@end
