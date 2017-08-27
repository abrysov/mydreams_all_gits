//
//  Constants.h
//  MyDreams
//
//  Created by Игорь on 30.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#ifndef MyDreams_Constants_h
#define MyDreams_Constants_h


#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

typedef enum {
    AppearenceStyleNONE,
    AppearenceStyleBLUE,
    AppearenceStyleYELLOW,
    AppearenceStylePURPLE,
    AppearenceStyleGREEN,
    AppearenceStyleDBLUE,
    AppearenceStyleRED,
    AppearenceStyleVIRID
} AppearenceStyle;

extern NSString *const EMAIL_REGEX_PATTERN;

extern NSString *const PHONE_REGEX_PATTERN;

extern NSString *const PASSWORD_REGEX_PATTERN;


// API Methods

extern NSString *const SERVER_URL;

extern NSString *const SERVER_API_URL;

extern NSString *const API_METHOD_SIGNUP;

extern NSString *const API_METHOD_LOGIN;

extern NSString *const API_METHOD_FLYBOOK;

extern NSString *const API_METHOD_FINDLOCATIONS;

extern NSString *const API_METHOD_COUNTRIES;

extern NSString *const API_METHOD_FLYBOOK_LIST;

extern NSString *const API_METHOD_ADDDREAM;

extern NSString *const API_METHOD_DREAM_UPDATE;

extern NSString *const API_METHOD_DREAM;

extern NSString *const API_METHOD_DREAM_LIKES;

extern NSString *const API_METHOD_DREAM_COMMENTS;

extern NSString *const API_METHOD_DREAM_STAMPS;

extern NSString *const API_METHOD_UPLOAD_AVATAR;

extern NSString *const API_METHOD_UPLOAD_PHOTO;

extern NSString *const API_METHOD_DELETE_PHOTO;

extern NSString *const API_METHOD_PROFILE_UPDATE;

extern NSString *const API_METHOD_DREAM_TAKE;

extern NSString *const API_METHOD_DREAM_PROPOSE;

extern NSString *const API_METHOD_DREAM_LIKE;

extern NSString *const API_METHOD_DREAM_UNLIKE;

extern NSString *const API_METHOD_DREAM_POSTCOMMENT;

extern NSString *const API_METHOD_DREAM_LIKECOMMENT;

extern NSString *const API_METHOD_DREAM_UNLIKECOMMENT;

extern NSString *const API_METHOD_DREAM_MARKDONE;

extern NSString *const API_METHOD_PROFILE_FRIENDS;

extern NSString *const API_METHOD_PROFILE_SUBSCRIBERS;

extern NSString *const API_METHOD_PROFILE_SUBSCRIBED;

extern NSString *const API_METHOD_PROFILE_REQUESTS;

extern NSString *const API_METHOD_PROFILE_SUBSCRIBE;

extern NSString *const API_METHOD_PROFILE_UNSUBSCRIBE;

extern NSString *const API_METHOD_PROFILE_REQUESTFRIENDSHIP;

extern NSString *const API_METHOD_PROFILE_ACCEPTREQUEST;

extern NSString *const API_METHOD_PROFILE_DENYREQUEST;

extern NSString *const API_METHOD_PROFILE_UNFRIEND;

extern NSString *const API_METHOD_TOPDREAMS;

extern NSString *const API_METHOD_EVENTFEED;

extern NSString *const API_METHOD_FINDUSERS;

extern NSString *const API_METHOD_DREAM_PROPOSED;

extern NSString *const API_METHOD_DREAM_PROPOSEDACCEPT;

extern NSString *const API_METHOD_DREAM_PROPOSEDREJECT;

extern NSString *const API_METHOD_BLOG_POSTADD;

extern NSString *const API_METHOD_BLOG_POSTLIST;

extern NSString *const API_METHOD_BLOG_POST;

extern NSString *const API_METHOD_BLOG_POSTUPDATE;

extern NSString *const API_METHOD_BLOG_POSTLIKES;

extern NSString *const API_METHOD_BLOG_POSTCOMMENTS;

extern NSString *const API_METHOD_BLOG_POSTCOMMENT;

extern NSString *const API_METHOD_BLOG_POSTLIKE;

extern NSString *const API_METHOD_BLOG_POSTUNLIKE;

extern NSString *const API_METHOD_BLOG_POSTLIKECOMMENT;

extern NSString *const API_METHOD_BLOG_POSTUNLIKECOMMENT;

// colors

extern NSString *const COLOR_STYLE_YELLOW;

extern NSString *const COLOR_STYLE_BLUE;

extern NSString *const COLOR_STYLE_GREEN;

extern NSString *const COLOR_STYLE_PURPLE;

extern NSString *const COLOR_STYLE_DBLUE;

extern NSString *const COLOR_STYLE_RED;

extern NSString *const COLOR_STYLE_VIRID;

// 

extern float const POST_IMAGE_RATIO;

#endif
