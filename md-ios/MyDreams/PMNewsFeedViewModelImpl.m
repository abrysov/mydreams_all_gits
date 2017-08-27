//
//  PMNewsFeedViewModelImpl.m
//  MyDreams
//
//  Created by user on 04.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMNewsFeedViewModelImpl.h"

@interface PMNewsFeedViewModelImpl ()
@property (strong, nonatomic) NSString *postsCount;
@end

@implementation PMNewsFeedViewModelImpl

- (void)setPostsCountInteger:(NSUInteger)postsCountInteger
{
    self->_postsCountInteger = postsCountInteger;
    self.postsCount = [NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"news.news_feed.latest_news", nil), (unsigned long)postsCountInteger];
}

@end
