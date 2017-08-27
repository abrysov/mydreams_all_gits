package com.mydreams.android.service.response.bodys;

public class SocialStatResponseBody
{
	private int friendCount;
	private int requestCount;
	private int subscribedCount;
	private int subscribersCount;

	public int getFriendCount()
	{
		return friendCount;
	}

	public void setFriendCount(final int friendCount)
	{
		this.friendCount = friendCount;
	}

	public int getRequestCount()
	{
		return requestCount;
	}

	public void setRequestCount(final int requestCount)
	{
		this.requestCount = requestCount;
	}

	public int getSubscribedCount()
	{
		return subscribedCount;
	}

	public void setSubscribedCount(final int subscribedCount)
	{
		this.subscribedCount = subscribedCount;
	}

	public int getSubscribersCount()
	{
		return subscribersCount;
	}

	public void setSubscribersCount(final int subscribersCount)
	{
		this.subscribersCount = subscribersCount;
	}
}
