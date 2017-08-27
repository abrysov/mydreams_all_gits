package com.mydreams.android.service.gson;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mydreams.android.service.gson.adapters.AgeRangeAdapter;
import com.mydreams.android.service.gson.adapters.ResponseStatusAdapter;
import com.mydreams.android.service.gson.adapters.SexTypeAdapter;
import com.mydreams.android.service.models.AgeRange;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.models.SexType;

public final class MyDreamsGsonBuilder
{
	public static Gson Build()
	{
		GsonBuilder builder = new GsonBuilder();

		builder.registerTypeAdapter(ResponseStatus.class, new ResponseStatusAdapter());
		builder.registerTypeAdapter(SexType.class, new SexTypeAdapter());
		builder.registerTypeAdapter(AgeRange.class, new AgeRangeAdapter());

		return builder.create();
	}
}
