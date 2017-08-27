//
//  Helper.h
//  Unicom
//
//  Created by Игорь on 15.01.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#ifndef Unicom_Shared_h
#define Unicom_Shared_h

#import <UIKit/UIKit.h>
#import "Flybook.h"

@interface Helper : NSObject

+ (NSString *)authorizedToken;
+ (BOOL)isAuthorized;
+ (NSInteger)profileUserId;
+ (NSString *)profileEmail;
+ (NSString *)profileFullname;
+ (NSString *)profileAvatarUrl;
+ (BOOL)profileIsVip;
+ (void)updateProfile:(Flybook *)profile;
+ (void)clearAuthorized;

+ (BOOL)needsUpdate;
+ (void)setNeedsUpdate:(BOOL)needs;


+ (BOOL)promoSaw;
+ (void)setPromoSaw:(BOOL)saw;

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (bool)isMatchRegex:(NSString *)pattern targetString:(NSString *)string;
+ (NSString *)localizedString:(NSString *)code;
+ (NSString *)localizedStringIfIsCode:(NSString *)codeOrString;
+ (NSString *)localizedStringWithDeclension:(NSString *)codeOrString number:(NSInteger)number;
+ (NSDate *)getDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (void)loadImageFrom:(NSString *)imageUrl complete:(void (^)(NSData *))callback;
+ (void)setImageView:(UIImageView *)imageView withImageUrl:(NSString *)imageUrl andDefault:(NSString *)defaultImageName;
+ (void)clearImageForUrl:(NSString *)imageUrl;
+ (UIImage *)resizeImageToMaxDimension:(UIImage *)image dimension:(NSInteger)dimension;
+ (NSInteger)getAge:(NSDate *)birthDate;

@end



#endif
