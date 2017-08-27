//
//  PMCertificateDetailViewModelImpl.m
//  MyDreams
//
//  Created by Alexey Yakunin on 20/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificateDetailViewModelImpl.h"
#import "PMCertificateType.h"
#import <SORelativeDateTransformer/SORelativeDateTransformer.h>

@interface PMCertificateDetailViewModelImpl ()
@property (assign, nonatomic) BOOL isNeedToShowGiftBy;
@property (strong, nonatomic) NSString* title;
@property (assign, nonatomic) NSUInteger likesCount;
@property (assign, nonatomic) NSUInteger commentsCount;
@property (assign, nonatomic) NSUInteger launchesCount;
@property (strong, nonatomic) UIImage *certificateImage;
@property (strong, nonatomic) NSString* numberOfLaunches;
@property (strong, nonatomic) NSString* wish;
@property (strong, nonatomic) NSString* dreamerTopInfo;
@property (strong, nonatomic) NSString* dreamerBottomInfo;
@property (strong, nonatomic) NSString* date;
@end

@implementation PMCertificateDetailViewModelImpl

- (instancetype)initWithCertificate:(PMCertificate *)certificate
{
	self = [super init];
	if (self)
	{
		self.isNeedToShowGiftBy = (certificate.giftedBy != nil);

		PMDream* dream = certificate.certifiable;
		self.title = dream.title;
		self.likesCount = dream.likesCount;
		self.launchesCount = dream.launchesCount;
		self.commentsCount = dream.commentsCount;

		self.dreamerTopInfo = [self dreamerTopInfoWithDreamer:certificate.giftedBy];
		self.dreamerBottomInfo = [self dreamerBottomInfoWithDreamer:certificate.giftedBy];
		self.wish = certificate.wish;
		
		self.date =  [[SORelativeDateTransformer registeredTransformer] transformedValue:certificate.createdAt];

		//TODO: Find better place for this switch (3th use)
		switch (certificate.certificateType) {
			case PMDreamCertificateTypeBronze:
				self.certificateImage = [UIImage imageNamed:@"bronze_mark"];
				break;
			case PMDreamCertificateTypeGold:
				self.certificateImage = [UIImage imageNamed:@"gold_mark"];
				break;
			case PMDreamCertificateTypePlatinum:
				self.certificateImage = [UIImage imageNamed:@"platinum_mark"];
				break;
			case PMDreamCertificateTypeSilver:
				self.certificateImage = [UIImage imageNamed:@"silver_mark"];
				break;
			case PMDreamCertificateTypeVIP:
				self.certificateImage = [UIImage imageNamed:@"vip_mark"];
				break;
			case PMDreamCertificateTypeImperial:
			case PMDreamCertificateTypeMyDreams:
			case PMDreamCertificateTypePresidential:
			case PMDreamCertificateTypeUnknown:
			default:
				self.certificateImage = [UIImage imageNamed:@"vip_mark"];
				break;
		}

		self.numberOfLaunches = [NSString stringWithFormat:@"%lu", (long)[certificate.launchesCount integerValue]];
	}
	return self;
}

- (NSString *)dreamerTopInfoWithDreamer:(PMDreamer *)dreamer
{
	NSString *result = @"";
	result = [self stringFromString:result byAppendingComponent:dreamer.fullName];
	result = [self stringFromString:result byAppendingComponent:[self ageFromBirthday:dreamer.birthday]];
	return result;
}

- (NSString *)dreamerBottomInfoWithDreamer:(PMDreamer *)dreamer
{
	NSString *result = @"";
	result = [self stringFromString:result byAppendingComponent:dreamer.country.name];
	result = [self stringFromString:result byAppendingComponent:dreamer.city.name];
	return result;
}


- (NSString *)stringFromString:(NSString *)string byAppendingComponent:(NSString *)componnet
{
	if (componnet && ![componnet isEqual:[NSNull null]]) {
		if (string.length > 0) {
			string = [string stringByAppendingString:@", "];
		}
		string = [string stringByAppendingString:componnet];
	}
	
	return string;
}

- (NSString *)ageFromBirthday:(NSDate *)birthday;
{
	if (!birthday) {
		return nil;
	}
	
	NSDate* now = [NSDate date];
	NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
									   components:NSCalendarUnitYear
									   fromDate:birthday
									   toDate:now
									   options:0];
	
	NSInteger age = [ageComponents year];
	
	return [NSString stringWithFormat:@"%lu", (long)age];
}

@end
