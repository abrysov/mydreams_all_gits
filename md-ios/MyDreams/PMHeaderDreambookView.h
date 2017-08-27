//
//  PMHeaderDreambookView.h
//  MyDreams
//
//  Created by user on 18.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookHeaderViewModel.h"
#import "PMStatusTextField.h"

typedef NS_ENUM(NSUInteger, PMImageSelectorType) {
    PMImageSelectorTypeNone,
    PMImageSelectorTypeAvatar,
    PMImageSelectorTypeBackground
};

@protocol PMDreambookChangeImagesDelegate
- (void)changeImage:(PMImageSelectorType)type;
@end

@interface PMHeaderDreambookView : UIView
@property (strong ,nonatomic) id <PMDreambookHeaderViewModel> viewModel;
@property (strong, nonatomic) RACCommand *changeStatusCommand;
@property (strong, nonatomic) RACCommand *leftButtonCommand;
@property (strong, nonatomic) RACCommand *rightButtonCommand;
@property (strong, nonatomic) RACCommand *createPostCommand;
@property (strong, nonatomic) RACCommand *toSectionCommand;
@property (weak, nonatomic) IBOutlet PMStatusTextField *statusTextField;
@property (weak, nonatomic) IBOutlet UIView *photosView;
@property (weak, nonatomic) id<PMDreambookChangeImagesDelegate> delegate;
@end