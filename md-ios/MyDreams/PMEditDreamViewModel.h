//
//  PMEditDreamViewModel.h
//  MyDreams
//
//  Created by user on 25.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMEditDreamViewModel <NSObject>
@property (nonatomic, strong, readonly) UIImage *photo;
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, strong, readonly) NSString *dreamTitle;
@property (nonatomic, strong, readonly) NSString *dreamDescription;
@end