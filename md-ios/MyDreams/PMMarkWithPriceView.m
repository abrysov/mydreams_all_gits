//
//  PMMarkWithPriceView.m
//  MyDreams
//
//  Created by user on 19.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMMarkWithPriceView.h"

@interface PMMarkWithPriceView ()
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@end

@implementation PMMarkWithPriceView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
        [self addSubview:view];
        
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setMark:(UIImage *)mark
{
    if (self->_mark != mark) {
        self->_mark = mark;
        self.markImageView.image = mark;
    }
}

- (void)setInputState:(PMMarkWithPriceViewState)inputState
{
    switch (inputState) {
        case PMMarkWithPriceViewStateSelected:{
            @weakify(self);
            [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.edges.equalTo(self.markImageView.superview);
            }];
            break;
        }
        case PMMarkWithPriceViewStateDefault:
        default:
            [self.markImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
            break;
    }
}

@end
