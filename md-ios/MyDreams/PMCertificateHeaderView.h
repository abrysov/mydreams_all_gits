//
//  PMCertificateHeaderView.h
//  MyDreams
//
//  Created by Alexey Yakunin on 18/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMNibLinkableView.h"

@interface PMCertificateHeaderView : PMNibLinkableView

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) NSInteger likesCount;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, assign) NSInteger launchesCount;

@end
