//
//  CommonResponseModel.h
//  Unicom
//
//  Created by Игорь on 18.01.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "JSONModel.h"

@protocol CommonResponse
@property (assign, nonatomic) NSInteger code;
@property (retain, nonatomic) NSString <Optional> *message;
@property (retain, nonatomic) NSDictionary <Optional> *body;
@end

@interface CommonResponseModel : JSONModel<CommonResponse>
@property (assign, nonatomic) NSInteger code;
@property (retain, nonatomic) NSString <Optional> *message;
@property (retain, nonatomic) NSDictionary <Optional> *body;
@end

