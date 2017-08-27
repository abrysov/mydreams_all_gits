package com.mydreams.android;

import com.google.gson.Gson;
import com.mydreams.android.service.gson.MyDreamsGsonBuilder;
import com.mydreams.android.service.models.ResponseStatus;

import junit.framework.Assert;
import junit.framework.TestCase;

import java.io.IOException;

public class ResponseStatusAdapterTest extends TestCase
{
	public void testSerialize() throws IOException
	{
		Gson gson = MyDreamsGsonBuilder.Build();

		for (ResponseStatus value : ResponseStatus.values())
		{
			String json = gson.toJson(value);
			Assert.assertEquals(json, String.valueOf(value.getId()));
		}
	}

	public void testDeserialize() throws IOException
	{
		Gson gson = MyDreamsGsonBuilder.Build();

		for (ResponseStatus value : ResponseStatus.values())
		{
			String json = String.valueOf(value.getId());
			ResponseStatus testValue = gson.fromJson(json, ResponseStatus.class);
			Assert.assertEquals(testValue, value);
		}
	}

	public void testFailedDeserialize() throws IOException
	{
		Gson gson = MyDreamsGsonBuilder.Build();
		ResponseStatus testValue = gson.fromJson("100500", ResponseStatus.class);
		Assert.assertEquals(testValue, ResponseStatus.Unknown);
	}
}
