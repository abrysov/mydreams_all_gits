//
//  PMPhotoCollectionViewCell.h
//  MyDreams
//
//  Created by Иван Ушаков on 12.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMPhotoViewModel;

@interface PMPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic, readonly) UIImageView *photoImageView;
@property (strong, nonatomic) id<PMPhotoViewModel> viewModel;
@end
