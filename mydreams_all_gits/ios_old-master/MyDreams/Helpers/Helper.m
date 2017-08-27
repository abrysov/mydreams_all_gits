//
//  Shared.m
//  Unicom
//
//  Created by Игорь on 15.01.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import <Foundation/Foundation.h>
#import "Helper.h"
#import "Constants.h"


@implementation Helper

+ (NSString *)authorizedToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"token"];
}

+ (BOOL)isAuthorized {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"authorized"];
}

+ (NSInteger)profileUserId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:@"userid"];
}

+ (NSString *)profileEmail {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"email"];
}

+ (NSString *)profileFullname {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"fullname"];
}

+ (NSString *)profileAvatarUrl {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"avatarurl"];
}

+ (BOOL)profileIsVip {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"isvip"];
}

+ (void)updateProfile:(Flybook *)profile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithLong:profile.id] forKey:@"userid"];
    [defaults setValue:profile.email forKey:@"email"];
    [defaults setValue:[NSString stringWithFormat:@"%@ %@", profile.name, profile.surname] forKey:@"fullname"];
    [defaults setValue:profile.avatarUrl forKey:@"avatarurl"];
    [defaults setValue:[NSString stringWithFormat:@"%d", profile.isVip] forKey:@"isvip"];
}

+ (void)clearAuthorized {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"authorized"];
    [defaults removeObjectForKey:@"userid"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"fullname"];
    [defaults removeObjectForKey:@"avatarurl"];
    [defaults removeObjectForKey:@"isvip"];
}

+ (BOOL)promoSaw {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"promosaw_%ld", (long)[Helper profileUserId]];
    return [defaults boolForKey:key];
}

+ (void)setPromoSaw:(BOOL)saw {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"promosaw_%ld", (long)[Helper profileUserId]];
    [defaults setBool:YES forKey:key];
}

+ (BOOL)needsUpdate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"needsupdate"];
}

+ (void)setNeedsUpdate:(BOOL)needs {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:needs forKey:@"needsupdate"];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (bool)isMatchRegex:(NSString *)pattern targetString:(NSString *)string {
    //NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"%@", pattern];
    //return [emailTest evaluateWithObject:string];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    return match ? YES : NO;
}

+ (NSString *)localizedString:(NSString *)code {
    return NSLocalizedString(code, @"");
}

+ (NSString *)localizedStringIfIsCode:(NSString *)codeOrString {
    if (codeOrString && [codeOrString characterAtIndex:0] == '_') {
        return NSLocalizedString(codeOrString, @"");
    }
    return codeOrString;
}

+ (NSString *)localizedStringWithDeclension:(NSString *)codeOrString number:(NSInteger)number {
    NSString *string = [self localizedStringIfIsCode:codeOrString];
    NSArray *words = [string componentsSeparatedByString:@"|"];
    return [NSString stringWithFormat:[self declensionOfNumber:number forWords:words], number];
}

+ (NSString *)declensionOfNumber:(NSInteger)number forWords:(NSArray*)words {
    if (number == 0)
        return words[0];
    if (number > 20)
        number %= 10;
    if (number == 1)
        return [words objectAtIndex:1];
    if (number >= 2 && number <= 4)
        return [words objectAtIndex:2];
    return [words objectAtIndex:3];
}

+ (NSDate *)getDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [calendar dateFromComponents:components];
}

+ (void)loadImageFrom:(NSString *)imageUrl complete:(void (^)(NSData *))callback {
    NSURL *url = ([[imageUrl substringToIndex:4] isEqualToString:@"http"])
        ? [NSURL URLWithString:imageUrl]
        : [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, imageUrl]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(imageData);
        });
    });
}

+ (void)setImageView:(UIImageView *)imageView withImageUrl:(NSString *)imageUrl andDefault:(NSString *)defaultImageName {
    NSURL *url = ([[imageUrl substringToIndex:4] isEqualToString:@"http"])
        ? [NSURL URLWithString:imageUrl]
        : [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, imageUrl]];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:[Helper localizedStringIfIsCode:defaultImageName]] options:SDWebImageRefreshCached];
}

+ (void)clearImageForUrl:(NSString *)imageUrl {
    NSString *url = ([[imageUrl substringToIndex:4] isEqualToString:@"http"])
        ? imageUrl
        : [NSString stringWithFormat:@"%@%@", SERVER_URL, imageUrl];
    [[SDImageCache sharedImageCache] removeImageForKey:url];
}

+ (UIImage *)resizeImageToMaxDimension:(UIImage *)image dimension:(NSInteger)dimension {
    CGFloat maxDimension = MAX(image.size.width * image.scale, image.size.height * image.scale);
    if (maxDimension <= dimension) {
        return image;
    }
    
    CGFloat scale = dimension / maxDimension;
    if (scale > 1.0) {
        scale = 1.0;
    }
    CGFloat newWidth = image.size.width * scale;
    CGFloat newHeight = image.size.height * scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSInteger)getAge:(NSDate *)birthDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear
                                                        fromDate:birthDate
                                                          toDate:[NSDate date]
                                                         options:NSCalendarWrapComponents];
    return [components year];
}

@end