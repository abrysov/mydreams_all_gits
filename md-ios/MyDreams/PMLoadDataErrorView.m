//
//  PMBlankStateView.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLoadDataErrorView.h"

@interface PMLoadDataErrorView ()
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation PMLoadDataErrorView

- (void)setIsTransparent:(BOOL)isTransparent
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textLabel.textColor = [UIColor whiteColor];
}

- (void)setErrorString:(NSString *)errorString
{
    self.textLabel.text = errorString;
}

- (NSString *)errorString
{
    return self.textLabel.text;
}

- (void)setRac_command:(RACCommand *)rac_command
{
    self.reloadButton.rac_command = rac_command;
}

- (RACCommand *)rac_command
{
    return self.reloadButton.rac_command;
}

@end
