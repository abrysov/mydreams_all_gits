package com.mydreams.android.service.request.spice;

import com.mydreams.android.service.retrofit.IMyDreamsService;
import com.octo.android.robospice.request.retrofit.RetrofitSpiceRequest;
import com.octo.android.robospice.retry.DefaultRetryPolicy;

public class BaseSpiceRequest<TResponse> extends RetrofitSpiceRequest<TResponse, IMyDreamsService>
{
	private IExecuteRequest<TResponse> executeRequest;

	public BaseSpiceRequest(Class<TResponse> clazz, int retryCount, IExecuteRequest<TResponse> executeRequest)
	{
		this(clazz, executeRequest);
		setRetryPolicy(new DefaultRetryPolicy(retryCount, DefaultRetryPolicy.DEFAULT_DELAY_BEFORE_RETRY, DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
	}

	public BaseSpiceRequest(Class<TResponse> clazz, IExecuteRequest<TResponse> executeRequest)
	{
		super(clazz, IMyDreamsService.class);
		this.executeRequest = executeRequest;
	}

	@Override
	public TResponse loadDataFromNetwork() throws Exception
	{
		return executeRequest.execute(getService());
	}

	public interface IExecuteRequest<TResponse>
	{
		TResponse execute(IMyDreamsService service) throws Exception;
	}
}
