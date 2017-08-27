//
//  PMMarkWithPriceView.h
//  MyDreams
//
//  Created by user on 19.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PMMarkWithPriceViewState) {
    PMMarkWithPriceViewStateDefault,
    PMMarkWithPriceViewStateSelected,
};

@interface PMMarkWithPriceView : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBInspectable UIImage *mark;
@property (assign, nonatomic) PMMarkWithPriceViewState inputState;
@end
