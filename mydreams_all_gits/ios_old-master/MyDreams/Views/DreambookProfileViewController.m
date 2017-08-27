//
//  DreambookProfileViewController.m
//  MyDreams
//
//  Created by Игорь on 07.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "DreambookProfileViewController.h"
#import "ProposedDreamsViewController.h"
#import "FlybookProfileCell.h"
#import "MWPhotoBrowser.h"
#import "ProposedCell.h"
#import "Constants.h"

@interface DreambookProfileViewController ()

@end

@implementation DreambookProfileViewController {
    BOOL showProposedCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FlybookProfileCell" bundle:nil] forCellReuseIdentifier:@"FlybookProfileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FlybookProfileGuestCell" bundle:nil] forCellReuseIdentifier:@"FlybookProfileGuestCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProposedCell" bundle:nil] forCellReuseIdentifier:@"ProposedCell"];

    showProposedCell = self.profile.proposed > 0;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)update {
    showProposedCell = self.profile.proposed > 0;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        NSString *cellId = @"FlybookProfileCell";//isSelf ? @"FlybookProfileCell" : @"FlybookProfileGuestCell";
        FlybookProfileCell *profileCell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
        if (profileCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            profileCell = [nib objectAtIndex:0];
        }
        
        [profileCell initUIWith:self.profile];
        
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startGallery:)];
        [profileCell.avatarImageView addGestureRecognizer:tapAvatar];
        
        cell = profileCell;
    }
    else if (indexPath.row == 1 && showProposedCell) {
        ProposedCell *proposedCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProposedCell class])];
        if (proposedCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProposedCell class]) owner:self options:nil];
            proposedCell = [nib objectAtIndex:0];
        }
        
        [proposedCell initUIWith:self.profile.proposed appearence:self.profile.isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE];
        [proposedCell initHiding:self action:@selector(hideProposed)];
        [proposedCell initGoProposed:self action:@selector(goProposed)];
        cell = proposedCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return showProposedCell && indexPath.row == 1 ? 96 : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return showProposedCell && indexPath.row == 1 ? 96 : 1200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return showProposedCell ? 2 : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)startGallery:(Flybook *)profile {
    if ([self numberOfPhotosInPhotoBrowser:nil] == 0) {
        return;
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.profile.photos count] + ((self.profile.avatarUrl && [self.profile.avatarUrl length] > 0) ? 1 : 0);
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index >= [self numberOfPhotosInPhotoBrowser:nil]) {
        return nil;
    }
    
    NSInteger photosOffset = self.profile.avatarUrl && [self.profile.avatarUrl length] > 0 ? 1 : 0;
    
    NSString *imageUrl;
    if (index == 0 && photosOffset > 0) {
        imageUrl = self.profile.avatarUrl;
    }
    else {
        FlybookPhoto *photo = [self.profile.photos objectAtIndex:index - photosOffset];
        imageUrl = photo.url;
    }
    NSString *fullUrl = ([[imageUrl substringToIndex:4] isEqualToString:@"http"])
    ? imageUrl
    : [NSString stringWithFormat:@"%@%@", SERVER_URL, imageUrl];
    return [[MWPhoto alloc] initWithURL:[NSURL URLWithString:fullUrl]];
}

- (void)hideProposed {
    if (showProposedCell) {
        showProposedCell = false;
        
        NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)goProposed {
    ProposedDreamsViewController *proposedDreamsViewController = [[ProposedDreamsViewController alloc] initWithNibName:@"ProposedDreamsViewController" bundle:nil];
    proposedDreamsViewController.tabsDelegate = self.tabsDelegate;
    [self.navigationController pushViewController:proposedDreamsViewController animated:YES];
}

@end
