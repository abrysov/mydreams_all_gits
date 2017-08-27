package com.mydreams.android.service.response;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.ResponseStatus;

public class BaseServiceResponse<T>
{
	@NonNull
	@SerializedName("code")
	private ResponseStatus code;

	@Nullable
	@SerializedName("message")
	private String message;

	@Nullable
	@SerializedName("body")
	private T body;

	public BaseServiceResponse()
	{
		this.code = ResponseStatus.Unknown;
	}

	@NonNull
	public T getBody()
	{
		if (body == null)
			throw new NullPointerException();

		return body;
	}

	public void setBody(@Nullable T body)
	{
		this.body = body;
	}

	@NonNull
	public ResponseStatus getCode()
	{
		return code;
	}

	public void setCode(@NonNull ResponseStatus code)
	{
		this.code = code;
	}

	@Nullable
	public String getMessage()
	{
		return message;
	}

	public void setMessage(@Nullable String message)
	{
		this.message = message;
	}
}
