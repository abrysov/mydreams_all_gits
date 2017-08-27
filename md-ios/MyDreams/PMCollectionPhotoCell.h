//
//  PMCollectionPhotoCell.h
//  MyDreams
//
//  Created by user on 07.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMPhotoViewModel.h"

@interface PMCollectionPhotoCell : UICollectionViewCell
@property (strong, nonatomic) id<PMPhotoViewModel> viewModel;
@property (weak, nonatomic, readonly) UIImageView *photoImageView;
@end
