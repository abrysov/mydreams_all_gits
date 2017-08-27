package com.mydreams.android.service.retrofit;

import android.support.annotation.Nullable;

import com.mydreams.android.service.models.AgeRange;
import com.mydreams.android.service.models.SexType;
import com.mydreams.android.service.request.bodys.CommentRequestBody;
import com.mydreams.android.service.request.bodys.DeletePhotosBody;
import com.mydreams.android.service.request.bodys.EntityIdRequestBody;
import com.mydreams.android.service.request.bodys.LikeCommentRequestBody;
import com.mydreams.android.service.request.bodys.LikeDreamRequestBody;
import com.mydreams.android.service.request.bodys.LoginRequestBody;
import com.mydreams.android.service.request.bodys.LoginSocialNetworkRequestBody;
import com.mydreams.android.service.request.bodys.MarkDoneRequestBody;
import com.mydreams.android.service.request.bodys.ProposeDreamRequestBody;
import com.mydreams.android.service.request.bodys.RegisterRequestBody;
import com.mydreams.android.service.request.bodys.TakeDreamRequestBody;
import com.mydreams.android.service.request.bodys.UnlikeCommentRequestBody;
import com.mydreams.android.service.request.bodys.UnlikeDreamRequestBody;
import com.mydreams.android.service.request.bodys.UpdateUserBody;
import com.mydreams.android.service.response.AddDreamResponse;
import com.mydreams.android.service.response.AddPostResponse;
import com.mydreams.android.service.response.CountriesResponse;
import com.mydreams.android.service.response.DreamProposedResponse;
import com.mydreams.android.service.response.DreamTopResponse;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.service.response.GetCommentsResponse;
import com.mydreams.android.service.response.GetDreamLaunchesResponse;
import com.mydreams.android.service.response.GetDreamLikesResponse;
import com.mydreams.android.service.response.GetDreamResponse;
import com.mydreams.android.service.response.GetDreamsResponse;
import com.mydreams.android.service.response.GetPostResponse;
import com.mydreams.android.service.response.GetPostsResponse;
import com.mydreams.android.service.response.LocationsResponse;
import com.mydreams.android.service.response.LoginResponse;
import com.mydreams.android.service.response.RegisterResponse;
import com.mydreams.android.service.response.SearchUserResponse;
import com.mydreams.android.service.response.SocialInfoResponse;
import com.mydreams.android.service.response.SocialLoginResponse;
import com.mydreams.android.service.response.UploadAvatarResponse;
import com.mydreams.android.service.response.UploadPhotoResponse;
import com.mydreams.android.service.response.UserActivitiesResponse;
import com.mydreams.android.service.response.UserResponse;

import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.Header;
import retrofit.http.Multipart;
import retrofit.http.POST;
import retrofit.http.Part;
import retrofit.http.Query;
import retrofit.mime.TypedFile;

public interface IMyDreamsService
{
	@POST("/dream/acceptproposed")
	EmptyResponse acceptProposedDream(@Body EntityIdRequestBody body);

	@POST("/profile/acceptrequest")
	EmptyResponse acceptRequest(@Body EntityIdRequestBody body);

	@Multipart
	@POST("/flybook/adddream")
	AddDreamResponse addDream(@Part("name") String name, @Part("description") String description, @Part("image") TypedFile image, @Part("isdone") boolean isDone);

	@POST("/dream/postcomment")
	EmptyResponse addDreamComment(@Body CommentRequestBody commentRequestBody);

	@Multipart
	@POST("/blog/addpost")
	AddPostResponse addPost(@Part("title") String title, @Part("description") String description, @Part("image") TypedFile image);

	@POST("/post/postcomment")
	EmptyResponse addPostComment(@Body CommentRequestBody body);

	@POST("/profile/deletephoto")
	EmptyResponse deletePhotos(@Body DeletePhotosBody body);

	@POST("/profile/denyrequest")
	EmptyResponse denyRequest(@Body EntityIdRequestBody body);

	@GET("/top")
	DreamTopResponse dreamTop(@Query("page") int page, @Query("onpage") int pageSize);

	@GET("/flybook/list")
	GetDreamsResponse flybookList(@Query("id") Integer userId, @Query("page") int page, @Query("onpage") int pageSize, @Query("isdone") Boolean isDone);

	@GET("/countries")
	CountriesResponse getCountries();

	@GET("/dream")
	GetDreamResponse getDream(@Query("id") int dreamId);

	@GET("/dream/comments")
	GetCommentsResponse getDreamComments(@Query("id") int dreamId, @Query("page") int page, @Query("onpage") int pageSize);

	@GET("/dream/stamps")
	GetDreamLaunchesResponse getDreamLaunches(@Query("id") int dreamId, @Query("page") int page, @Query("onpage") int pageSize);

	@GET("/dream/likes")
	GetDreamLikesResponse getDreamLikes(@Query("id") int dreamId, @Query("page") int page, @Query("onpage") int pageSize);

	@GET("/dream/proposed")
	DreamProposedResponse getDreamProposed(@Query("page") int page, @Query("onpage") int pageSize);

	@GET("/profile/requests")
	SocialInfoResponse getFriendRequests(@Query("id") Integer userId, @Query("page") int page, @Query("onpage") int pageSize, @Query("filter") String filter);

	@GET("/profile/friends")
	SocialInfoResponse getFriends(@Query("id") Integer userId, @Query("page") int page, @Query("onpage") int pageSize, @Query("filter") String filter);

	@GET("/flybook/user")
	UserResponse getMe();

	@GET("/flybook/user")
	UserResponse getMe(@Header("Authorization") String token);

	@GET("/post")
	GetPostResponse getPost(@Query("id") int id);

	@GET("/post/comments")
	GetCommentsResponse getPostComments(@Query("id") int postId, @Query("page") int page, @Query("onpage") int pageSize);

	@GET("/blog/posts")
	GetPostsResponse getPosts(@Query("id") int userId, @Query("page") int page, @Query("onpage") int pageSize);

	@GET("/profile/subscribed")
	SocialInfoResponse getSubscribed(@Query("id") Integer userId, @Query("page") int page, @Query("onpage") int pageSize, @Query("filter") String filter);

	@GET("/profile/subscribers")
	SocialInfoResponse getSubscribers(@Query("id") Integer userId, @Query("page") int page, @Query("onpage") int pageSize, @Query("filter") String filter);

	@GET("/flybook/user")
	UserResponse getUser(@Query("id") int id);

	@GET("/eventfeed")
	UserActivitiesResponse getUserActivities(@Query("page") int page, @Query("onpage") int pageSize);

	@POST("/dream/likeComment")
	EmptyResponse likeComment(@Body LikeCommentRequestBody likeCommentBody);

	@POST("/dream/like")
	EmptyResponse likeDream(@Body LikeDreamRequestBody body);

	@POST("/post/like")
	EmptyResponse likePost(@Body EntityIdRequestBody body);

	@POST("/post/likeComment")
	EmptyResponse likePostComment(@Body EntityIdRequestBody likeCommentBody);

	@GET("/findlocations")
	LocationsResponse locations(@Query("search") String search, @Nullable @Query("country") Integer country);

	@GET("/findlocations")
	LocationsResponse locations(@Query("search") String search, @Query("lat") double latitude, @Query("lng") double longitude, @Nullable @Query("country") Integer country);

	@POST("/auth/login")
	LoginResponse login(@Body LoginRequestBody loginRequest);

	@POST("/auth/loginByFacebook")
	SocialLoginResponse loginByFacebook(@Body LoginSocialNetworkRequestBody loginRequest);

	@POST("/auth/loginByGooglePlus")
	SocialLoginResponse loginByGooglePlus(@Body LoginSocialNetworkRequestBody loginRequest);

	@POST("/auth/loginByPinterest")
	SocialLoginResponse loginByPinterest(@Body LoginSocialNetworkRequestBody loginRequest);

	@POST("/auth/loginByTwitter")
	SocialLoginResponse loginByTwitter(@Body LoginSocialNetworkRequestBody loginRequest);

	@POST("/auth/loginByVK")
	SocialLoginResponse loginByVK(@Body LoginSocialNetworkRequestBody loginRequest);

	@POST("/dream/markdone")
	EmptyResponse markDone(@Body MarkDoneRequestBody body);

	@POST("/dream/propose")
	EmptyResponse proposeDream(@Body ProposeDreamRequestBody body);

	@POST("/register")
	RegisterResponse register(@Body RegisterRequestBody registerRequest);

	@POST("/dream/rejectproposed")
	EmptyResponse rejectProposedDream(@Body EntityIdRequestBody body);

	@POST("/profile/requestfriendship")
	EmptyResponse requestFriendship(@Body EntityIdRequestBody body);

	@GET("/findusers")
	SearchUserResponse searchUsers(@Query("page") int page, @Query("onpage") int pageSize, @Query("age") AgeRange ageRange,
								   @Query("sex") SexType sexType, @Query("country") Integer country, @Query("city") Integer city,
								   @Query("popular") Integer popular, @Query("new") Integer newUsers, @Query("online") Integer online,
								   @Query("vip") Integer vip);

	@POST("/profile/subscribe")
	EmptyResponse subscribe(@Body EntityIdRequestBody body);

	@POST("/dream/take")
	EmptyResponse takeDream(@Body TakeDreamRequestBody body);

	@POST("/profile/unfriend")
	EmptyResponse unfriend(@Body EntityIdRequestBody body);

	@POST("/dream/unlikeComment")
	EmptyResponse unlikeComment(@Body UnlikeCommentRequestBody unlikeCommentBody);

	@POST("/dream/unlike")
	EmptyResponse unlikeDream(@Body UnlikeDreamRequestBody body);

	@POST("/post/unlike")
	EmptyResponse unlikePost(@Body EntityIdRequestBody body);

	@POST("/post/unlikeComment")
	EmptyResponse unlikePostComment(@Body EntityIdRequestBody body);

	@POST("/profile/unsubscribe")
	EmptyResponse unsubscribe(@Body EntityIdRequestBody body);

	@Multipart
	@POST("/dream/update")
	EmptyResponse updateDream(@Part("id") int id, @Part("name") String name, @Part("description") String description, @Part("image") TypedFile image, @Part("isdone") boolean isDone);

	@Multipart
	@POST("/post/update")
	EmptyResponse updatePost(@Part("id") int id, @Part("title") String title, @Part("description") String description, @Part("image") TypedFile image);

	@POST("/profile/update")
	EmptyResponse updateUser(@Body UpdateUserBody updateUserBody);

	@Multipart
	@POST("/profile/uploadavatar")
	UploadAvatarResponse uploadAvatar(@Part("image") TypedFile image);

	@Multipart
	@POST("/profile/uploadphoto")
	UploadPhotoResponse uploadPhoto(@Part("image") TypedFile image);

}
