//
//  PMLocalityViewModel.h
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMLocalityViewModel <NSObject>
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *descriptionLocality;
@end
