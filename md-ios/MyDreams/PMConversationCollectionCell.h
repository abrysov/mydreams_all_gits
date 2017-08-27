//
//  PMConversationCollectionCell.h
//  MyDreams
//
//  Created by Alexey Yakunin on 29/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMConversationViewModel;
#import "PMSwipeableCollectionViewCell.h"

@interface PMConversationCollectionCell : PMSwipeableCollectionViewCell

@property (strong, nonatomic) id<PMConversationViewModel> viewModel;
@property (strong, nonatomic) RACCommand* detailsCommnad;
@end
