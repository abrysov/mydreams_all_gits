//
//  PMFiltersDreamersViewModel.h
//  MyDreams
//
//  Created by user on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMFiltersDreamersViewModel <NSObject>
@property (strong, nonatomic, readonly) NSString *nameCountry;
@property (strong, nonatomic, readonly) NSString *nameCity;
@property (strong, nonatomic, readonly) NSString *totalResult;
@property (assign, nonatomic, readonly) BOOL notFound;
@property (assign, nonatomic, readonly) BOOL isNew;
@property (assign, nonatomic, readonly) BOOL isPopular;
@property (assign, nonatomic, readonly) BOOL isVip;
@property (assign, nonatomic, readonly) BOOL isOnline;
@end
