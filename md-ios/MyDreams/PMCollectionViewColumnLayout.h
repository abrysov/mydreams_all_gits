//
//  PMCollectionViewThreeColumnLayout.h
//  MyDreams
//
//  Created by Иван Ушаков on 12.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMCollectionViewColumnLayout : UICollectionViewFlowLayout
@property (assign, nonatomic) IBInspectable NSUInteger columnCount;
- (void)setup NS_REQUIRES_SUPER;
@end
