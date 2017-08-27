package com.mydreams.android;

import com.google.gson.Gson;
import com.mydreams.android.service.gson.MyDreamsGsonBuilder;
import com.mydreams.android.service.models.SexType;

import junit.framework.Assert;
import junit.framework.TestCase;

import java.io.IOException;

public class SexTypeAdapterTest extends TestCase
{
	public void testSerialize() throws IOException
	{
		Gson gson = MyDreamsGsonBuilder.Build();

		for (SexType value : SexType.values())
		{
			String json = gson.toJson(value);
			Assert.assertEquals(json, String.valueOf(value.getId()));
		}
	}

	public void testDeserialize() throws IOException
	{
		Gson gson = MyDreamsGsonBuilder.Build();

		for (SexType value : SexType.values())
		{
			String json = String.valueOf(value.getId());
			SexType testValue = gson.fromJson(json, SexType.class);
			Assert.assertEquals(testValue, value);
		}
	}

	public void testFailedDeserialize() throws IOException
	{
		Gson gson = MyDreamsGsonBuilder.Build();
		SexType testValue = gson.fromJson("100500", SexType.class);
		Assert.assertEquals(testValue, SexType.Unknown);
	}
}
