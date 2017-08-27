package com.mydreams.android.service.request.spice;

import android.location.Location;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.util.Pair;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.mydreams.android.BuildConfig;
import com.mydreams.android.app.MyDreamsApplication;
import com.mydreams.android.fragments.EditUserFragment;
import com.mydreams.android.fragments.PhotosFragment;
import com.mydreams.android.models.FilterUser;
import com.mydreams.android.service.models.CommentDto;
import com.mydreams.android.service.models.CountryDto;
import com.mydreams.android.service.models.DreamInfoDto;
import com.mydreams.android.service.models.LaunchDto;
import com.mydreams.android.service.models.LikeDto;
import com.mydreams.android.service.models.PhotoDto;
import com.mydreams.android.service.models.PostDto;
import com.mydreams.android.service.models.PostInfoDto;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.models.UserActivityDto;
import com.mydreams.android.service.models.UserDto;
import com.mydreams.android.service.models.UserInfoDto;
import com.mydreams.android.service.request.bodys.CommentRequestBody;
import com.mydreams.android.service.request.bodys.DeletePhotosBody;
import com.mydreams.android.service.request.bodys.EntityIdRequestBody;
import com.mydreams.android.service.request.bodys.LikeCommentRequestBody;
import com.mydreams.android.service.request.bodys.LikeDreamRequestBody;
import com.mydreams.android.service.request.bodys.LoginRequestBody;
import com.mydreams.android.service.request.bodys.MarkDoneRequestBody;
import com.mydreams.android.service.request.bodys.ProposeDreamRequestBody;
import com.mydreams.android.service.request.bodys.RegisterRequestBody;
import com.mydreams.android.service.request.bodys.TakeDreamRequestBody;
import com.mydreams.android.service.request.bodys.UnlikeCommentRequestBody;
import com.mydreams.android.service.request.bodys.UnlikeDreamRequestBody;
import com.mydreams.android.service.request.bodys.UpdateUserBody;
import com.mydreams.android.service.response.AddDreamResponse;
import com.mydreams.android.service.response.AddPostResponse;
import com.mydreams.android.service.response.AuthorizeUserResponse;
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
import com.mydreams.android.service.response.SocialStatResponse;
import com.mydreams.android.service.response.UpdateProfileResponse;
import com.mydreams.android.service.response.UploadAvatarResponse;
import com.mydreams.android.service.response.UploadPhotoResponse;
import com.mydreams.android.service.response.UserActivitiesResponse;
import com.mydreams.android.service.response.UserResponse;
import com.mydreams.android.service.response.bodys.AuthorizeUserBody;
import com.mydreams.android.service.response.bodys.CountriesResponseBody;
import com.mydreams.android.service.response.bodys.DreamProposedResponseBody;
import com.mydreams.android.service.response.bodys.DreamTopResponseBody;
import com.mydreams.android.service.response.bodys.GetCommentsResponseBody;
import com.mydreams.android.service.response.bodys.GetDreamLaunchesResponseBody;
import com.mydreams.android.service.response.bodys.GetDreamLikesResponseBody;
import com.mydreams.android.service.response.bodys.GetDreamsResponseBody;
import com.mydreams.android.service.response.bodys.GetPostResponseBody;
import com.mydreams.android.service.response.bodys.GetPostsResponseBody;
import com.mydreams.android.service.response.bodys.SocialInfoResponseBody;
import com.mydreams.android.service.response.bodys.SocialStatResponseBody;
import com.mydreams.android.service.response.bodys.UpdateProfileBody;
import com.mydreams.android.service.response.bodys.UserActivitiesResponseBody;
import com.mydreams.android.service.retrofit.IMyDreamsService;
import com.mydreams.android.utils.AccessStorageApi;

import java.io.File;
import java.net.URI;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import retrofit.mime.TypedFile;

public class RequestFactory
{
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeComments = false;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeLaunches = false;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeLikes = false;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeFriendRequest = false;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeFriends = true;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeSubscribers = false;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeUserActivity = true;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeCountries = true;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeDreamProposed = true;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakePostsProposed = false;
	@SuppressWarnings("FieldCanBeLocal")
	private static boolean showFakeTop = false;

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> acceptProposedDream(int dreamId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.acceptProposedDream(new EntityIdRequestBody(dreamId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> acceptRequest(int userId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.acceptRequest(new EntityIdRequestBody(userId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> addDream(String name, String description, File imageFilePath, boolean isDone)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, 1, service -> {
			AddDreamResponse response = service.addDream(name, description, new TypedFile("image/jpeg", imageFilePath), isDone);

			EmptyResponse result = new EmptyResponse();

			result.setCode(response.getCode());
			result.setBody(new Object());
			result.setMessage(response.getMessage());

			return result;
		});
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> addDreamComment(int dreamId, String text)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.addDreamComment(new CommentRequestBody(dreamId, text)));
	}

	@NonNull
	public static BaseSpiceRequest<AddPostResponse> addPost(String title, String description, File imageFilePath)
	{
		return new BaseSpiceRequest<>(AddPostResponse.class, service -> service.addPost(title, description, new TypedFile("image/jpeg", imageFilePath)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> addPostComment(int id, String text)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.addPostComment(new CommentRequestBody(id, text)));
	}

	private static Integer boolean2Integer(final Boolean popular)
	{
		if (popular == null)
			return null;

		return popular ? 1 : 0;
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> denyRequest(int userId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.denyRequest(new EntityIdRequestBody(userId)));
	}

	@NonNull
	public static BaseSpiceRequest<DreamTopResponse> dreamTop(int page, int pageSize)
	{
		if (BuildConfig.DEBUG && showFakeTop)
		{
			return new BaseSpiceRequest<>(DreamTopResponse.class, service -> {
				GetDreamsResponse response = service.flybookList(null, page, pageSize, null);

				DreamTopResponseBody.DreamCollectionBody collection = null;
				if (response.getDreams() != null)
				{
					collection = new DreamTopResponseBody.DreamCollectionBody();
					collection.setTotal(response.getDreams().size());
					collection.setDreams(response.getDreams());
				}

				final DreamTopResponseBody body = new DreamTopResponseBody();
				body.setDreamCollection(collection);

				DreamTopResponse result = new DreamTopResponse();
				result.setCode(response.getCode());
				result.setMessage(response.getMessage());
				result.setBody(body);


				return result;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(DreamTopResponse.class, service -> service.dreamTop(page, pageSize));
		}
	}

	@NonNull
	public static BaseSpiceRequest<LocationsResponse> findLocations(@Nullable String search, @Nullable Location location, @Nullable Integer countryId)
	{
		return new BaseSpiceRequest<>(LocationsResponse.class, service ->
		{
			if (location != null)
			{
				return service.locations(search, location.getLatitude(), location.getLongitude(), countryId);
			}
			else
			{
				return service.locations(search, countryId);
			}
		});
	}

	@NonNull
	public static BaseSpiceRequest<CountriesResponse> getCountries()
	{
		if (BuildConfig.DEBUG && showFakeCountries)
		{
			return new BaseSpiceRequest<>(CountriesResponse.class, service -> {
				Thread.sleep(1500);

				final List<CountryDto> countries = Stream.ofRange(0, 100).map(x -> {
					CountryDto dto = new CountryDto();
					dto.setId(x);
					dto.setName("Country name - " + x);
					return dto;
				}).collect(Collectors.toList());

				final CountriesResponseBody body = new CountriesResponseBody();
				body.setCountries(countries);

				final CountriesResponse response = new CountriesResponse();
				response.setCode(ResponseStatus.Ok);
				response.setBody(body);

				return response;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(CountriesResponse.class, IMyDreamsService::getCountries);
		}
	}

	@NonNull
	public static BaseSpiceRequest<GetDreamResponse> getDream(int dreamId)
	{
		return new BaseSpiceRequest<>(GetDreamResponse.class, service -> service.getDream(dreamId));
	}

	@NonNull
	public static BaseSpiceRequest<GetCommentsResponse> getDreamComments(int dreamId, int page, int pageSize)
	{
		if (BuildConfig.DEBUG && showFakeComments)
		{
			return new BaseSpiceRequest<>(GetCommentsResponse.class, service ->
			{
				Thread.sleep(1500);

				Random random = new Random();
				List<CommentDto> commentDtos = Stream.ofRange(page * pageSize, page * pageSize + pageSize)
						.map(x ->
						{
							CommentDto comment = new CommentDto();

							UserDto me = service.getMe().getUser();
							if (me == null)
								throw new RuntimeException();

							UserInfoDto user = new UserInfoDto();
							user.setFullName(me.getFirstName() + me.getLastName());
							user.setId(me.getId() - x);
							user.setAge("42");
							user.setLocation(me.getLocation());
							user.setAvatarUrl("http://placehold.it/350x150/" + String.format("%02X%02XFF", random.nextInt(256), random.nextInt(256)));

							comment.setUser(user);
							comment.setDateStr("2015-09-23T17:21:21.343Z");
							comment.setId(1);
							comment.setLiked(random.nextBoolean());

							StringBuilder builder = new StringBuilder();
							Stream.ofRange(0, 50 + random.nextInt(50)).forEach(y ->
							{
								builder.append(y);
								if (random.nextBoolean())
									builder.append(" ");
							});
							comment.setText(builder.toString());

							return comment;
						})
						.collect(Collectors.toList());

				GetCommentsResponseBody.CommentCollectionBody collection = new GetCommentsResponseBody.CommentCollectionBody();
				collection.setComments(commentDtos);

				GetCommentsResponseBody body = new GetCommentsResponseBody();
				body.setCommentCollectionBody(collection);

				GetCommentsResponse response = new GetCommentsResponse();
				response.setCode(ResponseStatus.Ok);
				response.setBody(body);

				return response;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(GetCommentsResponse.class, service -> service.getDreamComments(dreamId, page, pageSize));
		}
	}

	@NonNull
	public static BaseSpiceRequest<GetDreamLaunchesResponse> getDreamLaunches(int dreamId, int page, int pageSize)
	{
		if (BuildConfig.DEBUG && showFakeLaunches)
		{
			return new BaseSpiceRequest<>(GetDreamLaunchesResponse.class, service ->
			{
				Thread.sleep(1500);

				Random random = new Random();
				List<LaunchDto> launchDtos = Stream.ofRange(page * pageSize, page * pageSize + pageSize)
						.map(x ->
						{
							LaunchDto like = new LaunchDto();

							UserDto me = service.getMe().getUser();
							if (me == null)
								throw new RuntimeException();

							UserInfoDto user = new UserInfoDto();
							user.setFullName(me.getFirstName() + me.getLastName());
							user.setId(me.getId() - x);
							user.setAge("42");
							user.setLocation(me.getLocation());
							user.setAvatarUrl("http://placehold.it/350x150/" + String.format("%02X%02XFF", random.nextInt(256), random.nextInt(256)));

							like.setUser(user);
							like.setDateStr("2015-09-23T17:21:21.343Z");

							return like;
						})
						.collect(Collectors.toList());

				GetDreamLaunchesResponseBody.LaunchCollectionBody collection = new GetDreamLaunchesResponseBody.LaunchCollectionBody();
				collection.setLaunches(launchDtos);

				GetDreamLaunchesResponseBody body = new GetDreamLaunchesResponseBody();
				body.setLaunchCollectionBody(collection);

				GetDreamLaunchesResponse response = new GetDreamLaunchesResponse();
				response.setCode(ResponseStatus.Ok);
				response.setBody(body);

				return response;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(GetDreamLaunchesResponse.class, service -> service.getDreamLaunches(dreamId, page, pageSize));
		}
	}

	@NonNull
	public static BaseSpiceRequest<GetDreamLikesResponse> getDreamLikes(int dreamId, int page, int pageSize)
	{
		if (BuildConfig.DEBUG && showFakeLikes)
		{
			return new BaseSpiceRequest<>(GetDreamLikesResponse.class, service ->
			{
				Thread.sleep(1500);

				Random random = new Random();

				List<LikeDto> likes = Stream.ofRange(page * pageSize, page * pageSize + pageSize)
						.map(x ->
						{
							LikeDto like = new LikeDto();

							UserDto me = service.getMe().getUser();
							if (me == null)
								throw new RuntimeException();

							UserInfoDto user = new UserInfoDto();
							user.setFullName(me.getFirstName() + me.getLastName());
							user.setId(me.getId() - x);
							user.setAge("42");
							user.setLocation(me.getLocation());
							user.setAvatarUrl("http://placehold.it/350x150/" + String.format("%02X%02XFF", random.nextInt(256), random.nextInt(256)));

							like.setUser(user);
							like.setDateStr("2015-09-23T17:21:21.343Z");

							return like;
						})
						.collect(Collectors.toList());

				GetDreamLikesResponseBody.LikeCollectionBody collection = new GetDreamLikesResponseBody.LikeCollectionBody();
				collection.setLikes(likes);

				GetDreamLikesResponseBody body = new GetDreamLikesResponseBody();
				body.setLikeCollectionBody(collection);

				GetDreamLikesResponse response = new GetDreamLikesResponse();
				response.setCode(ResponseStatus.Ok);
				response.setBody(body);

				return response;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(GetDreamLikesResponse.class, service -> service.getDreamLikes(dreamId, page, pageSize));
		}
	}

	@NonNull
	public static BaseSpiceRequest<DreamProposedResponse> getDreamProposed(int page, int pageSize)
	{
		if (BuildConfig.DEBUG && showFakeDreamProposed)
		{
			return new BaseSpiceRequest<>(DreamProposedResponse.class, service ->
			{
				Thread.sleep(1500);

				GetDreamsResponse flybookResponse = service.flybookList(null, page, pageSize, null);

				final DreamProposedResponseBody.DreamCollectionBody collection = new DreamProposedResponseBody.DreamCollectionBody();
				//noinspection ConstantConditions
				collection.setTotal(flybookResponse.getDreams().size());
				collection.setDreams(flybookResponse.getDreams());

				final DreamProposedResponseBody body = new DreamProposedResponseBody();
				body.setDreamCollection(collection);

				DreamProposedResponse response = new DreamProposedResponse();
				response.setBody(body);
				response.setCode(flybookResponse.getCode());
				response.setMessage(flybookResponse.getMessage());
				return response;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(DreamProposedResponse.class, service -> service.getDreamProposed(page, pageSize));
		}
	}

	@NonNull
	public static BaseSpiceRequest<SocialInfoResponse> getFriendRequests(@Nullable Integer userId, int page, int pageSize, @Nullable String filter)
	{
		if (BuildConfig.DEBUG && showFakeFriendRequest)
		{
			return getFriends(userId, page, pageSize, filter);
		}
		else
		{
			return new BaseSpiceRequest<>(SocialInfoResponse.class, service -> service.getFriendRequests(userId, page, pageSize, filter));
		}
	}

	@NonNull
	public static BaseSpiceRequest<SocialInfoResponse> getFriends(@Nullable Integer userId, int page, int pageSize, @Nullable String filter)
	{
		return new BaseSpiceRequest<>(SocialInfoResponse.class, service -> {
			if (BuildConfig.DEBUG && showFakeFriends)
			{
				Thread.sleep(1500);

				UserDto me = service.getMe().getUser();
				if (me == null)
					throw new RuntimeException();

				List<UserInfoDto> users = new ArrayList<>();
				Random random = new Random();
				for (int i = 0; i < pageSize; i++)
				{
					UserInfoDto user = new UserInfoDto();

					user.setFullName(me.getFirstName() + me.getLastName() + i);
					user.setId(me.getId() - i);
					user.setAge("" + (42 + i));
					user.setLocation(me.getLocation());
					user.setAvatarUrl(me.getAvatarUrl());
					user.setIsVip(random.nextBoolean());

					users.add(user);
				}

				SocialInfoResponseBody.UserInfoCollectionBody collection = new SocialInfoResponseBody.UserInfoCollectionBody();
				collection.setTotal(pageSize);
				collection.setUserInfos(users);

				SocialInfoResponseBody body = new SocialInfoResponseBody();
				body.setUserInfoCollectionBody(collection);

				SocialInfoResponse response = new SocialInfoResponse();
				response.setCode(ResponseStatus.Ok);
				response.setBody(body);

				return response;
			}
			else
			{
				return service.getFriends(userId, page, pageSize, filter);
			}
		});
	}

	@NonNull
	public static BaseSpiceRequest<UserResponse> getMe()
	{
		return new BaseSpiceRequest<>(UserResponse.class, IMyDreamsService::getMe);
	}

	@NonNull
	public static BaseSpiceRequest<GetPostResponse> getPost(int id)
	{
		if (BuildConfig.DEBUG && showFakePostsProposed)
		{
			return new BaseSpiceRequest<>(GetPostResponse.class, service -> {
				Thread.sleep(1500);

				Random random = new Random();
				final PostDto post = new PostDto();
				post.setAddDate("2015-11-11T12:12:12.12Z");
				post.setCommentCount(random.nextInt(42));
				post.setDescription("Description - " + random.nextInt(42));
				post.setId(random.nextInt());
				post.setLikeCount(random.nextInt(42));
				post.setTitle("Name - " + random.nextInt(42));

				final GetPostResponseBody body = new GetPostResponseBody();
				body.setPost(post);

				GetPostResponse response = new GetPostResponse();
				response.setCode(ResponseStatus.Ok);
				response.setBody(body);
				return response;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(GetPostResponse.class, service -> service.getPost(id));
		}
	}

	@NonNull
	public static BaseSpiceRequest<GetCommentsResponse> getPostComments(int postId, int page, int pageSize)
	{
		if (BuildConfig.DEBUG && showFakePostsProposed)
		{
			return new BaseSpiceRequest<>(GetCommentsResponse.class, service -> {
				Thread.sleep(1500);

				Random random = new Random();

				SearchUserResponse users = service.searchUsers(0, 1, null, null, null, null, null, null, null, null);

				final List<CommentDto> items = Stream.ofRange(0, pageSize).map(x -> {
					CommentDto dto = new CommentDto();
					dto.setDateStr("2015-11-11T12:12:12.12Z");
					dto.setId(random.nextInt());
					dto.setText("Text - " + random.nextInt(42));
					dto.setLiked(random.nextBoolean());
					dto.setUser(users.getUsers().get(0));
					return dto;
				}).collect(Collectors.toList());

				final GetCommentsResponseBody.CommentCollectionBody collection = new GetCommentsResponseBody.CommentCollectionBody();
				collection.setComments(items);
				collection.setTotal(pageSize);

				final GetCommentsResponseBody body = new GetCommentsResponseBody();
				body.setCommentCollectionBody(collection);

				GetCommentsResponse response = new GetCommentsResponse();
				response.setCode(ResponseStatus.Ok);
				response.setBody(body);
				return response;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(GetCommentsResponse.class, service -> service.getPostComments(postId, page, pageSize));
		}
	}

	@NonNull
	public static BaseSpiceRequest<GetPostsResponse> getPosts(int userId, int page, int pageSize)
	{
		if (BuildConfig.DEBUG && showFakePostsProposed)
		{
			return new BaseSpiceRequest<>(GetPostsResponse.class, service -> {
				Thread.sleep(1500);

				Random random = new Random();
				final List<PostInfoDto> items = Stream.ofRange(0, pageSize).map(x -> {
					PostInfoDto dto = new PostInfoDto();
					dto.setAddDate("2015-11-11T12:12:12.12Z");
					dto.setCommentCount(random.nextInt(42));
					dto.setDescription("Description - " + random.nextInt(42));
					dto.setId(random.nextInt());
					dto.setLikeCount(random.nextInt(42));
					dto.setTitle("Name - " + random.nextInt(42));
					return dto;
				}).collect(Collectors.toList());

				final GetPostsResponseBody.PostCollectionBody collection = new GetPostsResponseBody.PostCollectionBody();
				collection.setPosts(items);
				collection.setTotal(pageSize);

				final GetPostsResponseBody body = new GetPostsResponseBody();
				body.setPostCollection(collection);

				GetPostsResponse response = new GetPostsResponse();
				response.setCode(ResponseStatus.Ok);
				response.setBody(body);
				return response;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(GetPostsResponse.class, service -> service.getPosts(userId, page, pageSize));
		}
	}

	@NonNull
	public static BaseSpiceRequest<SocialStatResponse> getSocialStat(@Nullable Integer userId)
	{
		return new BaseSpiceRequest<>(SocialStatResponse.class, service ->
		{
			SocialStatResponseBody body = new SocialStatResponseBody();

			SocialStatResponse response = new SocialStatResponse();
			response.setBody(body);
			response.setCode(ResponseStatus.Ok);

			{
				SocialInfoResponse friends = service.getFriends(userId, 0, 1, null);
				if (friends.getCode() == ResponseStatus.Ok)
				{
					SocialInfoResponseBody.UserInfoCollectionBody collection = friends.getBody().getUserInfoCollectionBody();
					if (collection != null)
						body.setFriendCount(collection.getTotal());
				}
				else
				{
					response.setCode(friends.getCode());
					return response;
				}
			}
			{
				SocialInfoResponse requests = service.getFriendRequests(userId, 0, 1, null);
				if (requests.getCode() == ResponseStatus.Ok)
				{
					SocialInfoResponseBody.UserInfoCollectionBody collection = requests.getBody().getUserInfoCollectionBody();
					if (collection != null)
						body.setRequestCount(collection.getTotal());
				}
				else
				{
					response.setCode(requests.getCode());
					return response;
				}
			}
			{
				SocialInfoResponse subscribed = service.getSubscribed(userId, 0, 1, null);
				if (subscribed.getCode() == ResponseStatus.Ok)
				{
					SocialInfoResponseBody.UserInfoCollectionBody collection = subscribed.getBody().getUserInfoCollectionBody();
					if (collection != null)
						body.setSubscribedCount(collection.getTotal());
				}
				else
				{
					response.setCode(subscribed.getCode());
					return response;
				}
			}
			{
				SocialInfoResponse subscribers = service.getSubscribers(userId, 0, 1, null);
				if (subscribers.getCode() == ResponseStatus.Ok)
				{
					SocialInfoResponseBody.UserInfoCollectionBody collection = subscribers.getBody().getUserInfoCollectionBody();
					if (collection != null)
						body.setSubscribersCount(collection.getTotal());
				}
				else
				{
					response.setCode(subscribers.getCode());
					return response;
				}
			}
			return response;
		});
	}

	@NonNull
	public static BaseSpiceRequest<SocialInfoResponse> getSubscribed(@Nullable Integer userId, int page, int pageSize, @Nullable String filter)
	{
		return new BaseSpiceRequest<>(SocialInfoResponse.class, service -> service.getSubscribed(userId, page, pageSize, filter));
	}

	@NonNull
	public static BaseSpiceRequest<SocialInfoResponse> getSubscribers(@Nullable Integer userId, int page, int pageSize, @Nullable String filter)
	{
		if (BuildConfig.DEBUG && showFakeSubscribers)
		{
			return getFriends(userId, page, pageSize, filter);
		}
		else
		{
			return new BaseSpiceRequest<>(SocialInfoResponse.class, service -> service.getSubscribers(userId, page, pageSize, filter));
		}
	}

	@NonNull
	public static BaseSpiceRequest<UserResponse> getUser(int id)
	{
		return new BaseSpiceRequest<>(UserResponse.class, service -> service.getUser(id));
	}

	@NonNull
	public static BaseSpiceRequest<UserActivitiesResponse> getUserActivities(int page, int pageSize)
	{
		if (BuildConfig.DEBUG && showFakeUserActivity)
		{
			return new BaseSpiceRequest<>(UserActivitiesResponse.class, service -> {
				Thread.sleep(1500);

				UserActivitiesResponse result = new UserActivitiesResponse();
				result.setCode(ResponseStatus.Ok);
				final UserActivitiesResponseBody body = new UserActivitiesResponseBody();
				final UserActivitiesResponseBody.UserActivityCollectionBody collection = new UserActivitiesResponseBody.UserActivityCollectionBody();
				body.setUserActivityCollection(collection);
				result.setBody(body);

				Random random = new Random();

				UserDto userDto = service.getMe().getUser();
				List<DreamInfoDto> dreams = service.flybookList(null, 0, pageSize, null).getDreams();


				for (int i = 0; i < pageSize; i++)
				{
					UserInfoDto userInfoDto = new UserInfoDto();
					userInfoDto.setId(userDto.getId() + i);
					userInfoDto.setAge("" + random.nextInt(43));
					userInfoDto.setAvatarUrl(userDto.getAvatarUrl());
					userInfoDto.setFriend(random.nextBoolean());
					userInfoDto.setFriendshipRequestSent(random.nextBoolean());
					userInfoDto.setFullName(userDto.getFirstName() + random.nextInt());
					userInfoDto.setIsVip(random.nextBoolean());
					userInfoDto.setLocation(userDto.getLocation() + random.nextInt());
					userInfoDto.setSubscribed(random.nextBoolean());

					final UserActivityDto item = new UserActivityDto();
					item.setId(page * pageSize + i);
					item.setDate(new Date().toString());
					item.setUser(userInfoDto);
					item.setText("Long long long long long long long long long long long long long long long long text" + random.nextInt());

					collection.getActivities().add(item);

					switch (random.nextInt(3))
					{
						case 0:
							item.setDream(dreams.get(random.nextInt(dreams.size())));
							break;
						case 1:
							item.setPhotos(userDto.getPhotos());
							break;
					}
				}

				return result;
			});
		}
		else
		{
			return new BaseSpiceRequest<>(UserActivitiesResponse.class, service -> service.getUserActivities(page, pageSize));
		}
	}

	@NonNull
	public static BaseSpiceRequest<FlybookDreamsResponse> getUserFlybookList(Integer userId, int page, int pageSize, boolean withProposed, Boolean isDone)
	{
		return new BaseSpiceRequest<>(FlybookDreamsResponse.class, service -> {
			FlybookDreamsResponse response = new FlybookDreamsResponse();

			GetDreamsResponse dreamResponse = service.flybookList(userId, page, pageSize, isDone);
			if (dreamResponse.getCode() == ResponseStatus.Ok)
			{
				final GetDreamsResponseBody.DreamCollectionBody dreamCollection = dreamResponse.getBody().getDreamCollection();
				if (dreamCollection != null)
				{
					response.dreams = dreamCollection.getDreams();
					response.dreamTotal = dreamCollection.getTotal();
					response.status = ResponseStatus.Ok;
				}
				else
				{
					response.status = ResponseStatus.Error;
				}
			}
			else
			{
				response.status = dreamResponse.getCode();
				response.message = dreamResponse.getMessage();
			}

			try
			{
				if (withProposed && response.getStatus() == ResponseStatus.Ok)
				{
					if (BuildConfig.DEBUG && showFakeDreamProposed)
					{
						response.dreamProposed = new Random(System.currentTimeMillis()).nextInt(15);
					}
					else
					{
						DreamProposedResponse proposedDreamResponse = service.getDreamProposed(0, 1);
						if (proposedDreamResponse.getCode() == ResponseStatus.Ok)
						{
							final DreamProposedResponseBody.DreamCollectionBody dreamCollection = proposedDreamResponse.getBody().getDreamCollection();
							if (dreamCollection != null)
							{
								response.dreamProposed = dreamCollection.getTotal();
								response.status = ResponseStatus.Ok;
							}
							else
							{
								response.status = ResponseStatus.Error;
							}
						}
						else
						{
							response.status = proposedDreamResponse.getCode();
							response.message = proposedDreamResponse.getMessage();
						}
					}
				}
			}
			catch (Exception ex)
			{
				Log.e("RequestFactory", "getUserFlybookList", ex);
			}

			return response;
		});
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> likeComment(int commentId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.likeComment(new LikeCommentRequestBody(commentId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> likeDream(int dreamId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.likeDream(new LikeDreamRequestBody(dreamId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> likePost(int id)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.likePost(new EntityIdRequestBody(id)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> likePostComment(int id)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.likePostComment(new EntityIdRequestBody(id)));
	}

	@NonNull
	public static BaseSpiceRequest<AuthorizeUserResponse> login(@NonNull String login, @NonNull String password)
	{
		return new BaseSpiceRequest<>(AuthorizeUserResponse.class, service ->
		{
			AuthorizeUserResponse response = new AuthorizeUserResponse();

			LoginResponse loginResponse = service.login(new LoginRequestBody(login, password));
			if (loginResponse.getCode() != ResponseStatus.Ok)
			{
				response.setCode(loginResponse.getCode());
				response.setMessage(loginResponse.getMessage());
			}
			else
			{
				UserResponse userResponse = service.getMe(loginResponse.getToken());
				if (userResponse.getCode() != ResponseStatus.Ok)
				{
					response.setCode(userResponse.getCode());
					response.setMessage(userResponse.getMessage());
				}
				else
				{
					response.setCode(ResponseStatus.Ok);
					response.setMessage(userResponse.getMessage());
					response.setBody(new AuthorizeUserBody(loginResponse.getToken(), userResponse.getUser()));
				}
			}

			return response;
		});
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> markDone(int id, boolean done)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, 1, service -> service.markDone(new MarkDoneRequestBody(id, done)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> proposeDream(int dreamId, int userId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.proposeDream(new ProposeDreamRequestBody(dreamId, userId)));
	}

	@NonNull
	public static BaseSpiceRequest<AuthorizeUserResponse> register(@NonNull RegisterRequestBody registerRequest)
	{
		return new BaseSpiceRequest<>(AuthorizeUserResponse.class, service ->
		{
			AuthorizeUserResponse response = new AuthorizeUserResponse();

			RegisterResponse registerResponse = service.register(registerRequest);
			if (registerResponse.getCode() != ResponseStatus.Ok)
			{
				response.setCode(registerResponse.getCode());
				response.setMessage(registerResponse.getMessage());
			}
			else
			{
				UserResponse userResponse = service.getMe(registerResponse.getToken());
				if (userResponse.getCode() != ResponseStatus.Ok)
				{
					response.setCode(userResponse.getCode());
					response.setMessage(userResponse.getMessage());
				}
				else
				{
					response.setCode(ResponseStatus.Ok);
					response.setMessage(userResponse.getMessage());
					response.setBody(new AuthorizeUserBody(registerResponse.getToken(), userResponse.getUser()));
				}
			}

			return response;
		});
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> rejectProposedDream(int dreamId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.rejectProposedDream(new EntityIdRequestBody(dreamId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> requestFriendship(int userId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.requestFriendship(new EntityIdRequestBody(userId)));
	}

	public static BaseSpiceRequest<SavePhotosResponse> savePhotos(List<PhotosFragment.PhotoModel> forDelete, List<PhotosFragment.PhotoModel> newPhotos)
	{
		return new BaseSpiceRequest<>(SavePhotosResponse.class, service -> {
			SavePhotosResponse response = new SavePhotosResponse();

			try
			{
				List<Integer> ids = Stream.of(forDelete).filter(x -> x.getNewPhotoUrl() == null).map(PhotosFragment.PhotoModel::getId).collect(Collectors.toList());
				EmptyResponse deletePhotosResponse = service.deletePhotos(new DeletePhotosBody(ids));
				response.failedDeletePhotos = deletePhotosResponse.getCode() != ResponseStatus.Ok;
			}
			catch (Exception ex)
			{
				ex.printStackTrace();
				response.failedDeletePhotos = true;
			}

			for (PhotosFragment.PhotoModel it : newPhotos)
			{
				try
				{
					UploadPhotoResponse uploadPhotoResponse = service.uploadPhoto(new TypedFile("image/jpeg", new File(URI.create(it.getNewPhotoUrl()))));
					if (uploadPhotoResponse.getCode() != ResponseStatus.Ok)
					{
						response.failedSavePhotos.add(it);
					}
					else
					{
						response.savedPhotos.add(new android.util.Pair<>(uploadPhotoResponse.getBody(), it));
					}
				}
				catch (Exception ex)
				{
					ex.printStackTrace();
					response.failedSavePhotos.add(it);
				}
			}

			return response;
		});
	}

	@NonNull
	public static BaseSpiceRequest<SearchUserResponse> searchUsers(int page, int pageSize, @NonNull FilterUser filter)
	{
		final Integer countryId = filter.getCountry() != null ? filter.getCountry().getId() : null;
		final Integer cityId = filter.getCity() != null ? filter.getCity().getId() : null;
		return new BaseSpiceRequest<>(SearchUserResponse.class, service ->
				service.searchUsers(page, pageSize, filter.getAgeRange(), filter.getSexType(), countryId, cityId,
						boolean2Integer(filter.getPopular()), boolean2Integer(filter.getNewUsers()), boolean2Integer(filter.getOnline()), boolean2Integer(filter.getVip())));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> subscribe(int userId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.subscribe(new EntityIdRequestBody(userId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> takeDream(int dreamId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.takeDream(new TakeDreamRequestBody(dreamId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> unfriend(int userId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.unfriend(new EntityIdRequestBody(userId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> unlikeComment(int commentId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.unlikeComment(new UnlikeCommentRequestBody(commentId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> unlikeDream(int dreamId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.unlikeDream(new UnlikeDreamRequestBody(dreamId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> unlikePost(int id)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.unlikePost(new EntityIdRequestBody(id)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> unlikePostComment(int id)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.unlikePostComment(new EntityIdRequestBody(id)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> unsubscribe(int userId)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.unsubscribe(new EntityIdRequestBody(userId)));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> updateDream(int id, String name, String description, File imageFilePath, boolean isDone)
	{
		TypedFile typedFile = imageFilePath != null ? new TypedFile("image/jpeg", imageFilePath) : null;
		return new BaseSpiceRequest<>(EmptyResponse.class, 1, service -> service.updateDream(id, name, description, typedFile, isDone));
	}

	@NonNull
	public static BaseSpiceRequest<EmptyResponse> updatePost(int id, String title, String description, File imageFilePath)
	{
		return new BaseSpiceRequest<>(EmptyResponse.class, service -> service.updatePost(id, title, description, new TypedFile("image/jpeg", imageFilePath)));
	}

	@NonNull
	public static BaseSpiceRequest<UpdateProfileResponse> updateUser(EditUserFragment.EditModel model)
	{
		return new BaseSpiceRequest<>(UpdateProfileResponse.class, service -> {
			UpdateProfileResponse response = new UpdateProfileResponse();
			response.setCode(ResponseStatus.Ok);

			try
			{
				EmptyResponse updateUserResponse = service.updateUser(new UpdateUserBody(model));
				response.saveInfoSuccesses = updateUserResponse.getCode() == ResponseStatus.Ok;

				if (updateUserResponse.getCode() == ResponseStatus.Unauthorized)
				{
					response.setMessage(updateUserResponse.getMessage());
					response.setCode(updateUserResponse.getCode());
					return response;
				}
			}
			catch (Exception ex)
			{
				ex.printStackTrace();

				response.setCode(ResponseStatus.Error);
				response.saveInfoSuccesses = false;
			}

			if (model.avatar != null)
			{
				try
				{
					String path = AccessStorageApi.getPath(MyDreamsApplication.getInstance(), model.avatar);
					if (path != null)
					{
						UploadAvatarResponse uploadAvatarResponse = service.uploadAvatar(new TypedFile("image/jpeg", new File(path)));
						if (uploadAvatarResponse.getCode() == ResponseStatus.Ok)
						{
							UpdateProfileBody body = new UpdateProfileBody();
							body.setAvatarUrl(uploadAvatarResponse.getBody().getAvatarUrl());

							response.setBody(body);
							response.saveAvatarSuccesses = true;
						}
						else
						{
							response.setCode(uploadAvatarResponse.getCode());
							response.setMessage(uploadAvatarResponse.getMessage());

							if (uploadAvatarResponse.getCode() == ResponseStatus.Unauthorized)
							{
								response.setMessage(uploadAvatarResponse.getMessage());
								response.setCode(ResponseStatus.Unauthorized);
								return response;
							}
						}
					}
					else
					{
						response.setCode(ResponseStatus.Error);
					}
				}
				catch (Exception ex)
				{
					ex.printStackTrace();

					response.setCode(ResponseStatus.Error);
					response.saveAvatarSuccesses = false;
				}
			}

			return response;
		});
	}

	public static class SavePhotosResponse
	{
		public boolean failedDeletePhotos;
		public List<PhotosFragment.PhotoModel> failedSavePhotos = new ArrayList<>();
		public List<Pair<PhotoDto, PhotosFragment.PhotoModel>> savedPhotos = new ArrayList<>();
	}

	public static class FlybookDreamsResponse
	{
		private int dreamTotal;
		private List<DreamInfoDto> dreams;
		private Integer dreamProposed;
		private ResponseStatus status;
		private String message;

		public Integer getDreamProposed()
		{
			return dreamProposed;
		}

		public int getDreamTotal()
		{
			return dreamTotal;
		}

		public List<DreamInfoDto> getDreams()
		{
			return dreams;
		}

		public String getMessage()
		{
			return message;
		}

		public ResponseStatus getStatus()
		{
			return status;
		}
	}
}
