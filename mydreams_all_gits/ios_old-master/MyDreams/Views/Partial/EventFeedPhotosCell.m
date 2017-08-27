//
//  EventFeedPhotosViewCell.m
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "EventFeedPhotosCell.h"
#import "Helper.h"
#import "UIHelpers.h"

@implementation EventFeedPhotosCell

- (void)awakeFromNib {
    [UIHelpers setShadow:self.containerView];
    [self.avatarImageView.layer setCornerRadius:25];
}

- (void)initUIWith:(EventFeedItem *)event {
    [Helper setImageView:self.avatarImageView withImageUrl:event.user.avatarUrl andDefault:@"_LOGO_IMAGE_BLUE"];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", event.user.fullname, event.user.age];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy, HH:mm"];
    self.subnameLabel.text = [dateFormatter stringFromDate:event.date];
    
    [[self.photosContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (event.photos) {
        if (event.photos) {
            self.commentLabel.text = nil;
            
            [self setupPhotos:@[event.photos]];
        }
    }
    else {
        self.photosContainerHeight.constant = 0;
        self.commentLabel.text = event.text;
    }
}

- (void)layoutSubviews {
    //CGFloat containerWidth = self.photosContainer.frame.size.width;
    //[super layoutSubviews];
    //CGFloat containerWidth2 = self.photosContainer.frame.size.width;
}

- (void)setupPhotos:(NSArray *)photos {
    NSInteger totalPhotos = [photos count];
    NSInteger photosPerRow = 3;
    CGFloat padding = 20;
    CGFloat containerWidth = self.photosContainer.frame.size.width;
    CGFloat onePhotoCellWidth = (containerWidth - (photosPerRow - 1) * padding) / photosPerRow;
    
    for (int i = 0; i < totalPhotos; i++) {
        NSInteger rowNumber = i / photosPerRow;
        NSInteger cellNumber = i % photosPerRow;
        CGRect frame = CGRectMake(cellNumber * (onePhotoCellWidth + padding), rowNumber * (onePhotoCellWidth), onePhotoCellWidth, onePhotoCellWidth);
        id photo = [photos objectAtIndex:i];
        [self insertPhoto:photo rect:frame];
    }
    
    NSInteger totalRows = ceil((float)totalPhotos / photosPerRow);
    self.photosContainerHeight.constant = totalRows * (onePhotoCellWidth);
    [self.contentView layoutIfNeeded];
}

- (void)insertPhoto:(FlybookPhoto *)photo rect:(CGRect)rect {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.tag = photo.id;
    imageView.clipsToBounds = YES;
    
    [Helper setImageView:imageView withImageUrl:photo.url andDefault:@"_LOGO_IMAGE_BLUE"];
    
    [self.photosContainer addSubview:imageView];
    
    //    UITapGestureRecognizer *selectFilter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPhotoTouch:)];
    //    [imageView addGestureRecognizer:selectFilter];
}

@end
