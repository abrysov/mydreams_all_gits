//
//  CellFilterView.m
//  MyDreams
//
//  Created by user on 04.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "CellFilterView.h"

@interface CellFilterView ()
@property (weak, nonatomic) IBOutlet UIImageView *fillIconImageView;
@end

@implementation CellFilterView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
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

- (void)setInputState:(CellFilterViewState)state
{
    switch (state) {
        case CellFilterViewStateActive:
            [self applyActiveInputState];
            break;
        case CellFilterViewStateInactive:
        default:
            [self applyInactiveInputState];
            break;
    }
}

- (void)applyActiveInputState
{
    self.fillIconImageView.hidden = NO;
}

- (void)applyInactiveInputState
{
    self.fillIconImageView.hidden = YES;
}

@end
