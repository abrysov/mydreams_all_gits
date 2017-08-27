package com.mydreams.android.service;

import android.app.Application;
import android.support.annotation.NonNull;

import com.google.gson.Gson;
import com.mydreams.android.BuildConfig;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.service.gson.MyDreamsGsonBuilder;
import com.mydreams.android.service.response.LocationsResponse;
import com.mydreams.android.service.retrofit.IMyDreamsService;
import com.octo.android.robospice.persistence.CacheManager;
import com.octo.android.robospice.persistence.Persister;
import com.octo.android.robospice.persistence.exception.CacheCreationException;
import com.octo.android.robospice.persistence.memory.LruCache;
import com.octo.android.robospice.persistence.memory.LruCacheObjectPersister;
import com.octo.android.robospice.persistence.retrofit.RetrofitObjectPersisterFactory;
import com.octo.android.robospice.retrofit.RetrofitSpiceService;
import com.squareup.okhttp.OkHttpClient;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import retrofit.RestAdapter;
import retrofit.client.OkClient;
import retrofit.converter.Converter;
import retrofit.converter.GsonConverter;

public class MyDreamsSpiceService extends RetrofitSpiceService
{
	public static final String BASE_URL = "http://master.evrone-dreams-fd99d29315f0df8ad6bc.ttrcloud.com";
	public static final String BASE_API_URL = BASE_URL + "/api";
	public static final String LEGAL_URL = BASE_API_URL + "/docs/legal";

	@Override
	public CacheManager createCacheManager(Application application) throws CacheCreationException
	{
		CacheManager result = new CacheManager();

		Persister filePersister = new RetrofitObjectPersisterFactory(application, getConverter(), getFileCachedClass());
		Persister locationsResponseMemoryPersister = new LruCacheObjectPersister<>(LocationsResponse.class, new LruCache<>(10));

		result.addPersister(filePersister);
		result.addPersister(locationsResponseMemoryPersister);

		return result;
	}

	@Override
	@NonNull
	protected Converter createConverter()
	{
		return new GsonConverter(createGson());
	}

	@Override
	protected RestAdapter.Builder createRestAdapterBuilder()
	{
		OkHttpClient httpClient = new OkHttpClient();
		httpClient.setConnectTimeout(1, TimeUnit.MINUTES);
		httpClient.setReadTimeout(2, TimeUnit.MINUTES);
		httpClient.setWriteTimeout(3, TimeUnit.MINUTES);

		return super.createRestAdapterBuilder()
				.setRequestInterceptor(new RetrofitInterceptor(new UserPreference(this)))
				.setClient(new OkClient(httpClient))
				.setLogLevel(BuildConfig.DEBUG ? RestAdapter.LogLevel.FULL : RestAdapter.LogLevel.BASIC);
	}

	@Override
	@NonNull
	protected String getServerUrl()
	{
		return BASE_API_URL;
	}

	@Override
	public void onCreate()
	{
		super.onCreate();
		addRetrofitInterface(IMyDreamsService.class);
	}

	@NonNull
	private Gson createGson()
	{
		return MyDreamsGsonBuilder.Build();
	}

	@NonNull
	private List<Class<?>> getFileCachedClass()
	{
		return new ArrayList<>();
	}
}
