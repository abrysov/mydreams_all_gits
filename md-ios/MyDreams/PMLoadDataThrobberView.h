//
//  PMLoadDataThrobberView.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMLoadDataThrobberView : UIView
@property (assign, nonatomic) BOOL isTransparent;
- (void)startAnimation;
- (void)stopAnimation;
@end
