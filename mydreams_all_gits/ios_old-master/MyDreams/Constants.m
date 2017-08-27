//
//  Constants.m
//  MyDreams
//
//  Created by Игорь on 30.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString *const EMAIL_REGEX_PATTERN = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";

NSString *const PHONE_REGEX_PATTERN = @"^[+()\\s0-9]+$";

NSString *const PASSWORD_REGEX_PATTERN = @"^.*[A-Za-zА-Яа-я]+.*$";


// API methods

NSString *const SERVER_URL = @"https://mydreams.club";

NSString *const SERVER_API_URL = @"http://mydreams.club/api";

NSString *const API_METHOD_SIGNUP = @"/register";

NSString *const API_METHOD_LOGIN = @"/auth/login";

NSString *const API_METHOD_FLYBOOK = @"/flybook/user";

NSString *const API_METHOD_FINDLOCATIONS = @"/findlocations";

NSString *const API_METHOD_COUNTRIES = @"/countries";

NSString *const API_METHOD_FLYBOOK_LIST = @"/flybook/list";

NSString *const API_METHOD_ADDDREAM = @"/flybook/adddream";

NSString *const API_METHOD_DREAM_UPDATE = @"/dream/update";

NSString *const API_METHOD_DREAM = @"/dream";

NSString *const API_METHOD_DREAM_LIKES = @"/dream/likes";

NSString *const API_METHOD_DREAM_STAMPS = @"/dream/stamps";

NSString *const API_METHOD_DREAM_COMMENTS = @"/dream/comments";

NSString *const API_METHOD_UPLOAD_AVATAR = @"/profile/uploadavatar";

NSString *const API_METHOD_UPLOAD_PHOTO = @"/profile/uploadphoto";

NSString *const API_METHOD_DELETE_PHOTO = @"/profile/deletephoto";

NSString *const API_METHOD_PROFILE_UPDATE = @"/profile/update";

NSString *const API_METHOD_DREAM_TAKE = @"/dream/take";

NSString *const API_METHOD_DREAM_PROPOSE = @"/dream/propose";

NSString *const API_METHOD_DREAM_LIKE = @"/dream/like";

NSString *const API_METHOD_DREAM_UNLIKE = @"/dream/unlike";

NSString *const API_METHOD_DREAM_POSTCOMMENT = @"/dream/postcomment";

NSString *const API_METHOD_DREAM_LIKECOMMENT = @"/dream/likeComment";

NSString *const API_METHOD_DREAM_UNLIKECOMMENT = @"/dream/unlikeComment";

NSString *const API_METHOD_DREAM_MARKDONE = @"/dream/markdone";

NSString *const API_METHOD_PROFILE_FRIENDS = @"/profile/friends";

NSString *const API_METHOD_PROFILE_SUBSCRIBERS = @"/profile/subscribers";

NSString *const API_METHOD_PROFILE_SUBSCRIBED = @"/profile/subscribed";

NSString *const API_METHOD_PROFILE_REQUESTS = @"/profile/requests";

NSString *const API_METHOD_PROFILE_SUBSCRIBE = @"/profile/subscribe";

NSString *const API_METHOD_PROFILE_UNSUBSCRIBE = @"/profile/unsubscribe";

NSString *const API_METHOD_PROFILE_REQUESTFRIENDSHIP = @"/profile/requestfriendship";

NSString *const API_METHOD_PROFILE_ACCEPTREQUEST = @"/profile/acceptrequest";

NSString *const API_METHOD_PROFILE_DENYREQUEST = @"/profile/denyrequest";

NSString *const API_METHOD_PROFILE_UNFRIEND = @"/profile/unfriend";

NSString *const API_METHOD_TOPDREAMS = @"/top";

NSString *const API_METHOD_EVENTFEED = @"/eventfeed";

NSString *const API_METHOD_FINDUSERS = @"/findusers";

NSString *const API_METHOD_DREAM_PROPOSED = @"/dream/proposed";

NSString *const API_METHOD_DREAM_PROPOSEDACCEPT = @"/dream/acceptproposed";

NSString *const API_METHOD_DREAM_PROPOSEDREJECT = @"/dream/rejectproposed";

NSString *const API_METHOD_BLOG_POSTADD = @"/blog/addpost";

NSString *const API_METHOD_BLOG_POSTLIST = @"/blog/posts";

NSString *const API_METHOD_BLOG_POST = @"/post";

NSString *const API_METHOD_BLOG_POSTUPDATE = @"/post/update";

NSString *const API_METHOD_BLOG_POSTLIKES = @"/post/likes";

NSString *const API_METHOD_BLOG_POSTCOMMENTS = @"/post/comments";

NSString *const API_METHOD_BLOG_POSTCOMMENT = @"/post/postcomment";

NSString *const API_METHOD_BLOG_POSTLIKE = @"/post/like";

NSString *const API_METHOD_BLOG_POSTUNLIKE = @"/post/unlike";

NSString *const API_METHOD_BLOG_POSTLIKECOMMENT = @"/post/likecomment";

NSString *const API_METHOD_BLOG_POSTUNLIKECOMMENT = @"/post/unlikecomment";

// colors

NSString *const COLOR_STYLE_YELLOW = @"#fbbd03";

NSString *const COLOR_STYLE_BLUE = @"#2196f3";

NSString *const COLOR_STYLE_GREEN = @"#51b455";

NSString *const COLOR_STYLE_PURPLE = @"#673ab7";

NSString *const COLOR_STYLE_DBLUE = @"#3f51b5";

NSString *const COLOR_STYLE_RED = @"#e9382b";

NSString *const COLOR_STYLE_VIRID = @"#00bfa5";

//

float const POST_IMAGE_RATIO = 184.0 / 260.0;


