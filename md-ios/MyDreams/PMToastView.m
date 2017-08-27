//
//  PMToastVIew.m
//  MyDreams
//
//  Created by user on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMToastView.h"
#import "UIColor+MyDreams.h"

@interface PMToastView ()
@property (strong, nonatomic) RACDisposable *hideDisposable;
@end

@implementation PMToastView

- (instancetype)initWithTitle:(NSString *)title buttonCommand:(RACCommand *)command
{
    NSInteger width = [UIScreen mainScreen].bounds.size.width;
    NSInteger height = 36;

    if (self = [super init]) {
        self.backgroundColor = [UIColor toastViewColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
        }];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTintColor:[UIColor whiteColor]];
        [self addSubview: button];
        
        button.rac_command = command;
        
        @weakify(self);
        self.hideDisposable = [[RACScheduler mainThreadScheduler] afterDelay:5.0f schedule:^{
            @strongify(self);
            self.hideDisposable = nil;
            [self hideToast];
        }];
        
    }
    return self;
}

- (void)hideToast
{
    [self.hideDisposable dispose];
    [self removeFromSuperview];
}

@end
