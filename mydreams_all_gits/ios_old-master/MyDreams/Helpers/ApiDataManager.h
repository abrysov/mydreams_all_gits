//
//  ApiDataManager.h
//  MyDreams
//
//  Created by Игорь on 02.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#ifndef MyDreams_ApiDataManager_h
#define MyDreams_ApiDataManager_h

#import <UIKit/UIKit.h>
#import "Flybook.h"
#import "Location.h"
#import "Dream.h"
#import "User.h"
#import "DreamLike.h"
#import "DreamComment.h"
#import "DreamStamp.h"
#import "EventFeed.h"
#import "UserFilter.h"
#import "Post.h"

@interface Pager : NSObject

@property NSInteger page;
@property NSInteger onpage;

- (Pager *)initWith:(NSInteger)page onpage:(NSInteger)onpage;
- (NSString *)urlPart;

@end


@interface ApiDataManager : NSObject

+ (void)signup:(NSString *)email
      password:(NSString *)password
          name:(NSString *)name surname:(NSString *)surname
         phone:(NSString *)phone
           sex:(NSInteger)sex
      birthday:(NSDate *)birthday
      location:(NSInteger)location
       success:(void (^)(NSString *))success
         error:(void (^)(NSString *))error;

+ (void)login:(NSString *)login
     password:(NSString *)password
      success:(void (^)(NSString *))success
        error:(void (^)(NSString *))error;

+ (void)flybook:(NSInteger)userId
        success:(void (^)(Flybook *))success
          error:(void (^)(NSString *))error;

+ (void)findlocations:(NSString *)search
              country:(NSInteger)country
                  lat:(double)lat
                  lng:(double)lng
              success:(void (^)(NSArray<Location> *))success
                error:(void (^)(NSString *))error;

+ (void)countries:(NSString *)filter
          success:(void (^)(NSArray<Location> *))success
            error:(void (^)(NSString *))error;

+ (void)flybooklist:(NSInteger)userId
            isdone:(BOOL)isdone
              pager:(Pager *)pager
            success:(void (^)(NSInteger total, NSArray<Dream> *))success
              error:(void (^)(NSString *))error;

+ (void)addDream:(NSString *)name
     description:(NSString *)description
           image:(UIImage *)image
          isdone:(BOOL)isdone
         success:(void (^)(NSInteger id))success
           error:(void (^)(NSString *))error;

+ (void)updateDream:(NSInteger)dreamId
               name:(NSString *)name
        description:(NSString *)description
              image:(UIImage *)image
             isdone:(BOOL)isdone
            success:(void (^)(void))success
              error:(void (^)(NSString *))error;

+ (void)dream:(NSInteger)dreamId
      success:(void (^)(Dream *))success
        error:(void (^)(NSString *))error;

+ (void)dreamlikes:(NSInteger)dreamId
             pager:(Pager *)pager
           success:(void (^)(NSInteger total, NSArray<DreamLike> *))success
             error:(void (^)(NSString *))error;

+ (void)dreamstamps:(NSInteger)dreamId
              pager:(Pager *)pager
            success:(void (^)(NSInteger total, NSArray<DreamStamp> *))success
              error:(void (^)(NSString *))error;

+ (void)dreamcomments:(NSInteger)dreamId
                pager:(Pager *)pager
              success:(void (^)(NSInteger total, NSArray<DreamComment> *))success
                error:(void (^)(NSString *))error;

+ (void)friends:(Pager *)pager
        success:(void (^)(NSInteger total, NSArray<BasicUser> *))success
          error:(void (^)(NSString *))error;

+ (void)subscribers:(Pager *)pager
            success:(void (^)(NSInteger total, NSArray<BasicUser> *))success
              error:(void (^)(NSString *))error;

+ (void)subscribed:(Pager *)pager
           success:(void (^)(NSInteger total, NSArray<BasicUser> *))success
             error:(void (^)(NSString *))error;

+ (void)requests:(Pager *)pager
         success:(void (^)(NSInteger total, NSArray<BasicUser> *))success
           error:(void (^)(NSString *))error;

+ (void)subscribe:(NSInteger)userId
          success:(void (^)(void))success
            error:(void (^)(NSString *))error;

+ (void)unsubscribe:(NSInteger)userId
            success:(void (^)(void))success
              error:(void (^)(NSString *))error;

+ (void)requestfriendship:(NSInteger)userId
                  success:(void (^)(void))success
                    error:(void (^)(NSString *))error;

+ (void)acceptrequest:(NSInteger)userId
              success:(void (^)(void))success
                error:(void (^)(NSString *))error;

+ (void)denyrequest:(NSInteger)userId
            success:(void (^)(void))success
              error:(void (^)(NSString *))error;

+ (void)unfriend:(NSInteger)userId
         success:(void (^)(void))success
           error:(void (^)(NSString *))error;

+ (void)uploadavatar:(UIImage *)image
             success:(void (^)(NSString *avatarUrl))success
               error:(void (^)(NSString *))error;

+ (void)uploadphoto:(UIImage *)image
            success:(void (^)(NSInteger photoId, NSString *photoUrl))success
              error:(void (^)(NSString *))error;

+ (void)deletephotos:(NSArray *)photoIds
             success:(void (^)(void))success
               error:(void (^)(NSString *))error;

+ (void)profileupdate:(NSDictionary *)params
              success:(void (^)(NSString *))success
                error:(void (^)(NSString *))error;

+ (void)dreamtake:(NSInteger)dreamId
          success:(void (^)(void))success
            error:(void (^)(NSString *))error;

+ (void)dreampropose:(NSInteger)dreamId
              toUser:(NSInteger)userId
             success:(void (^)(void))success
               error:(void (^)(NSString *))error;

+ (void)dreamlike:(NSInteger)dreamId
          success:(void (^)(void))success
            error:(void (^)(NSString *))error;

+ (void)dreamunlike:(NSInteger)dreamId
            success:(void (^)(void))success
              error:(void (^)(NSString *))error;

+ (void)dreampostcomment:(NSInteger)dreamId
                    text:(NSString *)text
                 success:(void (^)(void))success
                   error:(void (^)(NSString *))error;

+ (void)dreamlikecomment:(NSInteger)commentId
                 success:(void (^)(void))success
                   error:(void (^)(NSString *))error;

+ (void)dreamunlikecomment:(NSInteger)commentId
                   success:(void (^)(void))success
                     error:(void (^)(NSString *))error;

+ (void)dreammarkdone:(NSInteger)dreamId
               isdone:(BOOL)isdone
              success:(void (^)(void))success
                error:(void (^)(NSString *))error;

+ (void)eventfeed:(Pager *)pager
          success:(void (^)(NSInteger total, NSArray<EventFeedItem> *))success
            error:(void (^)(NSString *))error;

+ (void)top:(Pager *)pager
    success:(void (^)(NSInteger total, NSArray<Dream> *))success
      error:(void (^)(NSString *))error;

+ (void)proposed:(Pager *)pager
         success:(void (^)(NSInteger total, NSArray<Dream> *))success
           error:(void (^)(NSString *))error;

+ (void)acceptproposed:(NSInteger)dreamId
               success:(void (^)(void))success
                 error:(void (^)(NSString *))error;

+ (void)rejectproposed:(NSInteger)dreamId
               success:(void (^)(void))success
                 error:(void (^)(NSString *))error;

+ (void)findusers:(UserFilter *)filter
            pager:(Pager *)pager
          success:(void (^)(NSInteger total, NSArray<BasicUser> *))success
            error:(void (^)(NSString *))error;

+ (void)postlist:(NSInteger)userId
           pager:(Pager *)pager
         success:(void (^)(NSInteger total, NSArray<Post> *))success
           error:(void (^)(NSString *))error;

+ (void)addpost:(NSString *)title
    description:(NSString *)description
          image:(UIImage *)image
        success:(void (^)(NSInteger id))success
          error:(void (^)(NSString *))error;

+ (void)updatepost:(NSInteger)postId
              name:(NSString *)title
       description:(NSString *)description
             image:(UIImage *)image
           success:(void (^)(void))success
             error:(void (^)(NSString *))error;

+ (void)post:(NSInteger)postId
     success:(void (^)(Post *))success
       error:(void (^)(NSString *))error;

+ (void)postlikes:(NSInteger)postId
            pager:(Pager *)pager
          success:(void (^)(NSInteger total, NSArray<DreamLike> *))success
            error:(void (^)(NSString *))error;

+ (void)postcomments:(NSInteger)postId
               pager:(Pager *)pager
             success:(void (^)(NSInteger total, NSArray<DreamComment> *))success
               error:(void (^)(NSString *))error;

+ (void)postpostcomment:(NSInteger)postId
                   text:(NSString *)text
                success:(void (^)(void))success
                  error:(void (^)(NSString *))error;

+ (void)postlike:(NSInteger)postId
         success:(void (^)(void))success
           error:(void (^)(NSString *))error;

+ (void)postunlike:(NSInteger)postId
           success:(void (^)(void))success
             error:(void (^)(NSString *))error;

+ (void)postlikecomment:(NSInteger)commentId
                success:(void (^)(void))success
                  error:(void (^)(NSString *))error;

+ (void)postunlikecomment:(NSInteger)commentId
                  success:(void (^)(void))success
                    error:(void (^)(NSString *))error;

@end

#endif
