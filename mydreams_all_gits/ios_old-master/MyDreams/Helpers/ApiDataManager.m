//
//  ApiDataManager.m
//  MyDreams
//
//  Created by Игорь on 02.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ApiDataManager.h"
#import "RESTJsonHelper.h"
#import "Constants.h"
#import "MDToast.h"
#import "Location.h"
#import "Flybook.h"
#import "Dream.h"
#import "User.h"
#import "Helper.h"
#import "Post.h"

@implementation Pager

- (Pager *)initWith:(NSInteger)page onpage:(NSInteger)onpage {
    Pager *pager = [[Pager alloc] init];
    pager.page = page;
    pager.onpage = onpage;
    return pager;
}

- (NSString *)urlPart {
    if (self.page > 0 && self.onpage > 0) {
        return [NSString stringWithFormat:@"page=%ld&onpage=%ld", (long)self.page, (long)self.onpage];
    }
    return nil;
}

@end

@implementation ApiDataManager

+ (NSString *)getToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"token"];
    return token;
}

+ (void)signup:(NSString *)email
      password:(NSString *)password
          name:(NSString *)name surname:(NSString *)surname
         phone:(NSString *)phone
           sex:(NSInteger)sex
      birthday:(NSDate *)birthday
      location:(NSInteger)location
       success:(void (^)(NSString *))success
         error:(void (^)(NSString *))error {
    
    NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
    [objDateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *birthdaystr = [objDateFormatter stringFromDate:birthday];
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_SIGNUP];
    NSDictionary *params = @{
                             @"email":email,
                             @"password":password,
                             @"name":name,
                             @"surname":surname,
                             @"phone":phone,
                             @"sex":sex > 0 ? @"1" : @"0",
                             @"birthday":birthdaystr,
                             @"location":[NSNumber numberWithInteger:location]
                             };
    [RESTJsonHelper makeJSONRequestPOST:uri token:nil json:params handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(@"");
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)login:(NSString *)login
     password:(NSString *)password
      success:(void (^)(NSString *))success
        error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_LOGIN];
    NSDictionary *params = @{@"password":password, @"login":login};
    [RESTJsonHelper makeJSONRequestPOST:uri token:nil json:params handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success([responseData.body objectForKey:@"token"]);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)flybook:(NSInteger)userId
        success:(void (^)(Flybook *))success
          error:(void (^)(NSString *))error {
    
    /*
    FlybookPhoto *p1 = [[FlybookPhoto alloc] init];
    p1.id = 1;
    p1.url = @"http://s00.yaplakal.com/pics/userpic/4/2/3/av-451324.jpg";
    p1.thumbUrl = @"http://s00.yaplakal.com/pics/userpic/4/2/3/av-451324.jpg";
    
    FlybookPhoto *p2 = [[FlybookPhoto alloc] init];
    p2.id = 2;
    p2.url = @"http://s00.yaplakal.com/pics/userpic/3/6/8/av-447863.jpg";
    p2.thumbUrl = @"http://s00.yaplakal.com/pics/userpic/3/6/8/av-447863.jpg";
    
    FlybookPhoto *p3 = [[FlybookPhoto alloc] init];
    p3.id = 3;
    p3.url = @"http://s00.yaplakal.com/pics/userpic/3/6/8/av-464863.jpg";
    p3.thumbUrl = @"http://s00.yaplakal.com/pics/userpic/3/6/8/av-464863.jpg";
    
    FlybookPhoto *p4 = [[FlybookPhoto alloc] init];
    p4.id = 3;
    p4.url = @"http://s00.yaplakal.com/pics/userpic/6/6/5/av-264566.jpg";
    p4.thumbUrl = @"http://s00.yaplakal.com/pics/userpic/6/6/5/av-264566.jpg";
    
    NSArray<FlybookPhoto> *photos = @[p1, p2, p3, p4];
     */
    ///
    
    
    
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?%@", SERVER_API_URL, API_METHOD_FLYBOOK, userId > 0 ? [NSString stringWithFormat:@"id=%ld", (long)userId] : @""];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        FlybookResponseModel *responseData = (FlybookResponseModel *)[ApiDataManager handleResponse:json responseError:err class:[FlybookResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            
            
            ///
            //responseData.flybook.photos = photos;
            //responseData.flybook.isVip = YES;
            ///
            
            
            success(responseData.flybook);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)findlocations:(NSString *)search
              country:(NSInteger)country
                  lat:(double)lat
                  lng:(double)lng
              success:(void (^)(NSArray<Location> *))success
                error:(void (^)(NSString *))error {
    
    NSString *encodedSearch = [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *countryFilter = country > 0 ? [NSString stringWithFormat:@"&country=%ld", (long)country] : @"";
    NSString *uri = [NSString stringWithFormat:@"%@%@?search=%@%@&lat=%f&lng=%f", SERVER_API_URL, API_METHOD_FINDLOCATIONS, encodedSearch, countryFilter, lat, lng];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        FindLocationsResponseModel *responseData = (FindLocationsResponseModel *)[ApiDataManager handleResponse:json responseError:err class:[FindLocationsResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.locations);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)countries:(NSString *)filter success:(void (^)(NSArray<Location> *))success error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_COUNTRIES];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        CountriesResponseModel *responseData = (CountriesResponseModel *)[ApiDataManager handleResponse:json responseError:err class:[CountriesResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.countries);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)flybooklist:(NSInteger)userId
             isdone:(BOOL)isdone
              pager:(Pager *)pager
            success:(void (^)(NSInteger total, NSArray<Dream> *))success
              error:(void (^)(NSString *))error {
    
    NSString *donePart = isdone ? @"isdone=1" : @"";
    NSString *userIdPart = userId > 0 ? [NSString stringWithFormat:@"id=%ld", (long)userId] : @"";
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?%@&%@&%@", SERVER_API_URL, API_METHOD_FLYBOOK_LIST, userIdPart, [pager urlPart], donePart];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamListResponseModel *responseData = (DreamListResponseModel *)[self handleResponse:json responseError:err class:[DreamListResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.dreams);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)dream:(NSInteger)dreamId
      success:(void (^)(Dream *))success
        error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?id=%ld", SERVER_API_URL, API_METHOD_DREAM, (long)dreamId];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamResponseModel *responseData = (DreamResponseModel *)[self handleResponse:json responseError:err class:[DreamResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.dream);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)addDream:(NSString *)name
     description:(NSString *)description
           image:(UIImage *)image
          isdone:(BOOL)isdone
         success:(void (^)(NSInteger id))success
           error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_ADDDREAM];
    NSDictionary *params = @{@"name": name,
                             @"description": description,
                             @"isdone": isdone ? @"1" : @"0"};
    
    NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
    if (image) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
        [files setObject:imgData forKey:@"image"];
    }
    
    [RESTJsonHelper makeMultipartRequest:uri token:[self getToken] json:params files:files handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success((NSInteger)[[responseData.body objectForKey:@"id"] floatValue]);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)updateDream:(NSInteger)dreamId
               name:(NSString *)name
        description:(NSString *)description
              image:(UIImage *)image
             isdone:(BOOL)isdone
            success:(void (^)(void))success
              error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_UPDATE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:dreamId],
                             @"name": name,
                             @"description": description,
                             @"isdone": isdone ? @"1" : @"0"};
    
    NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
    if (image) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
        [files setObject:imgData forKey:@"image"];
    }
    
    [RESTJsonHelper makeMultipartRequest:uri token:[self getToken] json:params files:files handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success();
        }
        else {
            error(errMsg);
        }
    }];
    
}

+ (void)dreamlikes:(NSInteger)dreamId
             pager:(Pager *)pager
           success:(void (^)(NSInteger total, NSArray<DreamLike> *))success
             error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?id=%ld&%@", SERVER_API_URL, API_METHOD_DREAM_LIKES, (long)dreamId, [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamLikesResponseModel *responseData = (DreamLikesResponseModel *)[self handleResponse:json responseError:err class:[DreamLikesResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.items);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)dreamstamps:(NSInteger)dreamId
              pager:(Pager *)pager
            success:(void (^)(NSInteger total, NSArray<DreamStamp> *))success
              error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?id=%ld&%@", SERVER_API_URL, API_METHOD_DREAM_STAMPS, (long)dreamId, [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamStampsResponseModel *responseData = (DreamStampsResponseModel *)[self handleResponse:json responseError:err class:[DreamStampsResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.items);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)dreamcomments:(NSInteger)dreamId
                pager:(Pager *)pager
              success:(void (^)(NSInteger total, NSArray<DreamComment> *))success
                error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?id=%ld&%@", SERVER_API_URL, API_METHOD_DREAM_COMMENTS, (long)dreamId, [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamCommentsResponseModel *responseData = (DreamCommentsResponseModel *)[self handleResponse:json responseError:err class:[DreamCommentsResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.items);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)friendsX:(Pager *)pager
        success:(void (^)(NSInteger total, NSArray<BasicUser> *))success
          error:(void (^)(NSString *))error {
    
    /*
     BasicUser *l1 = [[BasicUser alloc] init];
     l1.id = 1;
     l1.fullname = @"Александр";
     l1.avatarUrl = @"http://s00.yaplakal.com/pics/userpic/4/9/0/av-234094.jpg";
        l1.location = @"Москва"; l1.age = @"40";
    
    BasicUser *l6 = [[BasicUser alloc] init];
    l6.id = 2;
    l6.fullname = @"Алевтина К";
    l6.avatarUrl = @"http://s00.yaplakal.com/pics/userpic/4/2/3/av-451324.jpg";
    l6.location = @"Житомир"; l6.age = @"15";
    
     BasicUser *l2 = [[BasicUser alloc] init];
     l2.id = 2;
     l2.fullname = @"Андрей Иванов";
     l2.avatarUrl = @"http://s00.yaplakal.com/pics/userpic/6/6/5/av-264566.jpg";
    l2.location = @"Новгород"; l2.age = @"15";
     
     BasicUser *l3 = [[BasicUser alloc] init];
     l3.id = 1;
     l3.fullname = @"Кузнецов Иван";
     l3.avatarUrl = @"http://s00.yaplakal.com/pics/userpic/3/6/8/av-447863.jpg";
    l3.location = @"Казань"; l3.age = @"29";
     
     BasicUser *l4 = [[BasicUser alloc] init];
     l4.id = 1;
     l4.fullname = @"Кикабидзе вахтанг";
     l4.avatarUrl = @"http://s00.yaplakal.com/pics/userpic/1/6/9/av-447961.jpg";
    l4.location = @"Ереван"; l4.age = @"67";
     
     BasicUser *l5 = [[BasicUser alloc] init];
     l5.id = 1;
     l5.fullname = @"Енот полоскун";
     l5.avatarUrl = @"http://s00.yaplakal.com/pics/userpic/3/6/8/av-464863.jpg";
    l5.location = @"Вашингтон"; l5.age = @"12";
     
     NSArray *locs = @[l1, l6, l2, l3, l4, l5];
    
    success(5, locs);
     */
    
}

+ (void)users:(NSString *)apiMethod
        pager:(Pager *)pager
      success:(void (^)(NSInteger, NSArray<BasicUser> *))success
        error:(void (^)(NSString *))error {
    
     NSString *uri = [NSString stringWithFormat:@"%@%@?%@", SERVER_API_URL, apiMethod, [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        BasicUsersResponseModel *responseData = (BasicUsersResponseModel *)[self handleResponse:json responseError:err class:[BasicUsersResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.items);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)friends:(Pager *)pager
        success:(void (^)(NSInteger, NSArray<BasicUser> *))success
          error:(void (^)(NSString *))error {
    
    [self users:API_METHOD_PROFILE_FRIENDS pager:pager success:success error:error];
}

+ (void)subscribers:(Pager *)pager
            success:(void (^)(NSInteger, NSArray<BasicUser> *))success
              error:(void (^)(NSString *))error {
    
    [self users:API_METHOD_PROFILE_SUBSCRIBERS pager:pager success:success error:error];
}

+ (void)subscribed:(Pager *)pager
           success:(void (^)(NSInteger, NSArray<BasicUser> *))success
             error:(void (^)(NSString *))error {
    
    [self users:API_METHOD_PROFILE_SUBSCRIBED pager:pager success:success error:error];
}

+ (void)requests:(Pager *)pager
         success:(void (^)(NSInteger, NSArray<BasicUser> *))success
           error:(void (^)(NSString *))error {
    
    [self users:API_METHOD_PROFILE_REQUESTS pager:pager success:success error:error];
}

+ (void)subscribe:(NSInteger)userId
          success:(void (^)(void))success
            error:(void (^)(NSString *))error {
    
    [self friendaction:API_METHOD_PROFILE_SUBSCRIBE userId:userId success:success error:error];
}

+ (void)unsubscribe:(NSInteger)userId
            success:(void (^)(void))success
              error:(void (^)(NSString *))error {
    
    [self friendaction:API_METHOD_PROFILE_UNSUBSCRIBE userId:userId success:success error:error];
}

+ (void)requestfriendship:(NSInteger)userId
                  success:(void (^)(void))success
                    error:(void (^)(NSString *))error {
    
    [self friendaction:API_METHOD_PROFILE_REQUESTFRIENDSHIP userId:userId success:success error:error];
}

+ (void)acceptrequest:(NSInteger)userId
              success:(void (^)(void))success
                error:(void (^)(NSString *))error {
    
    [self friendaction:API_METHOD_PROFILE_ACCEPTREQUEST userId:userId success:success error:error];
}

+ (void)denyrequest:(NSInteger)userId
            success:(void (^)(void))success
              error:(void (^)(NSString *))error {
    
    [self friendaction:API_METHOD_PROFILE_DENYREQUEST userId:userId success:success error:error];
}

+ (void)unfriend:(NSInteger)userId
         success:(void (^)(void))success
           error:(void (^)(NSString *))error {
    
    [self friendaction:API_METHOD_PROFILE_UNFRIEND userId:userId success:success error:error];
}

+ (void)friendaction:(NSString *)apiMethod
              userId:(NSInteger)userId
         success:(void (^)(void))success
           error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, apiMethod];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:userId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)uploadavatar:(UIImage *)image
            success:(void (^)(NSString *))success
              error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_UPLOAD_AVATAR];
    
    NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
    if (image) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
        [files setObject:imgData forKey:@"image"];
    }
    
    [RESTJsonHelper makeMultipartRequest:uri token:[self getToken] json:nil files:files handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success((NSString *)[responseData.body objectForKey:@"avatarUrl"]);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)uploadphoto:(UIImage *)image
             success:(void (^)(NSInteger photoId, NSString *photoUrl))success
               error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_UPLOAD_PHOTO];
    
    NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
    if (image) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
        [files setObject:imgData forKey:@"image"];
    }
    
    [RESTJsonHelper makeMultipartRequest:uri token:[self getToken] json:nil files:files handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            NSDictionary *photo = (NSDictionary *)[responseData.body objectForKey:@"photo"];
            success([[photo objectForKey:@"id"] integerValue], (NSString *)[photo objectForKey:@"url"]);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)deletephotos:(NSArray *)photoIds
             success:(void (^)(void))success
               error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DELETE_PHOTO];
    NSDictionary *params = @{@"ids":[[NSArray alloc] initWithArray:photoIds copyItems:YES]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)profileupdate:(NSDictionary *)params success:(void (^)(NSString *))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_PROFILE_UPDATE];
    
    [RESTJsonHelper makeJSONRequestPOST:uri token:[self getToken] json:params handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.message);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)dreamtake:(NSInteger)dreamId success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_TAKE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:dreamId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)dreampropose:(NSInteger)dreamId toUser:(NSInteger)userId success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_PROPOSE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:dreamId],
                             @"userid":[NSNumber numberWithLong:userId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)dreamlike:(NSInteger)dreamId success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_LIKE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:dreamId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)dreamunlike:(NSInteger)dreamId success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_UNLIKE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:dreamId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)dreampostcomment:(NSInteger)dreamId text:(NSString *)text success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_POSTCOMMENT];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:dreamId],
                             @"text":text};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)dreamlikecomment:(NSInteger)commentId success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_LIKECOMMENT];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:commentId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)dreamunlikecomment:(NSInteger)commentId success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_UNLIKECOMMENT];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:commentId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)dreammarkdone:(NSInteger)dreamId isdone:(BOOL)isdone success:(void (^)(void))success error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_MARKDONE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:dreamId], @"done": isdone ? @"1" : @"0"};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)top:(Pager *)pager
    success:(void (^)(NSInteger total, NSArray<Dream> *))success
      error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?%@", SERVER_API_URL, API_METHOD_TOPDREAMS,[pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamListResponseModel *responseData = (DreamListResponseModel *)[self handleResponse:json responseError:err class:[DreamListResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.dreams);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)proposed:(Pager *)pager
         success:(void (^)(NSInteger total, NSArray<Dream> *))success
           error:(void (^)(NSString *))error {
    
       /* Dream *p1 = [[Dream alloc] init];
     p1.id = 3;
     p1.imageUrl = @"http://s00.yaplakal.com/pics/userpic/6/6/5/av-264566.jpg";
     p1.date = [[NSDate alloc] init];
     p1.name = @"Первый пост";
     p1.description_ = @"Moq – это простой и легковесный изоляционный фреймврк (Isolation Framework), который построен на основе анонимных методов и деревьев выражений. Для создания моков он использует кодогенерацию, поэтому позволяет «мокать» интерфейсы, виртуальные методы (и даже защищенные методы) и не позволяет «мокать» невиртуальные и статические методы. ";
     
     NSArray<Dream> *posts = @[p1];
     success(1, posts);
     return;*/
    

    
    NSString *uri = [NSString stringWithFormat:@"%@%@?%@", SERVER_API_URL, API_METHOD_DREAM_PROPOSED, [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamListResponseModel *responseData = (DreamListResponseModel *)[self handleResponse:json responseError:err class:[DreamListResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.dreams);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)eventfeed:(Pager *)pager
          success:(void (^)(NSInteger, NSArray<EventFeedItem> *))success
            error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?%@", SERVER_API_URL, API_METHOD_EVENTFEED, [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        EventFeedResponseModel *responseData = (EventFeedResponseModel *)[self handleResponse:json responseError:err class:[EventFeedResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.events);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)acceptproposed:(NSInteger)commentId success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_PROPOSEDACCEPT];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:commentId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)rejectproposed:(NSInteger)commentId success:(void (^)(void))success error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_DREAM_PROPOSEDREJECT];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:commentId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)findusers:(UserFilter *)filter
            pager:(Pager *)pager
          success:(void (^)(NSInteger, NSArray<BasicUser> *))success
            error:(void (^)(NSString *))error {
    
    NSString *filterUrlPart = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                               filter.country > 0 ? [NSString stringWithFormat:@"&country=%ld", filter.country] : @"",
                               filter.city > 0 ? [NSString stringWithFormat:@"&city=%ld", filter.city] : @"",
                               filter.age && [filter.age length] > 0 ? [NSString stringWithFormat:@"&age=%@", filter.age] : @"",
                               filter.sex && [filter.sex length] > 0 ? [NSString stringWithFormat:@"&sex=%@", filter.sex] : @"",
                               filter.popular ? [NSString stringWithFormat:@"&popular=%d", filter.popular] : @"",
                               filter.online ? [NSString stringWithFormat:@"&online=%d", filter.online] : @"",
                               filter.vip ? [NSString stringWithFormat:@"&vip=%d", filter.vip] : @"",
                               filter.isnew ? [NSString stringWithFormat:@"&new=%d", filter.isnew] : @""];
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?%@%@", SERVER_API_URL, API_METHOD_FINDUSERS, [pager urlPart], filterUrlPart];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        BasicUsersResponseModel *responseData = (BasicUsersResponseModel *)[self handleResponse:json responseError:err class:[BasicUsersResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.items);
        }
        else {
            error(errMsg);
        }
    }];

}

/* BLOG,POST */

+ (void)postlist:(NSInteger)userId
           pager:(Pager *)pager
         success:(void (^)(NSInteger total, NSArray<Post> *))success
           error:(void (^)(NSString *))error {
    
    
    /*Post *p1 = [[Post alloc] init];
    p1.id = 3;
    p1.imageUrl = @"http://s00.yaplakal.com/pics/userpic/6/6/5/av-264566.jpg";
    p1.date = [[NSDate alloc] init];
    p1.title = @"Первый пост";
    p1.description_ = @"Moq – это простой и легковесный изоляционный фреймврк (Isolation Framework), который построен на основе анонимных методов и деревьев выражений. Для создания моков он использует кодогенерацию, поэтому позволяет «мокать» интерфейсы, виртуальные методы (и даже защищенные методы) и не позволяет «мокать» невиртуальные и статические методы. ";
    
    NSArray<Post> *posts = @[p1];
    success(1, posts);
    return;*/
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?%@&%@", SERVER_API_URL, API_METHOD_BLOG_POSTLIST, userId > 0 ? [NSString stringWithFormat:@"id=%ld", (long)userId] : @"", [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        PostListResponseModel *responseData = (PostListResponseModel *)[self handleResponse:json responseError:err class:[PostListResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.posts);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)addpost:(NSString *)title
    description:(NSString *)description
          image:(UIImage *)image
        success:(void (^)(NSInteger id))success
          error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_BLOG_POSTADD];
    NSDictionary *params = @{@"title": title, @"description": description};
    
    NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
    if (image) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
        [files setObject:imgData forKey:@"image"];
    }
    
    [RESTJsonHelper makeMultipartRequest:uri token:[self getToken] json:params files:files handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success((NSInteger)[[responseData.body objectForKey:@"id"] floatValue]);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)updatepost:(NSInteger)postId
              name:(NSString *)title
       description:(NSString *)description
             image:(UIImage *)image
           success:(void (^)(void))success
             error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_BLOG_POSTUPDATE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:postId], @"name": title, @"description": description};
    
    NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
    if (image) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
        [files setObject:imgData forKey:@"image"];
    }
    
    [RESTJsonHelper makeMultipartRequest:uri token:[self getToken] json:params files:files handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success();
        }
        else {
            error(errMsg);
        }
    }];

}

+ (void)post:(NSInteger)postId
     success:(void (^)(Post *))success
       error:(void (^)(NSString *))error {
    
    /*Post *p1 = [[Post alloc] init];
    p1.id = 3;
    p1.imageUrl = @"http://s00.yaplakal.com/pics/userpic/6/6/5/av-264566.jpg";
    p1.date = [[NSDate alloc] init];
    p1.title = @"Первый пост";
    p1.description_ = @"Moq – это простой и легковесный изоляционный фреймврк (Isolation Framework), который построен на основе анонимных методов и деревьев выражений. Для создания моков он использует кодогенерацию, поэтому позволяет «мокать» интерфейсы, виртуальные методы (и даже защищенные методы) и не позволяет «мокать» невиртуальные и статические методы. ";
    success(p1);
    return;*/
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?id=%ld", SERVER_API_URL, API_METHOD_BLOG_POST, (long)postId];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        PostResponseModel *responseData = (PostResponseModel *)[self handleResponse:json responseError:err class:[PostResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.post);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)postlikes:(NSInteger)postId
            pager:(Pager *)pager
          success:(void (^)(NSInteger total, NSArray<DreamLike> *))success
            error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?id=%ld&%@", SERVER_API_URL, API_METHOD_BLOG_POSTLIKES, (long)postId, [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamLikesResponseModel *responseData = (DreamLikesResponseModel *)[self handleResponse:json responseError:err class:[DreamLikesResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.items);
        }
        else {
            error(errMsg);
        }
    }];
}

+ (void)postcomments:(NSInteger)postId
               pager:(Pager *)pager
             success:(void (^)(NSInteger total, NSArray<DreamComment> *))success
               error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@?id=%ld&%@", SERVER_API_URL, API_METHOD_BLOG_POSTCOMMENTS, (long)postId, [pager urlPart]];
    
    [RESTJsonHelper makeJSONRequestGET:uri token:[self getToken] handler:^(id json, NSString *err) {
        NSString *errMsg;
        DreamCommentsResponseModel *responseData = (DreamCommentsResponseModel *)[self handleResponse:json responseError:err class:[DreamCommentsResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success(responseData.total, responseData.items);
        }
        else {
            error(errMsg);
        }
    }];
    
}

+ (void)postpostcomment:(NSInteger)postId
                   text:(NSString *)text
                success:(void (^)(void))success
                  error:(void (^)(NSString *))error {
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_BLOG_POSTCOMMENT];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:postId],
                             @"text":text};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)postlike:(NSInteger)postId
         success:(void (^)(void))success
           error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_BLOG_POSTLIKE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:postId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)postunlike:(NSInteger)postId
           success:(void (^)(void))success
             error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_BLOG_POSTUNLIKE];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:postId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)postlikecomment:(NSInteger)commentId
                success:(void (^)(void))success
                  error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_BLOG_POSTLIKECOMMENT];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:commentId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

+ (void)postunlikecomment:(NSInteger)commentId
                  success:(void (^)(void))success
                    error:(void (^)(NSString *))error {
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, API_METHOD_BLOG_POSTUNLIKECOMMENT];
    NSDictionary *params = @{@"id":[NSNumber numberWithLong:commentId]};
    
    [self makeVoidPost:uri params:params success:success error:error];
}

/* * */

+ (void)makeVoidPost:(NSString *)uri params:(NSDictionary *)params success:(void (^)(void))success error:(void (^)(NSString *))error {
    [RESTJsonHelper makeJSONRequestPOST:uri token:[self getToken] json:params handler:^(id json, NSString *err) {
        NSString *errMsg;
        id <CommonResponse> responseData = [ApiDataManager handleResponse:json responseError:err class:[CommonResponseModel class] errMsg:&errMsg];
        if (responseData != nil && errMsg == nil) {
            success();
        }
        else {
            error(errMsg);
        }
    }];
}

+ (id)handleResponse:(id)json responseError:(NSString *)responseError class:(Class)class errMsg:(NSString **)errMsg {
    if (responseError != nil) {
        *errMsg = responseError;
    }
    else {
        id responseData = [ApiDataManager handleJSONResponse:json class:class error:errMsg];
        if (responseData != nil && *errMsg == nil) {
            return responseData;
        }
        else if (!*errMsg) {
            *errMsg = NSLocalizedString(@"_ERROR_DATA_NOT_RECEIVED", @"");
        }
    }
    return nil;
}

+ (id <CommonResponse> )handleJSONResponse:(id)json class:(Class)class error:(NSString **)err {
    NSError *jsonError = nil;
    id <CommonResponse> responseModel = (id <CommonResponse> )[[class alloc] initWithDictionary:json error:&jsonError];
    if (jsonError || !responseModel) {
        *err = NSLocalizedString(@"_ERROR_DATA_NOT_RECEIVED", @"");
        return nil;
    }
    NSString *message = responseModel.message;
    NSString *error = nil;
    switch (responseModel.code) {
        case 0:
            // все ок
            break;
            
        case 1:
            error = message;
            break;
            
        case 2:
        {
            // не авторизован
            [Helper clearAuthorized];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupNotAuthorizedNavigation];
        }
            break;
            
        default:
            break;
    }
    if (error != nil) {
        NSLog(@"json response error %@", error);
        if (err)
            *err = error;
    }
    return responseModel;
}

@end
